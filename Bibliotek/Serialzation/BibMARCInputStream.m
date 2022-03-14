//
//  BibMARCInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMARCInputStream.h"
#import "BibMARCSerialization.h"
#import <Bibliotek/Bibliotek+Internal.h>

NSErrorDomain const BibMARCInputStreamErrorDomain = @"BibMARCInputStreamErrorDomain";

@implementation BibMARCInputStream {
    NSInputStream *_inputStream;
    NSStreamStatus _streamStatus;
    NSError *_streamError;
}

- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    if (self = [super init]) {
        _inputStream = inputStream;
        _streamStatus = [inputStream streamStatus];
        _streamError = [inputStream streamError];
    }
    return self;
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
    if ([self streamStatus] == NSStreamStatusNotOpen) {
        [_inputStream open];
        _streamStatus = [_inputStream streamStatus];
        _streamError = [_inputStream streamError];
    }
    return self;
}

- (instancetype)close {
    if ([self streamStatus] != NSStreamStatusClosed) {
        [_inputStream close];
        _streamStatus = [_inputStream streamStatus];
        _streamError = [_inputStream streamError];
    }
    return self;
}

- (BibRecord *)readRecord:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] != NSStreamStatusOpen) {
        if ([self streamStatus] == NSStreamStatusAtEnd) {
            return nil;
        }
        if (error != NULL) {
            *error = BibSerializationMakeInputStreamNotOpenedError(_inputStream);
        }
        return nil;
    }
    NSError *err = nil;
    BibRecord *const record = [BibMARCSerialization recordFromStream:_inputStream error:&err];
    if (record == nil) {
        _streamStatus = (err == nil) ? NSStreamStatusError : NSStreamStatusAtEnd;
        _streamError = err;
        if (error != NULL) {
            *error = err;
        }
    }
    if ([_inputStream streamStatus] == NSStreamStatusAtEnd) {
        _streamStatus = NSStreamStatusAtEnd;
    }
    return record;
}

- (BOOL)readRecord:(out BibRecord *__autoreleasing *)record error:(out NSError *__autoreleasing *)error {
    NSError *_error = nil;
    BibRecord *_record = [self readRecord:&_error];
    if (_error == nil) {
        if (record != NULL) {
            *record = _record;
        }
        return YES;
    }
    if (error != NULL) {
        *error = _error;
    }
    return NO;
}

@end
