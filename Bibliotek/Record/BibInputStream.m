//
//  BibInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibInputStream.h"

NSErrorDomain const BibInputStreamErrorDomain = @"BibInputStreamErrorDomain";

@implementation BibInputStream

@synthesize inputStream = _inputStream;
@synthesize numberOfBytesRead = _numberOfBytesRead;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    if (self = [super init]) {
        _inputStream = inputStream;
        _numberOfBytesRead = 0;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithInputStream:[NSInputStream inputStreamWithData:data]];
}

- (instancetype)init {
    return [self initWithInputStream:[NSInputStream inputStreamWithData:[NSData data]]];
}

- (NSInteger)readBytes:(uint8_t *)bytes length:(NSUInteger)length error:(out NSError *__autoreleasing *)error {
    NSInputStream *const inputStream = [self inputStream];
    NSInteger const byteCount = [inputStream read:bytes maxLength:length];
    _numberOfBytesRead += byteCount;
    if (error && byteCount != length) {
        switch (byteCount) {
            case NSNotFound:
                *error = [inputStream streamError];
                break;
            default:
                *error = [NSError errorWithDomain:BibInputStreamErrorDomain
                                             code:BibInputStreamEndOfStreamError
                                         userInfo:@{ NSDebugDescriptionErrorKey : @"Premature end of stream" }];
                break;
        }
    }
    return byteCount;
}

+ (instancetype)inputStreamWithInputStream:(NSInputStream *)inputStream {
    return [[self alloc] initWithInputStream:inputStream];
}

+ (instancetype)inputStreamWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

@end
