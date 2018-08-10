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
        if (![self open:error]) {
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    ZOOM_connection_destroy(_connection);
}

#pragma mark - Error handling

- (NSString *)descriptionForErrorCode:(int)code {
    switch (code) {
        case ZOOM_ERROR_CONNECT:
            return [NSString stringWithFormat:@"A connection could not be made with %@.", _endpoint];
        case ZOOM_ERROR_CONNECTION_LOST:
            return [NSString stringWithFormat:@"The connection with %@ was lost.", _endpoint];
        case ZOOM_ERROR_INIT:
            return [NSString stringWithFormat:@"The request to connect with %@ was deined.", _endpoint];
        case ZOOM_ERROR_TIMEOUT:
            return [NSString stringWithFormat:@"The connection with %@ timed out.", _endpoint];
        default:
            return nil;
    }
}

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
    NSString *description = [self descriptionForErrorCode:code] ?: @(name ?: "There was an unknown failure.");
    NSString *reason = @(info ?: "No information is available at this time.");
    NSDictionary *const userInfo = @{ NSLocalizedDescriptionKey : description,
                                      NSLocalizedFailureReasonErrorKey : reason,
                                      BibConnectionErrorConnectionKey : self,
                                      BibConnectionErrorEventKey : @(_lastProcessedEvent) };
    *error = [NSError errorWithDomain:BibConnectionErrorDomain code:code userInfo:userInfo];
    return YES;
}

#pragma mark - Connection

- (BOOL)open:(NSError *__autoreleasing  _Nullable *)error {
    if (_ready) { return _ready; }
    [self willChangeValueForKey:@"ready"];
    ZOOM_connection_connect(_connection, [[_endpoint host] UTF8String], (int)[_endpoint port]);
    if (![_options needsEventPolling] && [self error:error]) {
        [self close];
    } else {
        _ready = YES;
    }
    [self didChangeValueForKey:@"ready"];
    return _ready;
}

- (void)close {
    if (!_ready) { return; }
    [self willChangeValueForKey:@"ready"];
    ZOOM_connection_close(_connection);
    _ready = NO;
    [self didChangeValueForKey:@"ready"];
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

- (BibConnectionEvent)processNextEvent:(NSError *__autoreleasing *)error {
    BOOL const didPerformEvent = ZOOM_event(1, &_connection);
    _lastProcessedEvent = (didPerformEvent) ? ZOOM_connection_last_event(_connection) : BibConnectionEventNone;
    [self error:error];
    return _lastProcessedEvent;
}

+ (BibConnection *)processNextEventForConnections:(NSArray<BibConnection *> *)connections error:(NSError *__autoreleasing *)error {
    NSInteger const count = [connections count];
    NSAssert(count <= INT_MAX, @"Only %d connections can be processed at a time", INT_MAX);
    ZOOM_connection *const zoomConnections = calloc(sizeof(ZOOM_connection), (int)count);
    for (NSInteger index = 0; index < count; index += 1) {
        zoomConnections[index] = [connections[index] zoomConnection];
    }
    NSInteger const index = ZOOM_event((int)count, zoomConnections) - 1;
    free(zoomConnections);
    if (index == -1) { return nil; }
    BibConnection *const connection = connections[index];
    connection->_lastProcessedEvent = ZOOM_connection_last_event([connection zoomConnection]);
    [connection error:error];
    return connection;
}

+ (id)processNextEventForConnections:(NSArray<BibConnection *> *)connections {
    NSError *error = nil;
    BibConnection *connection = [self processNextEventForConnections:connections error:&error];
    return (error == nil) ? connection : error;
}

@end
