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
        self.database = database;
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

- (void)setLang:(NSString *)lang {
    _lang = [lang copy];
    char const *const value = [_lang UTF8String];
    ZOOM_connection_option_set(_connection, "lang", value);
}

- (void)setCharset:(NSString *)charset {
    _charset = [charset copy];
    char const *const value = [_charset UTF8String];
    ZOOM_connection_option_set(_connection, "charset", value);
}

#pragma mark - Search

- (NSArray<BibRecord *> *)fetchRecordsWithRequest:(BibFetchRequest *)request {
    ZOOM_resultset resultSet = ZOOM_connection_search(_connection, request.zoomQuery);
    NSMutableArray *array = [NSMutableArray new];
    size_t const count = ZOOM_resultset_size(resultSet);
    ZOOM_record *buffer = calloc(count, sizeof(ZOOM_record));
    ZOOM_resultset_records(resultSet, buffer, 0, count);
    for (int i = 0; i < count; i += 1) {
        ZOOM_record const record = buffer[i];
        if (record == nil) { break; }
        [array addObject:[[BibRecord alloc] initWithZoomRecord:record]];
    }
    free(buffer);
    ZOOM_resultset_destroy(resultSet);
    return [array copy];
}

@end

#pragma mark - Error Domain

NSErrorDomain const BibConnectionErrorDomain = @"BibConnectionErrorDomain";

NSErrorUserInfoKey const BibConnectionErrorName = @"BibConnectionErrorName";
NSErrorUserInfoKey const BibConnectionErrorInfo = @"BibConnectionErrorInfo";
