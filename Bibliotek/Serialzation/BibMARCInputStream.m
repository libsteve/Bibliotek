//
//  BibMARCInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMARCInputStream.h"
#import "BibMARCSerialization.h"

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
        _streamStatus = [inputStream streamStatus];
        _streamError = [inputStream streamError];
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
    if (_streamStatus == NSStreamStatusNotOpen) {
        [_inputStream open];
        _streamStatus = [_inputStream streamStatus];
        _streamError = [_inputStream streamError];
    }
    return self;
}

- (instancetype)close {
    if (_streamStatus != NSStreamStatusClosed) {
        [_inputStream close];
        _streamStatus = [_inputStream streamStatus];
        _streamError = [_inputStream streamError];
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

- (BibRecord *)readRecord:(out NSError *__autoreleasing *)error {
    if (![self isStreamStatusOpen:error]) {
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

@end
