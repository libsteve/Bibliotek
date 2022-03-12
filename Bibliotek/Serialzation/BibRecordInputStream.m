//
//  BibRecordInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/6/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import "BibRecordInputStream.h"
#import <Bibliotek/Bibliotek.h>
#import <os/log.h>

NSErrorDomain const BibRecordInputStreamErrorDomain = @"BibRecordInputStreamErrorDomain";

@interface _BibRecordInputStreamPlaceholder : BibRecordInputStream
@end

@interface _BibInferredInputStream : BibRecordInputStream
@end

@interface _BibUnknownInputStream : BibRecordInputStream
@end

/// \param self object with the unimplemented method
/// \param _cmd selector of the unimplemented method
/// \param type \c "initializer" \c "method" or \c "property"
/// \param kind \c '-' for instance methods, \c '+' for class methods
static void BibUnimplementedMethod(id self, SEL _cmd, char const *type, char kind) BIB_COLD BIB_NORETURN;

#pragma mark -

@implementation BibRecordInputStream

@dynamic streamStatus;
- (NSStreamStatus)streamStatus {
    BibUnimplementedMethod(self, _cmd, "property", '-');
}

@dynamic streamError;
- (NSError *)streamError {
    BibUnimplementedMethod(self, _cmd, "property", '-');
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibRecordInputStream self]) {
        static _BibRecordInputStreamPlaceholder *placeholder;
        dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            placeholder = [_BibRecordInputStreamPlaceholder alloc];
        });
        return placeholder;
    }
    return [super allocWithZone:zone];
}

//- (instancetype)init {
//    return [self initWithData:[NSData data]];
//}

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
//    BibUnimplementedMethod(self, _cmd, "initializer", '-');
    return [super init];
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

- (BOOL)readRecord:(BibRecord *__autoreleasing *)record error:(NSError *__autoreleasing *)error {
    BibUnimplementedMethod(self, _cmd, "method", '-');
}

- (instancetype)open {
    BibUnimplementedMethod(self, _cmd, "method", '-');
}

- (instancetype)close {
    BibUnimplementedMethod(self, _cmd, "method", '-');
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
                *error = [NSError errorWithDomain:BibRecordInputStreamErrorDomain
                                             code:BibRecordInputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusClosed:
            if (error) {
                static NSString *const message = @"A closed input stream cannot read data";
                *error = [NSError errorWithDomain:BibRecordInputStreamErrorDomain
                                             code:BibRecordInputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        default:
            if (error) {
                NSStreamStatus const status = [self streamStatus];
                NSString *const message =
                    [NSString stringWithFormat:@"Cannot read data from an input stream with status %lu", status];
                *error = [NSError errorWithDomain:BibRecordInputStreamErrorDomain
                                             code:BibRecordInputStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
    }
}

@end

#pragma mark -

@implementation _BibRecordInputStreamPlaceholder

static BOOL _isXMLPathExtension(NSString *extension) {
    return [extension caseInsensitiveCompare:@"xml"] == NSOrderedSame
        || [extension caseInsensitiveCompare:@"marcxml"] == NSOrderedSame;
}

static BOOL _isMARCPathExtension(NSString *extension) {
    return [extension caseInsensitiveCompare:@"mrc"] == NSOrderedSame
        || [extension caseInsensitiveCompare:@"marc"] == NSOrderedSame
        || [extension caseInsensitiveCompare:@"mrc8"] == NSOrderedSame
        || [extension caseInsensitiveCompare:@"marc8"] == NSOrderedSame;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
- (id)initWithURL:(NSURL *)url {
    NSString *extension = [url pathExtension];
    if (_isXMLPathExtension(extension)) {
//        return [[BibMARCXMLInputStream alloc] initWithURL:url];
    }
    if (_isMARCPathExtension(extension)) {
        return [[BibMARCInputStream alloc] initWithURL:url];
    }
    return [[_BibUnknownInputStream alloc] initWithURL:url];
}

- (id)initWithData:(NSData *)data {
    NSUInteger length = [data length];
    if (length >= BibLeaderRawDataLength) {
        NSData *leaderData = [data subdataWithRange:NSMakeRange(0, BibLeaderRawDataLength)];
        BibLeader *leader = [[BibLeader alloc] initWithData:leaderData];
        if (leader != nil) {
            return [[BibMARCInputStream alloc] initWithData:data];
        }
    }
    if (length >= 2) {
        char buffer[2] = { '\0', '\0' };
        [data getBytes:buffer length:2];
        if (buffer[0] == '<' && buffer[1] == '?') {
//            return [[BibMARCXMLInputStream alloc] initWithData:data];
        }
    }
    return [[_BibUnknownInputStream alloc] initWithData:data];
}

- (id)initWithFileAtPath:(NSString *)path {
    NSString *extension = [path pathExtension];
    if (_isXMLPathExtension(extension)) {
//        return [[BibMARCXMLInputStream alloc] initWithFileAtPath:path];
    }
    if (_isMARCPathExtension(extension)) {
        return [[BibMARCInputStream alloc] initWithFileAtPath:path];
    }
    return [[_BibUnknownInputStream alloc] initWithFileAtPath:path];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)initWithInputStream:(NSInputStream *)inputStream {
    return [[_BibInferredInputStream alloc] initWithInputStream:inputStream];
}
#pragma clang diagnostic pop
#pragma clang diagnostic pop

@end

#pragma mark -

@interface __BibInferredInputStreamBufferedStream : NSInputStream
@property (nonatomic, readonly, strong) NSInputStream *inputStream;
- (instancetype)initWithInputStream:(NSInputStream *)inputStream;
- (NSInteger)peek:(uint8_t *)buffer maxLength:(NSUInteger)len;
@end

@implementation _BibInferredInputStream {
    __BibInferredInputStreamBufferedStream *_inputStream;
    BibRecordInputStream *_recordStream;
}

- (NSStreamStatus)streamStatus {
    if (_recordStream != NULL) {
        return [_recordStream streamStatus];
    }
    return [_inputStream streamStatus];
}

+ (NSSet *)keyPathsForValuesAffectingStreamStatus {
    return [NSSet setWithObjects:@"_inputStream.streamStatus", @"_recordStream.streamStatus", nil];
}

- (NSError *)streamError {
    if (_recordStream != NULL) {
        return [_recordStream streamError];
    }
    return [_inputStream streamError];
}

+ (NSSet *)keyPathsForValuesAffectingStreamError {
    return [NSSet setWithObjects:@"_inputStream.streamError", @"_recordStream.streamError", nil];
}

- (BOOL)hasRecordsAvailable {
    if (_recordStream != NULL) {
        return [_recordStream hasRecordsAvailable];
    }
    return [_inputStream hasBytesAvailable];
}

+ (NSSet *)keyPathsForValuesAffectingHasRecordsAvailable {
    return [NSSet setWithObjects:@"_recordStream.hasRecordsAvailable", nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    if (self = [super init]) {
        _inputStream = [[__BibInferredInputStreamBufferedStream alloc] initWithInputStream:inputStream];
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)open {
    if ([self streamStatus] != NSStreamStatusNotOpen) {
        return self;
    }
    if (_recordStream != nil) {
        [_recordStream open];
        return self;
    }
    [_inputStream open];
    if ([_inputStream streamStatus] == NSStreamStatusError) {
        return self;
    }
    uint8_t buffer[BibLeaderRawDataLength];
    NSUInteger length = [_inputStream peek:buffer maxLength:BibLeaderRawDataLength];
    if (length == -1) {
        return self;
    }
    [self willChangeValueForKey:@"_recordStream"];
    if (length >= BibLeaderRawDataLength) {
        NSData *leaderData = [NSData dataWithBytes:buffer length:length];
        BibLeader *leader = [[BibLeader alloc] initWithData:leaderData];
        if (leader != nil) {
            _recordStream = [[BibMARCInputStream alloc] initWithInputStream:_inputStream];
            [self didChangeValueForKey:@"_recordStream"];
            [_recordStream open];
            return self;
        }
    }
    if (length >= 2) {
        if (buffer[0] == '<' && buffer[1] == '?') {
//            _recordStream = [[BibMARCXMLInputStream alloc] initWithInputStream:_inputStream];
//            [self didChangeValueForKey:@"_recordStream"];
//            [_recordStream open];
//            return self;
        }
    }
    _recordStream = [[_BibUnknownInputStream alloc] initWithInputStream:_inputStream.inputStream];
    [self didChangeValueForKey:@"_recordStream"];
    [_recordStream open];
    return self;
}

- (instancetype)close {
    if ([self streamStatus] == NSStreamStatusClosed) {
        return self;
    }
    if (_recordStream != nil) {
        [_recordStream close];
        return self;
    }
    [_inputStream close];
    return self;
}

- (BOOL)readRecord:(BibRecord *__autoreleasing *)record error:(NSError *__autoreleasing *)error {
    if (_recordStream != nil) {
        return [_recordStream readRecord:record error:error];
    }
    return [self isStreamStatusOpen:error];
}

@end

@implementation __BibInferredInputStreamBufferedStream {
    NSInputStream *_inputStream;
    NSMutableData *_peekData;
}

- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    if (self = [super init]) {
        _inputStream = inputStream;
    }
    return self;
}

- (NSStreamStatus)streamStatus {
    return [_inputStream streamStatus];
}

+ (NSSet *)keyPathsForValuesAffectingStreamStatus {
    return [NSSet setWithObject:@"inputStream.streamStatus"];
}

- (NSError *)streamError {
    return [_inputStream streamError];
}

+ (NSSet *)keyPathsForValuesAffectingStreamError {
    return [NSSet setWithObject:@"inputStream.streamError"];
}

- (BOOL)hasBytesAvailable {
    return [_inputStream hasBytesAvailable];
}

+ (NSSet *)keyPathsForValuesAffectingHasBytesAvailable {
    return [NSSet setWithObject:@"inputStream.hasBytesAvailable"];
}

- (void)open {
    [_inputStream open];
}

- (void)close {
    [_inputStream close];
}

- (NSInteger)read:(uint8_t * const)buffer maxLength:(NSUInteger const)len {
    NSUInteger const peekLength = [_peekData length];
    if (peekLength == 0) {
        return [_inputStream read:buffer maxLength:len];
    } else if (peekLength <= len) {
        [_peekData getBytes:buffer length:len];
        _peekData = [[_peekData subdataWithRange:NSMakeRange(len, peekLength - len)] mutableCopy];
        return len;
    }
    [_peekData getBytes:buffer length:peekLength];
    _peekData = nil;
    NSUInteger const remaining = len - peekLength;
    uint8_t *const remainingBuffer = buffer + remaining;
    NSUInteger const length = [_inputStream read:remainingBuffer maxLength:remaining];
    if (length == -1) {
        return -1;
    }
    return length + peekLength;
}

- (NSInteger)peek:(uint8_t * const)buffer maxLength:(NSUInteger const)len {
    NSUInteger const peekLength = [_peekData length];
    if (peekLength == 0) {
        NSInteger const length = [_inputStream read:buffer maxLength:len];
        if (length == -1) {
            return -1;
        }
        _peekData = [NSMutableData dataWithBytes:buffer length:length];
        return length;
    } else if (peekLength <= len) {
        [_peekData getBytes:buffer length:len];
        return len;
    }
    [_peekData getBytes:buffer length:peekLength];
    NSUInteger const remaining = len - peekLength;
    uint8_t *const remainingBuffer = buffer + remaining;
    NSUInteger const length = [_inputStream read:remainingBuffer maxLength:remaining];
    if (length == -1) {
        return -1;
    }
    [_peekData appendBytes:remainingBuffer length:length];
    return length + peekLength;
}

@end

#pragma mark -

typedef NS_ENUM(uint8_t, _BibUnknownInputStreamType) {
    _BibUnknownInputStreamTypeURL,
    _BibUnknownInputStreamTypeData,
    _BibUnknownInputStreamTypePath,
    _BibUnknownInputStreamTypeStream
};

@implementation _BibUnknownInputStream {
    NSURL *_url;
    NSData *_data;
    NSString *_path;
    NSInputStream *_stream;
    _BibUnknownInputStreamType _type;
}

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _type = _BibUnknownInputStreamTypeURL;
        _url = url;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        _type = _BibUnknownInputStreamTypeData;
        _data = [data copy];
    }
    return self;
}

- (instancetype)initWithFileAtPath:(NSString *)path {
    if (self = [super init]) {
        _type = _BibUnknownInputStreamTypePath;
        _path = [path copy];
    }
    return self;
}

- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    if (self = [super init]) {
        _type = _BibUnknownInputStreamTypeStream;
        _stream = inputStream;
    }
    return self;
}

- (NSStreamStatus)streamStatus {
    if (_type == _BibUnknownInputStreamTypeStream) {
        if ([_stream streamStatus] == NSStreamStatusClosed) {
            return NSStreamStatusClosed;
        }
        [_stream close];
        if ([_stream streamStatus] == NSStreamStatusClosed) {
            return NSStreamStatusClosed;
        }
    }
    return NSStreamStatusError;
}

- (NSError *)streamError {
    if (_type == _BibUnknownInputStreamTypeStream) {
        switch ([_stream streamStatus]) {
            case NSStreamStatusClosed:
            case NSStreamStatusError:
                return [_stream streamError];
            default:
                break;
        }
    }
    NSString *message = nil;
    switch (_type) {
        case _BibUnknownInputStreamTypeURL:
            message = [NSString stringWithFormat:@"Unable to infer record encoding for %@", [_url absoluteURL]];
        case _BibUnknownInputStreamTypeData:
            message = [NSString stringWithFormat:@"Unable to infer record encoding for %@", _data];
        case _BibUnknownInputStreamTypePath:
            message = [NSString stringWithFormat:@"Unable to infer record encoding for file at path '%@'", _path];
        case _BibUnknownInputStreamTypeStream:
            message = [NSString stringWithFormat:@"Unable to infer record encoding for %@", _stream];
    }
    return [NSError errorWithDomain:BibRecordInputStreamErrorDomain
                               code:BibRecordInputStreamMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : message }];
}

- (BOOL)open:(NSError *__autoreleasing *)error {
    if (error != NULL) {
        *error = [self streamError];
    }
    return NO;
}

- (BOOL)close:(NSError *__autoreleasing *)error {
    if (_type == _BibUnknownInputStreamTypeStream) {

    }
    if (error != NULL) {
        *error = [self streamError];
    }
    return NO;
}

- (BOOL)readRecord:(BibRecord *__autoreleasing *)record error:(NSError *__autoreleasing *)error {
    if (error != NULL) {
        *error = [self streamError];
    }
    return NO;
}

@end

#pragma mark -

static void BibUnimplementedMethod(id self, SEL _cmd, char const *type, char kind) {
    os_log_t log = os_log_create("Bibliotek", "UnimplementedMethods");
    os_log_fault(log, "%{public}@ does not implement the required %s %c[%{public}@ %{public}@]", [self className],
                 type, kind, NSStringFromClass([BibRecordInputStream self]), NSStringFromSelector(_cmd));
    abort();
}
