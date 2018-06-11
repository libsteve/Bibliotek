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

/// The URL to the z39.50 host server.
@property(nonatomic, readonly, copy) NSString *host;

/// The port number used to connect to the server.
@property(nonatomic, readonly, assign) NSInteger port;

/// The name of the database with wich to make queries.
@property(nonatomic, readwrite, copy) NSString *database;

/// A username to gain access to the database.
@property(nonatomic, readwrite, copy, nullable) NSString *user;

/// The group name used to gain access to the database.
@property(nonatomic, readwrite, copy, nullable) NSString *group;

/// A password to gain entry to the database.
@property(nonatomic, readwrite, copy, nullable) NSString *password;

/// The authentication method used to sign into the database.
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

/// Search the database for records matching the given request query.
/// \param request A description of the properties matching requested records.
/// \returns A collection of records whose properties match those described in the fetch request.
- (nullable BibRecordList *)fetchRecordsWithRequest:(BibFetchRequest *)request error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(fetchRecords(request:));

@end

NS_ASSUME_NONNULL_END
