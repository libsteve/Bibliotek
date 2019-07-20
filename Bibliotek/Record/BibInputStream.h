//
//  BibInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibDirectoryEntry;

NS_ASSUME_NONNULL_BEGIN

@interface BibInputStream : NSObject

@property (nonatomic, strong, readonly) NSInputStream *inputStream;

@property (nonatomic, assign, readonly) NSUInteger numberOfBytesRead;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithData:(NSData *)data;

- (NSInteger)readBytes:(uint8_t *)bytes
                length:(NSUInteger)length
                 error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

+ (instancetype)inputStreamWithInputStream:(NSInputStream *)inputStream NS_SWIFT_UNAVAILABLE("Use init(inputStream:)");

+ (instancetype)inputStreamWithData:(NSData *)data NS_SWIFT_UNAVAILABLE("Use init(data:)");

@end

extern NSErrorDomain const BibInputStreamErrorDomain;

typedef NS_ERROR_ENUM(BibInputStreamErrorDomain, BibInputStreamErrorCode) {
    BibInputStreamEndOfStreamError NS_SWIFT_NAME(endOfStream)
} NS_SWIFT_NAME(BibInputStream.Error);

NS_ASSUME_NONNULL_END
