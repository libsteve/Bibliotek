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
@class BibConnectionProcessedEvent;
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

@property(nonatomic, readonly, assign) BibConnectionEvent lastProcessedEvent NS_SWIFT_UNAVAILABLE("This isn't necessary in Swift since the relevant event is always returned by both processNextEvent() and processNextEvent(for:)");

/// Manually poll the network to get the latest network result for this connection.
- (BibConnectionEvent)processNextEvent:(NSError *__autoreleasing _Nullable *_Nullable)error NS_REFINED_FOR_SWIFT;

/// Manually poll the network for any new events that have occurred for the given connections.
/// \param connections A list of connection objects that should be polled for any network events.
/// \returns The latest connection for which an event occurred. If no events recently occurred, @c nil is returned.
/// \post The returned connection's @c event property will be appropriately populated.
+ (nullable BibConnection *)processNextEventForConnections:(NSArray<BibConnection *> *)connections error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(processEvents(for:)) NS_SWIFT_UNAVAILABLE("Use processNextEvent(for:)");

+ (nullable BibConnectionProcessedEvent *)processNextEventForConnections:(NSArray<BibConnection *> *)connections NS_REFINED_FOR_SWIFT;

@end

NS_SWIFT_UNAVAILABLE("Use processNextEvent(for:)")
@interface BibConnectionProcessedEvent : NSObject

@property(nonatomic, readonly, copy) BibConnection *connection;
@property(nonatomic, readonly, assign) BibConnectionEvent event;
@property(nonatomic, readonly, copy, nullable) NSError *error;

@end

NS_ASSUME_NONNULL_END
