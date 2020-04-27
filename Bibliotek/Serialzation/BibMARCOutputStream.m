//
//  BibMARCOutputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibMARCOutputStream.h"
#import "BibMARCSerialization.h"

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
        _streamStatus = [outputStream streamStatus];
        _streamError = [outputStream streamError];
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

- (BOOL)writeRecord:(BibRecord *)record error:(out NSError * _Nullable __autoreleasing *)error {
    if (![self isStreamStatusOpen:error]) {
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
