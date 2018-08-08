//
//  BibConnection.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

@class BibConnectionEndpoint;
@class BibConnectionOptions;
@class BibFetchRequest;
@class BibRecord;
@class BibRecordList;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Connection)
@interface BibConnection : NSObject

@property(nonatomic, readonly, copy) BibConnectionEndpoint *endpoint;

@property(nonatomic, readonly, copy) BibConnectionOptions *options;

#pragma mark - Initialization

- (nullable instancetype)initWithHost:(NSString *)host error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host database:(NSString *)database error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host port:(NSInteger)port error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint options:(BibConnectionOptions *)options error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_DESIGNATED_INITIALIZER;

#pragma mark - Search

/// Search the database for records matching the given request query.
/// \param request A description of the properties matching requested records.
/// \returns A collection of records whose properties match those described in the fetch request.
- (nullable BibRecordList *)fetchRecordsWithRequest:(BibFetchRequest *)request error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(fetchRecords(request:));

#pragma mark - Event polling

@property(nonatomic, readonly, assign) BOOL needsEventPolling;

@property(nonatomic, readonly, nullable) BibConnectionEvent event;

/// Manually poll the network to get the latest network result for this connection.
- (nullable BibConnectionEvent)nextEvent:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(nextEvent());

/// Manually poll the network for any new events that have occurred for the given connections.
/// \param connections A list of connection objects that should be polled for any network events.
/// \returns The latest connection for which an event occurred. If no events recently occurred, @c nil is returned.
/// \post The returned connection's @c event property will be appropriately populated.
+ (nullable BibConnection *)processEventsForConnections:(NSArray<BibConnection *> *)connections error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(processEvents(for:));

@end

NS_ASSUME_NONNULL_END
