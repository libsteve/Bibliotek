//
//  BibMARC21Reader.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/5/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMARC21Reader.h"
#import "BibMARC21Reader+Internal.h"

#import "BibMetadata+Internal.h"
#import "BibInputStream.h"

#import "BibRecord.h"
#import "BibLeader.h"
#import "BibFieldTag.h"
#import "BibDirectoryEntry.h"
#import "BibControlField.h"
#import "BibContentField.h"
#import "BibContentIndicators.h"
#import "BibSubfield.h"

static uint8_t const kRecordTerminator  = 0x1D;
static uint8_t const kFieldTerminator   = 0x1E;
static uint8_t const kSubfieldDelimiter = 0x1F;

NSErrorDomain const BibMARC21ReaderErrorDomain = @"BibMARC21ReaderErrorDomain";

@implementation BibMARC21Reader {
    BibInputStream *_inputStream;
}

- (instancetype)init {
    return [self initWithData:[NSData data]];
}

- (instancetype)initWithURL:(NSURL *)url {
    return [self initWithInputStream:[NSInputStream inputStreamWithURL:url]];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithInputStream:[NSInputStream inputStreamWithData:data]];
}

- (instancetype)initWithFileAtPath:(NSString *)path {
    NSInputStream *const inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    return (inputStream) ? [self initWithInputStream:inputStream] : nil;
}

- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    if (self = [super init]) {
        _inputStream = [[BibInputStream alloc] initWithInputStream:inputStream];
    }
    return self;
}

+ (instancetype)readerWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

+ (instancetype)readerWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

+ (instancetype)readerWithFileAtPath:(NSString *)path {
    return [[self alloc] initWithFileAtPath:path];
}

+ (instancetype)readerWithInputStream:(NSInputStream *)inputStream {
    return [[self alloc] initWithInputStream:inputStream];
}

- (BibRecord *)readRecord:(out NSError *__autoreleasing *)error {
    NSUInteger numberOfBytesRead = 0;
    BibLeader *const leader = [self readLeader:error];
    if (leader == nil) {
        return nil;
    }
    numberOfBytesRead += BibLeaderRawDataLength;
    NSRange const recordRange = [leader recordRange];
    NSUInteger const entryLength = 3 + [leader lengthOfLengthOfField] + [leader lengthOfFieldLocation];
    NSMutableArray<BibDirectoryEntry *> *const directory = [NSMutableArray array];
    while (numberOfBytesRead < recordRange.location - 1) {
        BibDirectoryEntry *const entry = [self readEntryWithLeader:leader error:error];
        if (entry == nil) {
            return nil;
        }
        [directory addObject:entry];
        numberOfBytesRead += entryLength;
    }
    if (![_inputStream readFieldTerminator:error]) {
        return nil;
    }
    NSMutableArray *const controlFields = [NSMutableArray array];
    NSMutableArray *const contentFields = [NSMutableArray array];
    for (BibDirectoryEntry *const entry in directory) {
        if ([[entry tag] isControlFieldTag]) {
            if ([contentFields count] != 0) {
                _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                         @"Control fields must preceed all content fields");
                return nil;
            }
            BibControlField *const field = [self readControlFieldWithLeader:leader directoryEntry:entry error:error];
            if (field == nil) {
                return nil;
            }
            [controlFields addObject:field];
        } else {
            if ([controlFields count] == 0) {
                _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                         @"At least one control field must preceed all content fields");
                return nil;
            }
            BibContentField *const field = [self readContentFieldWithLeader:leader directoryEntry:entry error:error];
            if (field == nil) {
                return nil;
            }
            [contentFields addObject:field];
        }
    }
    if (![_inputStream readRecordTerminator:error]) {
        return nil;
    }
    return [[BibRecord alloc] initWithKind:[leader recordKind]
                                    status:[leader recordStatus]
                             controlFields:controlFields
                             contentFields:contentFields];
}

@end

#pragma mark - Internal

@implementation BibMARC21Reader (Internal)

- (BibLeader *)readLeader:(out NSError *__autoreleasing *)error {
    uint8_t buffer[BibLeaderRawDataLength];
    NSUInteger const result = [_inputStream readBytes:buffer length:BibLeaderRawDataLength error:error];
    if (result != BibLeaderRawDataLength) {
        return nil;
    }
    NSData *const data = [NSData dataWithBytes:buffer length:BibLeaderRawDataLength];
    return [[BibLeader alloc] initWithData:data];
}

static NSUInteger sReadUnsignedInteger(NSData *const data, NSRange const range, NSError *__autoreleasing *error) {
    NSUInteger value = 0;
    NSUInteger const endIndex = NSMaxRange(range);
    for (NSUInteger power = 0; power < range.length; power += 1) {
        NSUInteger const index = endIndex - 1 - power;
        int8_t digit;
        [data getBytes:&digit range:NSMakeRange(index, 1)];
        digit -= '0';
        if (digit < 0 || digit > 9) {
            NSString *const rawString = [[NSString alloc] initWithData:[data subdataWithRange:range]
                                                              encoding:NSASCIIStringEncoding];
            _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                     @"Cannot read \"%@\" as an unsigned integer", rawString);
            return NSNotFound;
        }
        value += (NSUInteger)digit * (NSUInteger)pow(10, (double)power);
    }
    return value;
}

- (BibDirectoryEntry *)readEntryWithLeader:(BibLeader *)leader
                                     error:(out NSError *__autoreleasing *)error {
    NSUInteger const lengthOfLengthOfField = [leader lengthOfLengthOfField];
    NSUInteger const lengthOfFieldLocation = [leader lengthOfFieldLocation];
    NSUInteger const byteCount = 3 + lengthOfLengthOfField + lengthOfFieldLocation;
    uint8_t *const buffer = calloc(byteCount, sizeof(uint8_t));
    if ([_inputStream readBytes:buffer length:byteCount error:error] != byteCount) {
        free(buffer);
        return nil;
    }
    NSData *const data = [NSData dataWithBytesNoCopy:buffer length:byteCount];
    NSData *const tagData = [data subdataWithRange:NSMakeRange(0, 3)];
    NSString *const tagString = [[NSString alloc] initWithData:tagData encoding:NSASCIIStringEncoding];
    BibFieldTag *const tag = [[BibFieldTag alloc] initWithString:tagString];
    if (tag == nil) {
        _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                 @"Field tags must be exactly 3 ASCII characters");
        return nil;
    }
    NSRange const lengthOfFieldRange = NSMakeRange(3, lengthOfLengthOfField);
    NSUInteger const lengthOfField = sReadUnsignedInteger(data, lengthOfFieldRange, error);
    NSRange const fieldLocationRange = NSMakeRange(3 + lengthOfLengthOfField, lengthOfFieldLocation);
    NSUInteger const fieldLocation = sReadUnsignedInteger(data, fieldLocationRange, error);
    if (lengthOfField == NSNotFound || fieldLocation == NSNotFound) {
        _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError, @"Invalid data range in directory entry");
        return nil;
    }
    return [[BibDirectoryEntry alloc] initWithTag:tag range:NSMakeRange(fieldLocation, lengthOfField)];
}

- (BibControlField *)readControlFieldWithLeader:(BibLeader *)leader
                                 directoryEntry:(BibDirectoryEntry *)directoryEntry
                                          error:(out NSError *__autoreleasing *)error {
    NSData *const data = [_inputStream readDataForDirectoryEntry:directoryEntry error:error];
    if (data == nil) {
        return nil;
    }
    NSString *const value = [NSString bib_stringWithData:data encoding:[leader recordEncoding] error:error];
    return [[BibControlField alloc] initWithTag:[directoryEntry tag] value:value];
}

- (BibContentField *)readContentFieldWithLeader:(BibLeader *)leader
                                 directoryEntry:(BibDirectoryEntry *)directoryEntry
                                          error:(out NSError *__autoreleasing *)error {
    return [[[_BibMARC21ContentFieldReader alloc] initWithInputStream:_inputStream
                                                               leader:leader
                                                                entry:directoryEntry
                                                                error:error] readContentFieldWithError:error];
}

@end

#pragma mark - Content Field Reader

@implementation _BibMARC21ContentFieldReader {
    BibInputStream *_inputStream;
    NSUInteger _lengthOfSubfieldCode;
    NSUInteger _numberOfIndicators;
    BibEncoding _encoding;
    BibDirectoryEntry *_entry;
    BibFieldTag *_tag;
}

- (instancetype)initWithInputStream:(BibInputStream *)inputStream
                             leader:(BibLeader *)leader
                              entry:(BibDirectoryEntry *)entry
                              error:(out NSError * _Nullable __autoreleasing *)error {
    BibInputStream *const stream = [inputStream inputStreamForDirectoryEntry:entry error:error];
    if (stream == nil) {
        return nil;
    }
    if (self = [super init]) {
        _inputStream = stream;
        _lengthOfSubfieldCode = [leader lengthOfSubfieldCode];
        _numberOfIndicators = [leader numberOfIndicators];
        _encoding = [leader recordEncoding];
        _entry = entry;

    }
    return self;
}

- (instancetype)init {
    NSInputStream *const inputStream = [NSInputStream inputStreamWithData:[NSData data]];
    return [self initWithInputStream:[[BibInputStream alloc] initWithInputStream:inputStream]
                              leader:[[BibLeader alloc] init]
                               entry:[[BibDirectoryEntry alloc] init]
                               error:nil];
}

- (BibContentField *)readContentFieldWithError:(out NSError * _Nullable __autoreleasing *)error {
    BibContentIndicators *const indicators = [self readContentIndicatorsWithError:error];
    if (indicators == nil) {
        return nil;
    }
    uint8_t byte;
    if ([_inputStream readBytes:&byte length:1 error:error] != 1) {
        return nil;
    }
    NSMutableArray<BibSubfield *> *const subfields = [NSMutableArray array];
    while (byte != kFieldTerminator) {
        if (byte != kSubfieldDelimiter) {
            _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                     @"Subfields must begin with a subfield delimiter (%#04x)", kSubfieldDelimiter);
            return nil;
        }
        BibSubfieldCode const code = [self readSubfieldCodeWithError:error];
        if (code == nil) {
            return nil;
        }
        NSString *const content = [self readSubfieldContentWithDelimiter:&byte error:error];
        if (content == nil) {
            return nil;
        }
        [subfields addObject:[[BibSubfield alloc] initWithCode:code content:content]];
    }
    if ([_inputStream numberOfBytesRead] != [_entry range].length) {
        _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                 @"Content field contains a premature field terminator (%#04x)", kFieldTerminator);
        return nil;
    }
    return [[BibContentField alloc] initWithTag:[_entry tag] indicators:indicators subfields:subfields];
}

@end

@implementation _BibMARC21ContentFieldReader (ContentField)

- (BibContentIndicators *)readContentIndicatorsWithError:(out NSError * _Nullable __autoreleasing *)error {
    uint8_t *const buffer = calloc(_numberOfIndicators, sizeof(BibContentIndicator));
    if ([_inputStream readBytes:buffer length:_numberOfIndicators error:error] != _numberOfIndicators) {
        free(buffer);
        return nil;
    }
    BibContentIndicator *const rawIndicators = (BibContentIndicator *)buffer;
    BibContentIndicators *const indicators = [[BibContentIndicators alloc] initWithIndicators:rawIndicators
                                                                                        count:_numberOfIndicators];
    free(buffer);
    return indicators;
}

- (BibSubfieldCode)readSubfieldCodeWithError:(out NSError * _Nullable __autoreleasing *)error {
    uint8_t *rawSubfieldCode = calloc(_lengthOfSubfieldCode, sizeof(uint8_t));
    NSData *const subfieldCodeData = [NSData dataWithBytesNoCopy:rawSubfieldCode length:_lengthOfSubfieldCode];
    if ([_inputStream readBytes:rawSubfieldCode length:_lengthOfSubfieldCode error:error] != _lengthOfSubfieldCode) {
        return nil;
    }
    for (NSUInteger index = 0; index < _lengthOfSubfieldCode; index += 1) {
        uint8_t const code = rawSubfieldCode[index];
        switch (code) {
            case kSubfieldDelimiter:
                _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                         @"Subfield codes cannot contain a subfield delimiter (%#04x)", code);
                return nil;
            case kFieldTerminator:
                _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                         @"Subfield codes cannot contain a field terminator (%#04x)", code);
                return nil;
            case kRecordTerminator:
                _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                         @"Subfield codes cannot contain a record terminator (%#04x)", code);
                return nil;
            default:
                break;
        }
        // TODO: Validate as ASCII graphic character
    }
    return [[NSString alloc] initWithData:subfieldCodeData encoding:NSASCIIStringEncoding];
}

- (NSString *)readSubfieldContentWithDelimiter:(out uint8_t *)delimiter error:(out NSError *__autoreleasing *)error {
    BibSubfieldCode const code = [self readSubfieldCodeWithError:error];
    if (code == nil) {
        return nil;
    }
    NSString *content = nil;
    NSMutableData *const contentData = [NSMutableData data];
    for (uint8_t byte = 0; byte != kFieldTerminator && byte != kSubfieldDelimiter; ) {
        if ([_inputStream readBytes:&byte length:1 error:error] != 1) {
            return nil;
        }
        switch (byte) {
            case kRecordTerminator:
                _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                         @"Content field contains a record terminator (%#04x)", kRecordTerminator);
                return nil;
            case kFieldTerminator:
            case kSubfieldDelimiter:
                *delimiter = byte;
                content = [NSString bib_stringWithData:contentData encoding:_encoding error:error];
                if (content == nil) {
                    return nil;
                }
                break;
            default:
                [contentData appendBytes:&byte length:1];
                break;
        }
    }
    return content;
}

@end

#pragma mark - Input Stream

@implementation BibInputStream (MARC21Reader)

- (NSData *)readDataForDirectoryEntry:(BibDirectoryEntry *)entry error:(out NSError *__autoreleasing *)error {
    NSUInteger const byteCount = [entry range].length;
    uint8_t *const buffer = calloc(byteCount, sizeof(uint8_t));
    NSData *const data = [NSData dataWithBytesNoCopy:buffer length:byteCount freeWhenDone:YES];
    if ([self readBytes:buffer length:byteCount error:error] != byteCount) {
        return nil;
    }
    if (buffer[byteCount - 1] != kFieldTerminator) {
        _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                 @"Field data must end with a field terminator (%#04x)", kFieldTerminator);
        return nil;
    }
    return data;
}

- (BibInputStream *)inputStreamForDirectoryEntry:(BibDirectoryEntry *)entry error:(out NSError *__autoreleasing *)error {
    NSData *const data = [self readDataForDirectoryEntry:entry error:error];
    return (data) ? [BibInputStream inputStreamWithData:data] : nil;
}

- (BOOL)readFieldTerminator:(out NSError * _Nullable __autoreleasing *)error {
    uint8_t byte;
    if ([self readBytes:&byte length:1 error:error] != 1) {
        return NO;
    }
    if (error && byte != kFieldTerminator) {
        _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                 @"Expected to read a field terminator (%#04x)", kFieldTerminator);
        return NO;
    }
    return (byte == kFieldTerminator);
}

- (BOOL)readRecordTerminator:(out NSError * _Nullable __autoreleasing *)error {
    uint8_t byte;
    if ([self readBytes:&byte length:1 error:error] != 1) {
        return NO;
    }
    if (error && byte != kRecordTerminator) {
        _BibMARC21ReaderSetError(error, BibMARC21ReaderMalformedDataError,
                                 @"Expected to read a record terminator %#04x", kRecordTerminator);
        return NO;
    }
    return (byte == kRecordTerminator);
}

@end

#pragma mark - Malformed Data Error

void _BibMARC21ReaderSetError(NSError *__autoreleasing *const error,
                              BibMARC21ReaderErrorCode const code,
                              NSString *const format, ...) {
    if (error == NULL) { return; }
    va_list args;
    va_start(args, format);
    NSString *const message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    *error = [NSError errorWithDomain:BibMARC21ReaderErrorDomain code:code
                             userInfo:@{ NSDebugDescriptionErrorKey : message }];
}
