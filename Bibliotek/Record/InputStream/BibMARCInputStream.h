//
//  BibMARCInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MARCInputStream)
@interface BibMARCInputStream : NSObject

@property (nonatomic, copy, readonly, nullable) NSError *streamError;
@property (nonatomic, assign, readonly) NSStreamStatus streamStatus;

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

- (nullable BibRecord *)readRecord:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

extern NSErrorDomain const BibMARCInputStreamErrorDomain;

typedef NS_ERROR_ENUM(BibMARCInputStreamErrorDomain, BibMARCInputStreamErrorCode) {
    BibMARCInputStreamMalformedDataError NS_SWIFT_NAME(malformedData),
    BibMARCInputStreamPrematureEndOfDataError NS_SWIFT_NAME(prematureEndOfData),
} NS_SWIFT_NAME(MARC21ReaderError);

NS_ASSUME_NONNULL_END
