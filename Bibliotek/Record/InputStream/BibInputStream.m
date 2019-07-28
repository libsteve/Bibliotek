//
//  BibInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <yaz/yaz-iconv.h>

#import "BibInputStream.h"

NSErrorDomain const BibInputStreamErrorDomain = @"BibInputStreamErrorDomain";

@implementation BibInputStream {
    NSMutableData *_bufferData;
    NSInputStream *_inputStream;
    yaz_iconv_t _marc8Converter;
}

@synthesize streamError = _streamError;
@synthesize streamStatus = _streamStatus;
@synthesize numberOfBytesRead = _numberOfBytesRead;

- (instancetype)init {
    return [self initWithData:[NSData data]];
}

- (instancetype)initWithURL:(NSURL *const)url {
    return [self initWithInputStream:[NSInputStream inputStreamWithURL:url]];
}

- (instancetype)initWithData:(NSData *const)data {
    return [self initWithInputStream:[NSInputStream inputStreamWithData:data]];
}

- (instancetype)initWithFileAtPath:(NSString *const)path {
    NSInputStream *const inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    return (inputStream) ? [self initWithInputStream:inputStream] : nil;
}

- (instancetype)initWithInputStream:(NSInputStream *const)inputStream {
    if (self = [super init]) {
        _bufferData = [NSMutableData data];
        _inputStream = inputStream;
        _streamStatus = [inputStream streamStatus];
        _numberOfBytesRead = 0;
        _marc8Converter = NULL;
    }
    return self;
}

+ (instancetype)inputStreamWithURL:(NSURL *const)url {
    return [[self alloc] initWithURL:url];
}

+ (instancetype)inputStreamWithData:(NSData *const)data {
    return [[self alloc] initWithData:data];
}

+ (instancetype)inputStreamWithFileAtPath:(NSString *const)path {
    return [[self alloc] initWithFileAtPath:path];
}

+ (instancetype)inputStreamWithInputStream:(NSInputStream *const)inputStream {
    return [[self alloc] initWithInputStream:inputStream];
}

- (void)dealloc {
    [_inputStream close];
    if (_marc8Converter) {
        yaz_iconv_close(_marc8Converter);
    }
}

- (NSStreamStatus)streamStatus {
    return _streamStatus;
}

- (NSError *)streamError {
    return ([self streamStatus] == NSStreamStatusError) ? (_streamError ?: [_inputStream streamError]) : nil;
}

- (instancetype)open {
    _streamError = nil;
    [_inputStream open];
    _streamStatus = [_inputStream streamStatus];
    _marc8Converter = yaz_iconv_open("utf8", "marc8");
    return self;
}

- (instancetype)close {
    _streamError = nil;
    [_inputStream close];
    _streamStatus = [_inputStream streamStatus];
    if (_marc8Converter) {
        yaz_iconv_close(_marc8Converter);
        _marc8Converter = NULL;
    }
    return self;
}

@end

#pragma mark -

@implementation BibInputStream (ReadBytes)

- (NSInteger)peekBytes:(uint8_t *const)bytes maxLength:(NSUInteger const)length {
    switch ([self streamStatus]) {
        case NSStreamStatusError: return NSStreamStatusError;
        case NSStreamStatusOpen: break;
        default: return 0;
    }
    NSUInteger const bufferLength = [_bufferData length];
    if (length <= bufferLength) {
        [_bufferData getBytes:bytes length:length];
        return length;
    }
    [_bufferData getBytes:bytes length:bufferLength];
    uint8_t *const remainingBytes = bytes + bufferLength;
    NSUInteger const remainingLength = length - bufferLength;
    NSUInteger const readLength = [_inputStream read:remainingBytes maxLength:remainingLength];
    if (readLength == NSNotFound) {
        _streamError = [_inputStream streamError];
        _streamStatus = [_inputStream streamStatus];
        return NSNotFound;
    }
    [_bufferData appendBytes:remainingBytes length:readLength];
    NSStreamStatus const newStreamStatus = [_inputStream streamStatus];
    _streamStatus = (newStreamStatus != NSStreamStatusAtEnd) ? newStreamStatus : _streamStatus;
    return bufferLength + readLength;
}

- (NSInteger)readBytes:(uint8_t *const)bytes maxLength:(NSUInteger const)length {
    switch ([self streamStatus]) {
        case NSStreamStatusError: return NSStreamStatusError;
        case NSStreamStatusOpen: break;
        default: return 0;
    }
    NSUInteger const bufferSize = [_bufferData length];
    if (length <= bufferSize) {
        [_bufferData getBytes:bytes length:length];
        [_bufferData replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
        if ([_bufferData length] == 0 && [_inputStream streamStatus] == NSStreamStatusAtEnd) {
            _streamStatus = NSStreamStatusAtEnd;
        }
        _numberOfBytesRead += length;
        return length;
    }
    [_bufferData getBytes:bytes length:bufferSize];
    [_bufferData setLength:0];
    uint8_t *const remainingBytes = bytes + bufferSize;
    NSUInteger const remainingLength = length - bufferSize;
    NSUInteger const readLength = [_inputStream read:remainingBytes maxLength:remainingLength];
    _streamStatus = [_inputStream streamStatus];
    if (readLength == NSNotFound) {
        _streamError = [_inputStream streamError];
        return NSNotFound;
    }
    NSUInteger const totalBytes = bufferSize + readLength;
    _numberOfBytesRead += totalBytes;
    return totalBytes;
}

@end

#pragma mark -

@implementation BibInputStream (ReadExactBytes)

static NSError *sEndOfStreamError() {
    return  [NSError errorWithDomain:BibInputStreamErrorDomain
                                code:BibInputStreamEndOfStreamError
                            userInfo:@{ NSDebugDescriptionErrorKey : @"Premature end of stream" }];
}

- (BOOL)peekBytes:(uint8_t *)bytes length:(NSUInteger const)length error:(out NSError *__autoreleasing *const)error {
    NSInteger const readLength = [self peekBytes:bytes maxLength:length];
    BOOL const success = (readLength == length);
    if (error && !success && readLength != NSNotFound) {
        *error = sEndOfStreamError();
    }
    return success;
}

- (BOOL)readBytes:(uint8_t *)bytes length:(NSUInteger const)length error:(out NSError *__autoreleasing *const)error {
    NSInteger const readLength = [self readBytes:bytes maxLength:length];
    BOOL const success = (readLength == length);
    if (!success && readLength != NSNotFound) {
        _streamStatus = NSStreamStatusError;
        _streamError = sEndOfStreamError();
        if (error) { *error = [self streamError]; }
    }
    return success;
}

- (BOOL)peekByte:(uint8_t *)byte error:(out NSError *__autoreleasing *const)error {
    return [self peekBytes:byte length:1 error:error];
}

- (BOOL)readByte:(uint8_t *)byte error:(out NSError *__autoreleasing *const)error {
    return [self readBytes:byte length:1 error:error];
}

@end

#pragma mark -

@implementation BibInputStream (ReadValues)

static NSUInteger sReadUnsignedIntegerFromBytes(uint8_t *const bytes, NSUInteger const length) {
    NSUInteger value = 0;
    for (NSUInteger power = 0; power < length; power += 1) {
        NSUInteger const index = length - 1 - power;
        int8_t digit = bytes[index] - '0';
        if (digit < 0 || digit > 9) {
            return NSNotFound;
        }
        value += (NSUInteger)digit * (NSUInteger)pow(10, (double)power);
    }
    return value;
}

- (NSUInteger)readUnsignedIntegerWithLength:(NSUInteger const)length error:(out NSError *__autoreleasing *const)error {
    uint8_t *const bytes = alloca(length);
    if (![self readBytes:bytes length:length error:error]) {
        return NSNotFound;
    }
    NSInteger const result = sReadUnsignedIntegerFromBytes(bytes, length);
    if (result == NSNotFound) {
        NSString *const value = [[NSString alloc] initWithBytes:bytes length:length encoding:NSASCIIStringEncoding];
        NSString *const message = [NSString stringWithFormat:@"Cannot read `%@' as an unsigned integer", value];
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibInputStreamErrorDomain
                                           code:BibInputStreamMalformedDataError
                                       userInfo:@{ NSDebugDescriptionErrorKey : message }];
        if (error) {
            *error = _streamError;
        }
    }
    return result;
}

static NSError *sReadStringEncodingError() {
    NSString *const message = @"Cannot inperpret string data using the given encoding";
    return [NSError errorWithDomain:BibInputStreamErrorDomain
                               code:BibInputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : message }];
}

- (NSString *)readStringWithLength:(NSUInteger)length encoding:(NSStringEncoding)encoding
                             error:(out NSError *__autoreleasing *)error {
    uint8_t *const bytes = alloca(length);
    if (![self readBytes:bytes length:length error:error]) {
        return nil;
    }
    NSString *const stringValue = [[NSString alloc] initWithBytes:bytes length:length encoding:encoding];
    if (stringValue == nil) {
        _streamStatus = NSStreamStatusError;
        _streamError = sReadStringEncodingError();
        if (error) {
            *error = _streamError;
        }
    }
    return stringValue;
}

- (NSString *)readMARC8StringWithLength:(NSUInteger const)length error:(out NSError *__autoreleasing *const)error {
    uint8_t *const bytes = alloca(length);
    if (![self readBytes:bytes length:length error:error]) {
        return nil;
    }
    NSUInteger const inBufferLength = length;
    NSUInteger const outBufferLength = inBufferLength + 16;
    char *const inBuffer = alloca(inBufferLength);
    char *const outBuffer = alloca(outBufferLength);
    memcpy(inBuffer, bytes, inBufferLength);
    char *inBuff = inBuffer, *outBuff = outBuffer;
    NSMutableData *const data = [NSMutableData data];
    for (NSUInteger inBuffLeft = inBufferLength, outBuffLeft = outBufferLength;
         inBuffLeft > 0;
         outBuff = outBuff, outBuffLeft = outBufferLength) {
        outBuff = outBuffer;
        size_t const result = yaz_iconv(_marc8Converter, &inBuff, &inBuffLeft, &outBuff, &outBuffLeft);
        NSUInteger const writeLength = outBufferLength - outBuffLeft;
        if (result == -1) {
            int const errorNumber = yaz_iconv_error(_marc8Converter);
            if (errorNumber != YAZ_ICONV_E2BIG) {
                _streamStatus = NSStreamStatusError;
                _streamError = sReadStringEncodingError();
                if (error) {
                    *error = _streamError;
                }
                return nil;
            }
        }
        [data appendBytes:outBuffer length:writeLength];
    }
    yaz_iconv(_marc8Converter, NULL, NULL, NULL, NULL); // reset the converter to its initial state
    NSString *const stringValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (stringValue == nil) {
        _streamStatus = NSStreamStatusError;
        _streamError = sReadStringEncodingError();
        if (error) {
            *error = _streamError;
        }
        return nil;
    }
    return stringValue;
}

- (NSString *)readStringWithLength:(NSUInteger)length bibEncoding:(BibEncoding)encoding
                             error:(out NSError *__autoreleasing *)error {
    NSParameterAssert(encoding == BibMARC8Encoding || encoding == BibUTF8Encoding);
    switch (encoding) {
        case BibUTF8Encoding:  return [self readStringWithLength:length encoding:NSUTF8StringEncoding error:error];
        case BibMARC8Encoding: return [self readMARC8StringWithLength:length error:error];
    }
}

@end
