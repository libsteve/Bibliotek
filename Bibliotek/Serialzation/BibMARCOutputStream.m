//
//  BibMARCOutputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibMARCOutputStream.h"
#import "BibMARCSerialization.h"
#import "BibSerializationError+Internal.h"
#import "Bibliotek+Internal.h"

@implementation BibMARCOutputStream {
    NSOutputStream *_outputStream;
    NSStreamStatus _streamStatus;
    NSError *_streamError;
}

- (instancetype)init {
    return [self initToMemory];
}

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream {
    if (self = [super init]) {
        _outputStream = outputStream;
        _streamStatus = [outputStream streamStatus];
        _streamError = [outputStream streamError];
    }
    return self;
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
    if (_streamStatus == NSStreamStatusNotOpen) {
        [_outputStream open];
        _streamStatus = [_outputStream streamStatus];
        _streamError = [_outputStream streamError];
    }
    return self;
}

- (instancetype)close {
    if (_streamStatus != NSStreamStatusClosed) {
        [_outputStream close];
        _streamStatus = [_outputStream streamStatus];
        _streamError = [_outputStream streamError];
    }
    return self;
}

- (BOOL)writeRecord:(BibRecord *)record error:(out NSError * _Nullable __autoreleasing *)error {
    switch ([self streamStatus]) {
        case NSStreamStatusOpen:
            break;
        case NSStreamStatusError:
            if (error != NULL) {
                *error = [self streamError];
            }
            return NO;
        default:
            if (error != NULL) {
                *error = BibSerializationMakeOutputStreamNotOpenedError(_outputStream);
            }
            return NO;
    }
    NSError *err = nil;
    BOOL const success = [BibMARCSerialization writeRecord:record toStream:_outputStream error:&err];
    if (!success) {
        _streamStatus = NSStreamStatusError;
        _streamError = err;
        if (error != NULL) {
            *error = err;
        }
    }
    return success;
}

@end
