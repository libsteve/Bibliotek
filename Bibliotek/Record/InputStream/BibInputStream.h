//
//  BibInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMetadata.h"

@class BibDirectoryEntry;

NS_ASSUME_NONNULL_BEGIN

@interface BibInputStream : NSObject

@property (nonatomic, copy, readonly, nullable) NSError *streamError;

@property (nonatomic, assign, readonly) NSStreamStatus streamStatus;

@property (nonatomic, assign, readonly) NSUInteger numberOfBytesRead;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithData:(NSData *)data;
- (nullable instancetype)initWithFileAtPath:(NSString *)path;
- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

+ (instancetype)inputStreamWithURL:(NSURL *)url NS_SWIFT_UNAVAILABLE("Use init(url:)");
+ (instancetype)inputStreamWithData:(NSData *)data NS_SWIFT_UNAVAILABLE("Use init(data:)");
+ (nullable instancetype)inputStreamWithFileAtPath:(NSString *)path NS_SWIFT_UNAVAILABLE("Use init(fileAtPath:)");
+ (instancetype)inputStreamWithInputStream:(NSInputStream *)inputStream NS_SWIFT_UNAVAILABLE("Use init(inputStream:)");

- (instancetype)open;
- (instancetype)close;

@end

#pragma mark -

@interface BibInputStream (ReadBytes)

/// Get the next available bytes without advancing the input stream.
/// \param bytes A buffer to write the available bytes.
/// \param maxLength The size of the \c bytes buffer.
/// \returns The total amount of bytes written into the \c bytes buffer.
///          If an error occurred, \c NSNotFound is returned.
- (NSInteger)peekBytes:(uint8_t *)bytes maxLength:(NSUInteger)maxLength;

/// Read the next available bytes from the input stream.
/// \param bytes A buffer to write the available bytes.
/// \param maxLength The size of the \c bytes buffer.
/// \returns The total amount of bytes written into the \c bytes buffer.
///          If an error occurred, \c NSNotFound is returned.
- (NSInteger)readBytes:(uint8_t *)bytes maxLength:(NSUInteger)maxLength;

@end

#pragma mark -

@interface BibInputStream (ReadExactBytes)

- (BOOL)peekBytes:(uint8_t *)bytes length:(NSUInteger)length
            error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (BOOL)readBytes:(uint8_t *)bytes length:(NSUInteger)length
            error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// Get the next available byte without advancing the input stream.
/// \param byte A buffer to write the available byte.
/// \returns \c YES when a byte is available from the input stream.
///          \c NO when the input stream has ended or an error occurred.
- (BOOL)peekByte:(uint8_t *)byte error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// Read the next available byte from the input stream.
/// \param byte A buffer to write the available byte.
/// \returns \c YES when a byte was retrieved from the input stream.
///          \c NO when the input stream has ended or an error occurred.
- (BOOL)readByte:(uint8_t *)byte error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark -

@interface BibInputStream (ReadValues)

- (NSUInteger)readUnsignedIntegerWithLength:(NSUInteger)length
                                      error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSString *)readStringWithLength:(NSUInteger)length encoding:(NSStringEncoding)encoding
                                      error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSString *)readStringWithLength:(NSUInteger)length bibEncoding:(BibEncoding)encoding
                                      error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark -

extern NSErrorDomain const BibInputStreamErrorDomain;

typedef NS_ERROR_ENUM(BibInputStreamErrorDomain, BibInputStreamErrorCode) {
    BibInputStreamEndOfStreamError NS_SWIFT_NAME(endOfStream),
    BibInputStreamMalformedDataError NS_SWIFT_NAME(malformedData)
} NS_SWIFT_NAME(BibInputStream.Error);

NS_ASSUME_NONNULL_END
