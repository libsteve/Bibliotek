//
//  BibOptions.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibOptions.h"
#import "BibOptions.Private.h"
#import <yaz/zoom.h>

@implementation BibOptions {
    ZOOM_options _options;
}

@synthesize zoomOptions = _options;

#pragma mark - Initialization

- (instancetype)init {
    if ([super init]) {
        _options = ZOOM_options_create();
    }
    return self;
}

- (void)dealloc {
    ZOOM_options_destroy(_options);
}

#pragma mark - Options

- (void)setUser:(NSString *)user {
    _user = [user copy];
    char const *const value = [_user UTF8String];
    ZOOM_options_set(_options, "user", value);
}

- (void)setGroup:(NSString *)group {
    _group = [group copy];
    char const *const value = [_group UTF8String];
    ZOOM_options_set(_options, "group", value);
}

- (void)setPassword:(NSString *)password {
    _password = [password copy];
    char const *const value = [_password UTF8String];
    ZOOM_options_set(_options, "password", value);
}

- (void)setLang:(NSString *)lang {
    _lang = [lang copy];
    char const *const value = [_lang UTF8String];
    ZOOM_options_set(_options, "lang", value);
}

- (void)setCharset:(NSString *)charset {
    _charset = [charset copy];
    char const *const value = [_charset UTF8String];
    ZOOM_options_set(_options, "charset", value);
}

- (void)setDatabaseName:(NSString *)databaseName {
    _databaseName = [databaseName copy];
    char const *const value = [_databaseName UTF8String];
    ZOOM_options_set(_options, "databaseName", value);
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    BibOptions *options = [[BibOptions allocWithZone:zone] init];
    options.user = _user;
    options.password = _password;
    options.lang = _lang;
    options.charset = _charset;
    options.databaseName = _databaseName;
    return options;
}

@end
