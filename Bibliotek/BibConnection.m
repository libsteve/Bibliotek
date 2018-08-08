//
//  BibConnection.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnection.h"
#import "BibConnection+Private.h"
#import "BibConnectionEndpoint.h"
#import "BibConnectionOptions.h"
#import "BibConnectionOptions+Private.h"
#import "BibFetchRequest.h"
#import "BibFetchRequest+Private.h"
#import "BibRecordList.h"
#import "BibRecordList+Private.h"
#import <yaz/zoom.h>

@implementation BibConnection {
    ZOOM_connection _connection;
}

@synthesize zoomConnection = _connection;

#pragma mark - Initializers

- (instancetype)init {
    BibMutableConnectionOptions *options = [BibMutableConnectionOptions new];
    [options setNeedsEventPolling:YES];
    return [self initWithEndpoint:[BibConnectionEndpoint new] options:options error:nil];
}

- (instancetype)initWithHost:(NSString *)host error:(NSError * _Nullable __autoreleasing *)error {
    BibConnectionEndpoint *endpoint = [[BibConnectionEndpoint alloc] initWithHost:host];
    return [self initWithEndpoint:endpoint error:error];
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port error:(NSError * _Nullable __autoreleasing *)error {
    BibConnectionEndpoint *endpoint = [[BibConnectionEndpoint alloc] initWithHost:host port:port];
    return [self initWithEndpoint:endpoint error:error];
}

- (instancetype)initWithHost:(NSString *)host database:(NSString *)database error:(NSError * _Nullable __autoreleasing *)error {
    BibConnectionEndpoint *endpoint = [[BibConnectionEndpoint alloc] initWithHost:host database:database];
    return [self initWithEndpoint:endpoint error:error];
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database  error:(NSError * _Nullable __autoreleasing *)error {
    BibConnectionEndpoint *endpoint = [[BibConnectionEndpoint alloc] initWithHost:host port:port database:database];
    return [self initWithEndpoint:endpoint error:error];
}

- (instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint error:(NSError * _Nullable __autoreleasing *)error {
    return [self initWithEndpoint:endpoint options:[BibConnectionOptions new] error:error];
}

- (instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint options:(BibConnectionOptions *)options error:(NSError * _Nullable __autoreleasing *)error {
    if (self = [super init]) {
        _endpoint = [endpoint copy];
        _options = [options copy];
        ZOOM_options_set([_options zoomOptions], "databaseName", [[_endpoint database] UTF8String]);
        _connection = ZOOM_connection_create([_options zoomOptions]);
        ZOOM_connection_connect(_connection, [[_endpoint host] UTF8String], (int)[_endpoint port]);
        if (![_options needsEventPolling] && [self error:error]) {
            [self close];
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    ZOOM_connection_destroy(_connection);
}

#pragma mark - Error handling

- (BOOL)error:(NSError *__autoreleasing *)error {
    char const *name = NULL;
    char const *info = NULL;
    int const code = ZOOM_connection_error(_connection, &name, &info);
    if (code == 0) {
        return NO;
    }
    if (error == NULL) {
        return YES;
    }
    NSString *description = @(name ?: "There was an unknown failure.");
    NSString *reason = @(info ?: "No information is available at this time.");
    switch (code) {
        case ZOOM_ERROR_CONNECT:
            description = [NSString stringWithFormat:@"A connection could not be made with %@.", _endpoint];
            break;
        case ZOOM_ERROR_CONNECTION_LOST:
            description = [NSString stringWithFormat:@"The connection with %@ was lost.", _endpoint];
            break;
        case ZOOM_ERROR_INIT:
            description = [NSString stringWithFormat:@"The request to connect with %@ was deined.", _endpoint];
            break;
        case ZOOM_ERROR_TIMEOUT:
            description = [NSString stringWithFormat:@"The connection with %@ timed out.", _endpoint];
            break;
        default:
            break;
    }
    NSDictionary *const userInfo = @{ NSLocalizedDescriptionKey : description,
                                      NSLocalizedFailureReasonErrorKey : reason };
    *error = [NSError errorWithDomain:BibConnectionErrorDomain code:code userInfo:userInfo];
    return YES;
}

#pragma mark - Connection

- (void)close {
    ZOOM_connection_close(_connection);
}

#pragma mark - Search

- (BibRecordList *)fetchRecordsWithRequest:(BibFetchRequest *)request error:(NSError *__autoreleasing *)error {
    ZOOM_resultset const resultSet = ZOOM_connection_search(_connection, request.zoomQuery);
    if ([self error:error]) {
        return nil;
    }
    return [[BibRecordList alloc] initWithZoomResultSet:resultSet connection:self request:request];
}

#pragma mark - Event polling

- (BOOL)needsEventPolling {
    return [_options needsEventPolling];
}

- (void)updateEventWithZoomEvent:(int)zoomEvent {
    [self willChangeValueForKey:@"event"];
    switch (zoomEvent) {
        case ZOOM_EVENT_NONE:
            _event = nil;
            break;
        case ZOOM_EVENT_CONNECT:
            _event = BibConnectionEventDidConnect;
            break;
        case ZOOM_EVENT_SEND_DATA :
            _event = BibConnectionEventDidSendData;
            break;
        case ZOOM_EVENT_RECV_DATA:
            _event = BibConnectionEventDidReceiveData;
            break;
        case ZOOM_EVENT_TIMEOUT:
            _event = BibConnectionEventDidTimeout;
            break;
        case ZOOM_EVENT_UNKNOWN:
            _event = BibConnectionEventUnknown;
            break;
        case ZOOM_EVENT_SEND_APDU:
            _event = BibConnectionEventDidSendAPDU;
            break;
        case ZOOM_EVENT_RECV_APDU:
            _event = BibConnectionEventDidReceiveAPDU;
            break;
        case ZOOM_EVENT_RECV_RECORD:
            _event = BibConnectionEventDidReceiveRecord;
            break;
        case ZOOM_EVENT_RECV_SEARCH:
            _event = BibConnectionEventDidReceiveSearch;
            break;
        case ZOOM_EVENT_END:
            _event = BibConnectionEventDidEndConnection;
            break;
        default:
            _event = BibConnectionEventUnknown;
            break;
    }
    [self didChangeValueForKey:@"event"];
}

- (BibConnectionEvent)nextEvent:(NSError *__autoreleasing *)error {
    if (ZOOM_event(1, &_connection) == ZOOM_EVENT_NONE) { return nil; }
    [self updateEventWithZoomEvent:ZOOM_connection_last_event(_connection)];
    [self error:error];
    return [self event];
}

+ (BibConnection *)processEventsForConnections:(NSArray<BibConnection *> *)connections error:(NSError * _Nullable __autoreleasing *)error {
    NSInteger const count = [connections count];
    NSAssert(count <= INT_MAX, @"Only %d connections can be processed at a time", INT_MAX);
    ZOOM_connection *const zoomConnections = calloc(sizeof(ZOOM_connection), (int)count);
    for (NSInteger index = 0; index < count; index += 1) {
        zoomConnections[index] = [connections[index] zoomConnection];
    }
    NSInteger const result = ZOOM_event((int)count, zoomConnections);
    free(zoomConnections);
    if (result == ZOOM_EVENT_NONE) { return nil; }
    BibConnection *const connection = connections[result - 1];
    int const zoomEvent = ZOOM_connection_last_event([connection zoomConnection]);
    [connection updateEventWithZoomEvent:zoomEvent];
    [connection error:error];
    return connection;
}

@end
