//
//  BibMARCOutputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibMARCOutputStream.h"

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

NSErrorDomain const BibMARCOutputStreamErrorDomain = @"BibMARCOutputStreamErrorDomain";

@implementation BibMARCOutputStream {
    NSOutputStream *_outputStream;
    NSStreamStatus _streamStatus;
    NSError *_streamError;
}

- (instancetype)init {
    return [self initToMemory];
}

- (instancetype)initToMemory {
    return [self initWithOutputStream:[NSOutputStream outputStreamToMemory]];
}

- (instancetype)initWithURL:(NSURL *)url append:(BOOL)shouldAppend {
    return [self initWithOutputStream:[NSOutputStream outputStreamWithURL:url append:shouldAppend]];
}

- (nullable instancetype)initWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
    NSOutputStream *const outputStream = [NSOutputStream outputStreamToFileAtPath:path append:shouldAppend];
    return (outputStream) ? [self initWithOutputStream:outputStream] : nil;
}

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream {
    if (self = [super init]) {
        _outputStream = outputStream;
        _streamStatus = NSStreamStatusNotOpen;
    }
    return self;
}

+ (instancetype)outputStreamToMemory {
    return [[self alloc] initToMemory];
}

+ (instancetype)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend {
    return [[self alloc] initWithURL:url append:shouldAppend];
}

+ (instancetype)outputStreamWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
    return [[self alloc] initWithFileAtPath:path append:shouldAppend];
}

+ (instancetype)outputStreamWithOutputStream:(NSOutputStream *)outputStream {
    return [[self alloc] initWithOutputStream:outputStream];
}

- (void)dealloc {
    [_outputStream close];
}

- (NSStreamStatus)streamStatus {
    return (_streamStatus == NSStreamStatusError) ? _streamStatus : [_outputStream streamStatus];
}

- (NSError *)streamError {
    return (_streamStatus == NSStreamStatusError) ? (_streamError ?: [_outputStream streamError]) : nil;
}

- (BOOL)hasSpaceAvailable {
    return [_outputStream hasSpaceAvailable];
}

- (NSData *)data {
    return [_outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

- (instancetype)open {
    _streamError = nil;
    [_outputStream open];
    _streamStatus = [_outputStream streamStatus];
    return self;
}

- (instancetype)close {
    _streamError = nil;
    [_outputStream close];
    _streamStatus = [_outputStream streamStatus];
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
                static NSString *const message = @"An output stream must be opened before data can be written";
                *error = [NSError errorWithDomain:BibMARCOutputStreamErrorDomain
                                             code:BibMARCOutputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusClosed:
            if (error) {
                static NSString *const message = @"A closed output stream cannot write data";
                *error = [NSError errorWithDomain:BibMARCOutputStreamErrorDomain
                                             code:BibMARCOutputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        default:
            if (error) {
                NSStreamStatus const status = [self streamStatus];
                NSString *const message =
                    [NSString stringWithFormat:@"Cannot write data to an output stream with status %lu", status];
                *error = [NSError errorWithDomain:BibMARCOutputStreamErrorDomain
                                             code:BibMARCOutputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
    }
}

static NSError *sEndOfStreamError() {
    return  [NSError errorWithDomain:BibMARCOutputStreamErrorDomain
                                code:BibMARCOutputStreamPrematureEndOfDataError
                            userInfo:@{ NSDebugDescriptionErrorKey : @"Premature end of stream data" }];
}

static NSError *sMalformedDataError() {
    return [NSError errorWithDomain:BibMARCOutputStreamErrorDomain
                               code:BibMARCOutputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : @"Malformed stream data" }];
}

- (BOOL)writeRecord:(BibRecord *)bibRecord error:(out NSError * _Nullable __autoreleasing *)error {
    if (![self isStreamStatusOpen:error]) {
        return NO;
    }
    BibMarcRecord record;
    NSData *const leaderData = bibRecord.metadata.leader.rawData;
    record.leader = BibMarcLeaderRead(leaderData.bytes, leaderData.length);
    record.controlFieldsCount = bibRecord.controlFields.count;
    record.contentFieldsCount = bibRecord.contentFields.count;
    record.controlFields = calloc(record.controlFieldsCount, sizeof(BibMarcControlField));
    record.contentFields = calloc(record.contentFieldsCount, sizeof(BibMarcContentField));
    NSArray<BibControlField *> *const bibControlFields = bibRecord.controlFields;
    NSArray<BibContentField *> *const bibContentFields = bibRecord.contentFields;
    for (size_t index = 0; index < record.controlFieldsCount; index += 1)
    {
        BibMarcControlField *const field = &(record.controlFields[index]);
        BibControlField *const bibField = bibControlFields[index];
        char const *const bibFieldString = bibField.value.UTF8String;
        field->content = calloc(1 + strlen(bibFieldString), sizeof(char));
        strcpy(field->content, bibFieldString);
        strcpy(field->tag, bibField.tag.stringValue.UTF8String);
    }
    for (size_t index = 0; index < record.contentFieldsCount; index += 1)
    {
        BibMarcContentField *const field = &(record.contentFields[index]);
        BibContentField *const bibField = bibContentFields[index];
        field->indicators[0] = bibField.indicators.firstIndicator;
        field->indicators[1] = bibField.indicators.secondIndicator;
        strcpy(field->tag, bibField.tag.stringValue.UTF8String);
        field->subfieldsCount = bibField.subfields.count;
        field->subfields = calloc(field->subfieldsCount, sizeof(BibMarcSubfield));
        NSEnumerator *const bibSubfields = bibField.subfieldEnumerator;
        for (size_t index = 0; index < field->subfieldsCount; index += 1)
        {
            BibMarcSubfield *const subfield = &(field->subfields[index]);
            BibSubfield *const bibSubfield = [bibSubfields nextObject];
            subfield->code = bibSubfield.code.UTF8String[0];
            char const *const bibSubfieldString = bibSubfield.content.UTF8String;
            subfield->content = calloc(1 + strlen(bibSubfieldString), sizeof(char));
            strcpy(subfield->content, bibSubfieldString);
        }
    }
    size_t const length = BibMarcRecordGetWriteSize(&record);
    int8_t *const buffer = alloca(sizeof(int8_t) * length);
    size_t const bufferWriteLength = length - BibMarcRecordWrite(&record, buffer, length);
    BibMarcRecordDestroy(&record);
    if (bufferWriteLength == 0) {
        _streamError = sMalformedDataError();
        return NO;
    }
    size_t const outputWriteLength = [_outputStream write:(uint8_t *)buffer maxLength:length];
    BOOL const success = (bufferWriteLength == outputWriteLength);
    if (!success) {
        if (outputWriteLength == 0) {
            _streamStatus = NSStreamStatusAtEnd;
        } else if (outputWriteLength == NSNotFound) {
            _streamStatus = NSStreamStatusError;
            _streamError = [_outputStream streamError];
        } else {
            _streamStatus = NSStreamStatusError;
            _streamError = sEndOfStreamError();
        }
        if (error != NULL) {
            *error = _streamError;
        }
    }
    return success;
}

@end
