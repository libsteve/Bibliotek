//
//  BibConnection.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnection.h"
#import "BibConnection.Private.h"
#import "BibFetchRequest.h"
#import "BibFetchRequest.Private.h"
#import "BibRecord.h"
#import "BibRecord.Private.h"
#import "BibRecordList.h"
#import "BibRecordList.Private.h"
#import <yaz/zoom.h>

NSInteger const kDefaultPort = 210;
NSString *const kDefaultDatabase = @"Default";

@implementation BibConnection {
    ZOOM_connection _connection;
}

@synthesize zoomConnection = _connection;

#pragma mark - Initializers

- (instancetype)initWithHost:(NSString *)host error:(NSError * _Nullable __autoreleasing *)error {
    return [self initWithHost:host port:kDefaultPort database:kDefaultDatabase error:error];
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port error:(NSError * _Nullable __autoreleasing *)error {
    return [self initWithHost:host port:port database:kDefaultDatabase error:error];
}

- (instancetype)initWithHost:(NSString *)host database:(NSString *)database error:(NSError * _Nullable __autoreleasing *)error {
    return [self initWithHost:host port:kDefaultPort database:database error:error];
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database error:(NSError **)error {
    if (self = [super init]) {
        _host = [host copy];
        _port = port;
        char const *const rawHost = [_host UTF8String];
        _connection = ZOOM_connection_new(rawHost, (int32_t)port);
        ZOOM_connection_option_set(_connection, "async", "1");
        self.database = database;
        int const eventPosition = ZOOM_event(1, &_connection);
        int const eventType = (eventPosition == 0) ? ZOOM_EVENT_UNKNOWN : ZOOM_connection_last_event(_connection);
        if (eventType != ZOOM_EVENT_CONNECT) {
            if (error != NULL) {
                char const *name = "UNKNOWN";
                char const *info = "NONE";
                int const code = ZOOM_connection_error(_connection, &name, &info);
                NSDictionary *userInfo = @{ BibConnectionErrorName : @(name),
                                            BibConnectionErrorInfo : @(info) };
                *error = [NSError errorWithDomain:BibConnectionErrorDomain code:code userInfo:userInfo];
            }
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    ZOOM_connection_destroy(_connection);
}

#pragma mark - Options

- (void)setDatabase:(NSString *)databaseName {
    _database = [databaseName copy];
    char const *const value = [_database UTF8String];
    ZOOM_connection_option_set(_connection, "databaseName", value);
}

- (void)setUser:(NSString *)user {
    _user = [user copy];
    char const *const value = [_user UTF8String];
    ZOOM_connection_option_set(_connection, "user", value);
}

- (void)setGroup:(NSString *)group {
    _group = [group copy];
    char const *const value = [_group UTF8String];
    ZOOM_connection_option_set(_connection, "group", value);
}

- (void)setPassword:(NSString *)password {
    _password = [password copy];
    char const *const value = [_password UTF8String];
    ZOOM_connection_option_set(_connection, "password", value);
}

- (void)setAuthentication:(BibAuthenticationMode)authentication {
    _authentication = [authentication copy];
    char const *const value = [_authentication UTF8String];
    ZOOM_connection_option_set(_connection, "authenticationMode", value);
}

@synthesize lang = _lang;

- (NSString *)lang {
    if (_lang == nil) {
        char const *const value = ZOOM_connection_option_get(_connection, "lang");
        if (value == nil) { return nil; }
        _lang = [NSString stringWithUTF8String:value];
    }
    return _lang;
}

- (void)setLang:(NSString *)lang {
    _lang = [lang copy];
    char const *const value = [_lang UTF8String];
    ZOOM_connection_option_set(_connection, "lang", value);
}

@synthesize charset = _charset;

- (NSString *)charset {
    if (_charset == nil) {
        char const *const value = ZOOM_connection_option_get(_connection, "charset");
        if (value == nil) { return nil; }
        _charset = [NSString stringWithUTF8String:value];
    }
    return _charset;
}

- (void)setCharset:(NSString *)charset {
    _charset = [charset copy];
    char const *const value = [_charset UTF8String];
    ZOOM_connection_option_set(_connection, "charset", value);
}

#pragma mark - Search

- (BibRecordList *)fetchRecordsWithRequest:(BibFetchRequest *)request error:(NSError **)error {
    ZOOM_resultset resultSet = ZOOM_connection_search(_connection, request.zoomQuery);
    char const *name = NULL;
    char const *info = NULL;
    int code = ZOOM_connection_error(_connection, &name, &info);
    if (code != 0) {
        if (error != NULL) {
            NSDictionary *userInfo = @{ BibConnectionErrorName : @(name),
                                        BibConnectionErrorInfo : @(info) };
            *error = [NSError errorWithDomain:BibConnectionErrorDomain code:code userInfo:userInfo];
        }
        return nil;
    }
    return [[BibRecordList alloc] initWithZoomResultSet:resultSet connection:self request:request];
}

@end

