//
//  BibConnection.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

@class BibFetchRequest;
@class BibRecord;
@class BibRecordList;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Connection)
@interface BibConnection : NSObject

@property(nonatomic, readonly, copy) NSString *host;
@property(nonatomic, readonly, assign) NSInteger port;
@property(nonatomic, readwrite, copy) NSString *database;

@property(nonatomic, readwrite, copy, nullable) NSString *user;
@property(nonatomic, readwrite, copy, nullable) NSString *group;
@property(nonatomic, readwrite, copy, nullable) NSString *password;
@property(nonatomic, readwrite, copy) BibAuthenticationMode authentication;

@property(nonatomic, readwrite, copy, nullable) NSString *lang;
@property(nonatomic, readwrite, copy, nullable) NSString *charset;

#pragma mark - Initialization

- (nullable instancetype)initWithHost:(NSString *)host error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host database:(NSString *)database error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host port:(NSInteger)port error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - Search

- (BibRecordList *)feetchRecordsWithRequest:(BibFetchRequest *)request error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_SWIFT_NAME(fetchRecords(request:));

@end

NS_ASSUME_NONNULL_END
