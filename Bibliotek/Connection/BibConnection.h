//
//  BibConnection.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibConstants.h>

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

/// Indicates whether or not the connection can start processing events.
@property(nonatomic, readonly, assign, getter=isReady) BOOL ready;

#pragma mark - Initialization

- (nullable instancetype)initWithHost:(NSString *)host error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host database:(NSString *)database error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host port:(NSInteger)port error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint error:(NSError *__autoreleasing _Nullable *_Nullable)error;

- (nullable instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint options:(BibConnectionOptions *)options error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_DESIGNATED_INITIALIZER;

#pragma mark - Connection

/// Get the connection ready to process events.
/// \returns @c YES if the connection is ready to process events, but @c NO in the case of an error.
- (BOOL)open:(NSError *_Nullable __autoreleasing *_Nullable)error;

/// End the current connection session, and stop processing events.
- (void)close;

#pragma mark - Search

/// Search the database for records matching the given request query.
/// \param request A description of the properties matching requested records.
/// \returns A collection of records whose properties match those described in the fetch request.
- (nullable BibRecordList *)fetchRecordsWithRequest:(BibFetchRequest *)request error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(fetchRecords(request:));

#pragma mark - Event polling

@property(nonatomic, readonly, assign) BOOL needsEventPolling;

@property(nonatomic, readonly, assign) BibConnectionEvent lastProcessedEvent NS_REFINED_FOR_SWIFT;

/// Manually poll the network to get the latest network result for this connection.
/// \param error An error pointer to communicate when a problem occurred while processing an event.
///              The error will contain this connection in its @c userInfo dictionary with the key
///              @c BibConnectionErrorConnectionKey, and the event with @c BibConnectionErrorEventKey.
/// \returns The latest event performed by the connection. If no events happened, @c BibConnectionEventNone is returned.
/// \post The returned connection's @c lastProcessedEvent property will be set to the recently processed event.
- (BibConnectionEvent)processNextEvent:(NSError *__autoreleasing _Nullable *_Nullable)error NS_REFINED_FOR_SWIFT;

/// Manually poll the network for any new events that have occurred for the given connections.
/// \param connections A list of connection objects that should be polled for any network events.
/// \param error An error pointer to communicate when a problem occurred with some connection's event.
///              The error will contain the offending connection in its @c userInfo dictionary with
///              the key @c BibConnectionErrorConnectionKey, and the event with @c BibConnectionErrorEventKey.
/// \returns The latest connection for which an event occurred. If no events recently occurred, @c nil is returned.
/// \post The returned connection's @c lastProcessedEvent property will be set to the recently processed event.
+ (nullable BibConnection *)processNextEventForConnections:(NSArray<BibConnection *> *)connections error:(NSError *__autoreleasing _Nullable *_Nullable)error NS_SWIFT_NAME(processEvents(for:)) NS_SWIFT_UNAVAILABLE("Use processNextEvent(for:)");

/// Manually poll the network for any new events that have occurred for the given connections.
/// \param connections A list of connection objects that should be polled for any network events.
/// \returns When an event has been successfully processed, that event's connection will be returned.
///          If there is a problem while processing an event, an @c NSError will be returned. The connection
///          with which the error occurred will be available in the error's @c userInfo dictionary with the
///          key @c BibConnectionErrorConnectionKey, and the offending event with @c BibConnectionErrorEventKey.
/// \post The returned connection's @c lastProcessedEvent property will be set to the recently processed event.
+ (nullable id)processNextEventForConnections:(NSArray<BibConnection *> *)connections NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
