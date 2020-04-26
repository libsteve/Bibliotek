//
//  BibMARCInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMARCInputStream.h"
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
#import "BibRecordKind.h"

#import "BibMarcIO.h"

NSErrorDomain const BibMARCInputStreamErrorDomain = @"BibMARCInputStreamErrorDomain";

@implementation BibMARCInputStream {
    NSInputStream *_inputStream;
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
        _inputStream = inputStream;
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

- (BOOL)hasRecordsAvailable {
    return [_inputStream hasBytesAvailable];
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

- (BOOL)isStreamStatusOpen:(out NSError *__autoreleasing *)error {
    switch ([self streamStatus]) {
        case NSStreamStatusOpen:
            return YES;
        case NSStreamStatusAtEnd:
            return NO;
        case NSStreamStatusError:
            if (error) { *error = [self streamError]; }
            return NO;
        case NSStreamStatusNotOpen:
            if (error) {
                static NSString *const message = @"An input stream must be opened before data can be read";
                *error = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                             code:BibMARCInputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusClosed:
            if (error) {
                static NSString *const message = @"A closed input stream cannot read data";
                *error = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                             code:BibMARCInputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        default:
            if (error) {
                NSStreamStatus const status = [self streamStatus];
                NSString *const message =
                    [NSString stringWithFormat:@"Cannot read data from an input stream with status %lu", status];
                *error = [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                             code:BibMARCInputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
    }
}

static NSError *sEndOfStreamError() {
    return  [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                                code:BibMARCInputStreamPrematureEndOfDataError
                            userInfo:@{ NSDebugDescriptionErrorKey : @"Premature end of stream data" }];
}

static NSError *sMalformedDataError() {
    return [NSError errorWithDomain:BibMARCInputStreamErrorDomain
                               code:BibMARCInputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : @"Malformed stream data" }];
}

- (BibRecord *)readRecord:(out NSError *__autoreleasing *)error {
    if (![self isStreamStatusOpen:error]) {
        return nil;
    }
    uint8_t *const leaderBytes = alloca(BibLeaderRawDataLength * sizeof(int8_t));
    NSUInteger const readLength = [_inputStream read:leaderBytes maxLength:BibLeaderRawDataLength];
    if (readLength == 0)
    {
        _streamStatus = NSStreamStatusAtEnd;
        return nil;
    }
    else if (readLength == NSNotFound)
    {
        _streamStatus = [_inputStream streamStatus];
        _streamError = [_inputStream streamError];
        if (error != NULL) { *error = _streamError; }
        return nil;
    }
    else if (readLength != BibLeaderRawDataLength)
    {
        _streamStatus = NSStreamStatusError;
        _streamError = sEndOfStreamError();
        if (error != NULL) { *error = _streamError; }
        return nil;
    }

    BibMarcLeader const leader = BibMarcLeaderRead((int8_t *)leaderBytes, BibLeaderRawDataLength);
    if (leader.recordLength == NSNotFound || leader.fieldsLocation == NSNotFound)
    {
        _streamStatus = NSStreamStatusError;
        _streamError = sMalformedDataError();
        if (error != NULL) { *error = _streamError; }
        return nil;
    }

    size_t const remainingBytesCount = leader.recordLength - BibLeaderRawDataLength;
    uint8_t *const buffer = alloca(leader.recordLength * sizeof(int8_t));
    memcpy(buffer, leaderBytes, BibLeaderRawDataLength);

    NSUInteger const remainingReadLength = [_inputStream read:(buffer + BibLeaderRawDataLength) maxLength:remainingBytesCount];
    if (remainingReadLength == NSNotFound)
    {
        _streamStatus = [_inputStream streamStatus];
        _streamError = [_inputStream streamError];
        if (error != NULL) { *error = _streamError; }
        return nil;
    }
    else if (remainingReadLength != remainingBytesCount)
    {
        _streamStatus = NSStreamStatusError;
        _streamError = sEndOfStreamError();
        if (error != NULL) { *error = _streamError; }
        return nil;
    }

    BibMarcRecord record;
    if (BibMarcRecordRead(&record, (int8_t *)buffer, leader.recordLength) != leader.recordLength) {
        _streamStatus = NSStreamStatusError;
        _streamError = sMalformedDataError();
        if (error != NULL) { *error = _streamError; }
        return nil;
    }

    BibRecordKind *const kind = [[BibRecordKind alloc] initWithRawValue:(uint8_t)leader.recordKind];
    NSData *const leaderData = [[NSData alloc] initWithBytes:leaderBytes length:BibLeaderRawDataLength];
    BibLeader *const bibLeader = [[BibLeader alloc] initWithData:leaderData];
    BibMetadata *const metadata = [[BibMetadata alloc] initWithLeader:bibLeader];
    NSMutableArray *const controlFields = [[NSMutableArray alloc] initWithCapacity:record.controlFieldsCount];
    for (size_t index = 0; index < record.controlFieldsCount; index += 1)
    {
        BibMarcControlField const *const field = &(record.controlFields[index]);
        NSString *const tagString = [[NSString alloc] initWithUTF8String:field->tag];
        BibFieldTag *const tag = [[BibFieldTag alloc] initWithString:tagString];
        NSString *const value = [[NSString alloc] initWithUTF8String:field->content];
        BibControlField *const controlField = [[BibControlField alloc] initWithTag:tag value:value];
        [controlFields addObject:controlField];
    }
    NSMutableArray *const contentFields = [[NSMutableArray alloc] initWithCapacity:record.contentFieldsCount];
    for (size_t index = 0; index < record.contentFieldsCount; index += 1)
    {
        BibMarcContentField const *const field = &(record.contentFields[index]);
        NSString *const tagString = [[NSString alloc] initWithUTF8String:field->tag];
        BibFieldTag *const tag = [[BibFieldTag alloc] initWithString:tagString];
        BibContentIndicatorList *const indicators = [[BibContentIndicatorList alloc] initWithIndicators:(char *)(field->indicators) count:2];
        NSMutableArray *const subfields = [[NSMutableArray alloc] initWithCapacity:field->subfieldsCount];
        for (size_t index = 0; index < field->subfieldsCount; index += 1)
        {
            BibMarcSubfield const *const subfield = &(field->subfields[index]);
            NSString *const code = [[NSString alloc] initWithUTF8String:(char[2]){subfield->code, '\0'}];
            NSString *const content = [[NSString alloc] initWithUTF8String:subfield->content];
            BibSubfield *const bibSubfield = [[BibSubfield alloc] initWithCode:code content:content];
            [subfields addObject:bibSubfield];
        }
        BibContentField *const contentField = [[BibContentField alloc] initWithTag:tag
                                                                        indicators:indicators
                                                                         subfields:subfields];
        [contentFields addObject:contentField];
    }
    BibRecord *const bibRecord = [[BibRecord alloc] initWithKind:kind
                                                          status:BibRecordStatusNew
                                                        metadata:metadata
                                                   controlFields:controlFields
                                                   contentFields:contentFields];
    BibMarcRecordDestroy(&record);
    if ([_inputStream streamStatus] == NSStreamStatusAtEnd)
    {
        _streamStatus = NSStreamStatusAtEnd;
    }
    return bibRecord;
}

@end
