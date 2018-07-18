//
//  BibConnection.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnection.h"
#import "BibConnection+Private.h"
#import "BibFetchRequest.h"
#import "BibFetchRequest+Private.h"
#import "BibRecordList.h"
#import "BibRecordList+Private.h"
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
        _connection = ZOOM_connection_new([_host UTF8String], (int)_port);
        self.database = database;
        if ([self error:error]) {
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    ZOOM_connection_destroy(_connection);
}

- (BOOL)error:(NSError *__autoreleasing *)error {
    char const *name = "Unknown failure";
    char const *info = "No known information";
    int const code = ZOOM_connection_error(_connection, &name, &info);
    if (code == 0) {
        return NO;
    }
    if (error != NULL) {
        NSDictionary *const userInfo = @{ BibConnectionErrorName : @(name),
                                          BibConnectionErrorInfo : @(info) };
        *error = [NSError errorWithDomain:BibConnectionErrorDomain code:code userInfo:userInfo];
    }
    return YES;
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
    if ([self error:error]) {
        return nil;
    }
    return [[BibRecordList alloc] initWithZoomResultSet:resultSet connection:self request:request];
}

@end
