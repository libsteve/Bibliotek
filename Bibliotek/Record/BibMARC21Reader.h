//
//  BibMARC21Reader.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/5/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MARC21Reader)
@interface BibMARC21Reader : NSObject

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithData:(NSData *)data;
- (nullable instancetype)initWithFileAtPath:(NSString *)path;
- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

+ (instancetype)readerWithURL:(NSURL *)url NS_SWIFT_UNAVAILABLE("Use init(url:)");
+ (instancetype)readerWithData:(NSData *)data NS_SWIFT_UNAVAILABLE("Use init(data:)");
+ (nullable instancetype)readerWithFileAtPath:(NSString *)path NS_SWIFT_UNAVAILABLE("Use init(fileAtPath:)");
+ (instancetype)readerWithInputStream:(NSInputStream *)inputStream NS_SWIFT_UNAVAILABLE("Use init(inputStream:)");

- (nullable BibRecord *)readRecord:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

extern NSErrorDomain const BibMARC21ReaderErrorDomain;

typedef NS_ERROR_ENUM(BibMARC21ReaderErrorDomain, BibMARC21ReaderErrorCode) {
    BibMARC21ReaderMalformedDataError NS_SWIFT_NAME(malformedData)
} NS_SWIFT_NAME(MARC21ReaderError);

NS_ASSUME_NONNULL_END
