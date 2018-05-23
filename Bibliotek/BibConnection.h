//
//  BibConnection.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibFetchRequest;
@class BibOptions;
@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Connection)
@interface BibConnection : NSObject

@property(nonatomic, readonly, copy) NSString *host;

@property(nonatomic, readonly, assign) int port;

#pragma mark - Initialization

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithHost:(NSString *)host error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (instancetype)initWithHost:(NSString *)host port:(int)port error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (instancetype)initWithHost:(NSString *)host options:(nullable BibOptions *)options error:(inout NSError *__autoreleasing _Nullable *_Nullable)error;

- (instancetype)initWithHost:(NSString *)host port:(int)port options:(nullable BibOptions *)options error:(inout NSError *__autoreleasing _Nullable *_Nullable)error;

#pragma mark - Search

- (NSArray<BibRecord *> *)fetchRecordsWithRequest:(BibFetchRequest *)request NS_SWIFT_NAME(fetchRecords(request:));

@end

#pragma mark - Error Domain

extern NSErrorDomain const BibConnectionErrorDomain;

extern NSErrorUserInfoKey const BibConnectionErrorName;
extern NSErrorUserInfoKey const BibConnectionErrorInfo;

NS_ASSUME_NONNULL_END
