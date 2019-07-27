//
//  BibMARCInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMARCInputStream.h"
#import "BibMARCInputStream+Internal.h"
#import "BibInputStream.h"

#import "BibMetadata+Internal.h"

#import "BibRecord.h"
#import "BibLeader.h"
#import "BibFieldTag.h"
#import "BibDirectoryEntry.h"
#import "BibControlField.h"
#import "BibContentField.h"
#import "BibContentIndicatorList.h"
#import "BibSubfield.h"

static uint8_t const kRecordTerminator  = 0x1D;
static uint8_t const kFieldTerminator   = 0x1E;
static uint8_t const kSubfieldDelimiter = 0x1F;

NSErrorDomain const BibMARCInputStreamErrorDomain = @"BibMARCInputStreamErrorDomain";

#define SET_ERR_PTR(ERRPTR, VALUE) ({ if (ERRPTR) { *(ERRPTR) = (VALUE); } })

@implementation BibMARCInputStream {
    BibInputStream *_inputStream;
    NSStreamStatus _streamStatus;
    NSError *_streamError;
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
        _inputStream = [BibInputStream inputStreamWithInputStream:inputStream];
        _streamStatus = NSStreamStatusNotOpen;
    }
    return self;
}

+ (instancetype)inputStreamWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

+ (instancetype)inputStreamWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

+ (instancetype)inputStreamWithFileAtPath:(NSString *)path {
    return [[self alloc] initWithFileAtPath:path];
}

+ (instancetype)inputStreamWithInputStream:(NSInputStream *)inputStream {
    return [[self alloc] initWithInputStream:inputStream];
}

- (void)dealloc {
    [_inputStream close];
}

- (NSStreamStatus)streamStatus {
    return (_streamStatus == NSStreamStatusError) ? _streamStatus : [_inputStream streamStatus];
}

- (NSError *)streamError {
    return (_streamStatus == NSStreamStatusError) ? (_streamError ?: [_inputStream streamError]) : nil;
}

- (instancetype)open {
    _streamError = nil;
    [_inputStream open];
    _streamStatus = [_inputStream streamStatus];
    return self;
}

- (instancetype)close {
    _streamError = nil;
    [_inputStream close];
    _streamStatus = [_inputStream streamStatus];
    return self;
}

- (BibRecord *)readRecord:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSUInteger const initialBytesRead = [_inputStream numberOfBytesRead];
    BibLeader *const leader = [self readLeader:error];
    if (leader == nil) { return nil; }
    NSMutableArray *const directory = [NSMutableArray array];
    uint8_t byte = 0;
    while ([_inputStream peekByte:&byte error:NULL] && byte != kFieldTerminator) {
        BibDirectoryEntry *const directoryEntry = [self readDirectoryEntryWithLeader:leader error:error];
        if (directoryEntry == nil) { return nil; }
        [directory addObject:directoryEntry];
    }
    if (![_inputStream readBytes:&byte length:1 error:error]) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    if (byte != kFieldTerminator) {
        _streamStatus = NSStreamStatusError;
        NSString *const message =
            [NSString stringWithFormat: @"Directory data must end with a field terminator (%#04x)", kFieldTerminator];
        _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                           code:BibMARCInputStreamMalformedDataError
                                       userInfo:@{ NSDebugDescriptionErrorKey :message }];
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSMutableArray *const controlFields = [NSMutableArray array];
    NSMutableArray *const contentFields = [NSMutableArray array];
    for (BibDirectoryEntry *directoryEntry in directory) {
        if ([[directoryEntry tag] isControlFieldTag]) {
            if ([contentFields count] > 0) {
                _streamStatus = NSStreamStatusError;
                _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                                   code:BibMARCInputStreamMalformedDataError
                                               userInfo:nil];
                if (error) { *error = _streamError; }
                return nil;
            }
            BibControlField *const controlField = [self readControlFieldWithLeader:leader
                                                                    directoryEntry:directoryEntry
                                                                             error:error];
            if (controlField == nil) { return nil; }
            [controlFields addObject:controlField];
        } else {
            if ([controlFields count] == 0) {
                _streamStatus = NSStreamStatusError;
                _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                                   code:BibMARCInputStreamMalformedDataError
                                               userInfo:nil];
                if (error) { *error = _streamError; }
                return nil;
            }
            BibContentField *const contentField = [self readContentFieldWithLeader:leader
                                                                    directoryEntry:directoryEntry
                                                                             error:error];
            if (contentField == nil) { return nil; }
            [contentFields addObject:contentField];
        }
    }
    if (![_inputStream readByte:&byte error:error]) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    if (byte != kRecordTerminator) {
        _streamStatus = NSStreamStatusError;
        NSString *const message =
            [NSString stringWithFormat:@"Record data must end with a record terminator (%#04x)", kRecordTerminator];
        _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                           code:BibMARCInputStreamMalformedDataError
                                       userInfo:@{ NSDebugDescriptionErrorKey : message }];
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSUInteger const totalBytesRead = [_inputStream numberOfBytesRead] - initialBytesRead;
    if (NSMaxRange([leader recordRange]) != totalBytesRead) {
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                           code:BibMARCInputStreamMalformedDataError
                                       userInfo:@{ NSDebugDescriptionErrorKey : @"Record is not the expected size" }];
        if (error) { *error = _streamError; }
        return nil;
    }
    return [[BibRecord alloc] initWithKind:[leader recordKind] status:[leader recordStatus]
                             controlFields:controlFields contentFields:contentFields];
}

@end

#pragma mark -

@implementation BibMARCInputStream (Internal)

- (BibLeader *)readLeader:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    uint8_t buffer[BibLeaderRawDataLength];
    if ([_inputStream readBytes:buffer length:BibLeaderRawDataLength error:error]) {
        NSData *const data = [NSData dataWithBytes:buffer length:BibLeaderRawDataLength];
        return [[BibLeader alloc] initWithData:data];
    }
    _streamStatus = NSStreamStatusError;
    return nil;
}

- (BibFieldTag *)readFieldTag:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSString *const tagString = [_inputStream readStringWithLength:3 encoding:NSASCIIStringEncoding error:error];
    if (tagString == nil) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    BibFieldTag *const tag = [[BibFieldTag alloc] initWithString:tagString];
    if (tag == nil) {
        _streamStatus = NSStreamStatusError;
        NSString *const debugDescription = @"Field tags must be exactly 3 ASCII characters";
        _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                           code:BibMARCInputStreamMalformedDataError
                                       userInfo:@{ NSDebugDescriptionErrorKey : debugDescription }];
        if (error) { *error = [self streamError]; }
        return nil;
    }
    return tag;
}

- (BibDirectoryEntry *)readDirectoryEntryWithLeader:(BibLeader *)leader
                                              error:(out NSError *__autoreleasing *)error {
    BibFieldTag *const tag = [self readFieldTag:error];
    if (tag == nil) { return nil; }
    NSUInteger const lengthOfLengthOfField = [leader lengthOfLengthOfField];
    NSUInteger const lengthOfFieldLocation = [leader lengthOfFieldLocation];
    NSUInteger const lengthOfField = [_inputStream readUnsignedIntegerWithLength:lengthOfLengthOfField error:error];
    NSUInteger const fieldLocation = [_inputStream readUnsignedIntegerWithLength:lengthOfFieldLocation error:error];
    if (tag == nil || lengthOfField == NSNotFound || fieldLocation == NSNotFound) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    return [[BibDirectoryEntry alloc] initWithTag:tag range:NSMakeRange(fieldLocation, lengthOfField)];
}

static NSError *sControlFieldMissingTerminatorError() {
    NSString *const debugDescription =
        [NSString stringWithFormat:@"Control fields must end with a field terminator (%#04x)", kFieldTerminator];
    return [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                               code:BibMARCInputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : debugDescription }];;
}

- (BibControlField *)readControlFieldWithLeader:(BibLeader *)leader
                                 directoryEntry:(BibDirectoryEntry *)directoryEntry
                                          error:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSUInteger const length = [directoryEntry range].length;
    uint8_t *const bytes = alloca(length);
    if (![_inputStream readBytes:bytes length:length error:error]) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    if (length == 0 || bytes[length - 1] != kFieldTerminator) {
        _streamStatus = NSStreamStatusError;
        _streamError = sControlFieldMissingTerminatorError();
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSError *stringError = nil;
    NSData *const data = [NSData dataWithBytes:bytes length:(length - 1)];
    NSString *value = [NSString bib_stringWithData:data encoding:[leader recordEncoding] error:&stringError];
    if (value == nil) {
        _streamStatus = NSStreamStatusError;
        _streamError = stringError;
        if (error) { *error = [self streamError]; }
        return nil;
    }
    return [BibControlField controlFieldWithTag:[directoryEntry tag] value:value];
}

- (BibContentIndicatorList *)readContentIndicatorsWithLeader:(BibLeader *)leader
                                                       error:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSUInteger const numberOfIndicators = [leader numberOfIndicators];
    uint8_t *const buffer = alloca(numberOfIndicators);
    if (![_inputStream readBytes:buffer length:numberOfIndicators error:error]) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    BibContentIndicator *const rawIndicators = (BibContentIndicator *)buffer;
    return [[BibContentIndicatorList alloc] initWithIndicators:rawIndicators count:numberOfIndicators];
}

static NSError *sSubfieldCodeMissingDelimiterError() {
    NSString *const debugDescription =
        [NSString stringWithFormat:@"Subfield codes must begin with a subfield delimiter (%#04x)", kSubfieldDelimiter];
    return [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                               code:BibMARCInputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : debugDescription }];;
}

- (BibSubfieldCode)readSubfieldCodeWithLeader:(BibLeader *)leader error:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    NSUInteger const length = [leader lengthOfSubfieldCode];
    uint8_t *const bytes = alloca(length);
    if (![_inputStream readBytes:bytes length:length error:error]) {
        _streamStatus = NSStreamStatusError;
        return nil;
    }
    if (length == 0 || bytes[0] != kSubfieldDelimiter) {
        _streamStatus = NSStreamStatusError;
        _streamError = sSubfieldCodeMissingDelimiterError();
        if (error) { *error = [self streamError]; }
        return nil;
    }
    return [[NSString alloc] initWithBytes:(bytes + 1) length:(length - 1) encoding:NSASCIIStringEncoding];
}

static NSError *sSubfieldContentContainsRecordTerminatorError() {
    NSString *const debugDescription =
        [NSString stringWithFormat:@"Content field contains a record terminator (%#04x)", kRecordTerminator];
    return [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                               code:BibMARCInputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : debugDescription }];
}

- (NSString *)readSubfieldContentWithLeader:(BibLeader *)leader error:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] == NSStreamStatusError) {
        if (error) { *error = [self streamError]; }
        return nil;
    }
    uint8_t byte;
    NSError *streamError = nil;
    NSMutableData *const data = [NSMutableData data];
    while ([_inputStream peekByte:&byte error:NULL]) {
        switch (byte) {
            case kFieldTerminator:
            case kSubfieldDelimiter: {
                BibEncoding const encoding = [leader recordEncoding];
                NSString *const content = [NSString bib_stringWithData:data encoding:encoding error:&streamError];
                if (content == nil) {
                    _streamStatus = NSStreamStatusError;
                    _streamError = streamError;
                    if (error) { *error = [self streamError]; }
                    return nil;
                }
                return content;
            }

            case kRecordTerminator:
                [_inputStream readByte:&byte error:NULL];
                _streamStatus = NSStreamStatusError;
                _streamError = sSubfieldContentContainsRecordTerminatorError();
                if (error) { *error = [self streamError]; }
                return nil;

            default:
                [_inputStream readByte:&byte error:NULL];
                [data appendBytes:&byte length:1];
                break;
        }
    }
    [_inputStream readBytes:&byte length:1 error:error];
    _streamStatus = NSStreamStatusError;
    return nil;
}

- (BibContentField *)readContentFieldWithLeader:(BibLeader *)leader
                                 directoryEntry:(BibDirectoryEntry *)directoryEntry
                                          error:(out NSError *__autoreleasing *)error {
    NSUInteger const initialNumberOfBytesRead = [_inputStream numberOfBytesRead];
    BibContentIndicatorList *const indicators = [self readContentIndicatorsWithLeader:leader error:error];
    if (indicators == nil) { return nil; }
    NSMutableArray *const subfields = [NSMutableArray array];
    uint8_t byte;
    while ([_inputStream peekByte:&byte error:NULL]) {
        switch (byte) {
            case kFieldTerminator: {
                [_inputStream readByte:&byte error:NULL]; // we know this will succeed
                NSUInteger const readLength = [_inputStream numberOfBytesRead] - initialNumberOfBytesRead;
                if (readLength != [directoryEntry range].length) {
                    _streamStatus = NSStreamStatusError;
                    NSString *const debugDescription =
                        @"Directory entry does not correctly describe the content field's size";
                    _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                                       code:BibMARCInputStreamMalformedDataError
                                                   userInfo:@{ NSDebugDescriptionErrorKey : debugDescription }];
                    if (error) { *error = [self streamError]; }
                    return nil;
                }
                return [[BibContentField alloc] initWithTag:[directoryEntry tag]
                                                 indicators:indicators
                                                  subfields:subfields];
            }

            case kSubfieldDelimiter: {
                BibSubfieldCode const code = [self readSubfieldCodeWithLeader:leader error:error];
                if (code == nil) { return nil; }
                NSString *const content = [self readSubfieldContentWithLeader:leader error:error];
                if (content == nil) { return nil; }
                BibSubfield *const subfield = [[BibSubfield alloc] initWithCode:code content:content];
                [subfields addObject:subfield];
                break;
            }

            default: {
                [_inputStream readByte:&byte error:NULL];
                _streamStatus = NSStreamStatusError;
                _streamError = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                                   code:BibMARCInputStreamMalformedDataError
                                               userInfo:@{ NSDebugDescriptionErrorKey : @"Malformed content field" }];
                if (error) { *error = [self streamError]; }
                return nil;
            }
        }
    }
    [_inputStream readBytes:&byte length:1 error:error]; // we know this is gives an error
    _streamStatus = NSStreamStatusError;
    return nil;
}

@end
