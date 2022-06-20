//
//  BibConnectionOptions.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnectionOptions+Private.h"

@implementation BibConnectionOptions {
@protected
    ZOOM_options _options;
}

@synthesize zoomOptions = _options;

- (instancetype)init {
    if (self = [super init]) {
        _options = ZOOM_options_create();
    }
    return self;
}

- (instancetype)initWithOptions:(BibConnectionOptions *)options {
    if (self = [super init]) {
        _options = ZOOM_options_dup([options zoomOptions]);
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[BibConnectionOptions alloc] initWithOptions:self];
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [[BibMutableConnectionOptions alloc] initWithOptions:self];
}

- (void)dealloc {
    ZOOM_options_destroy(_options);
}

- (NSString *)user {
    char const *const value = ZOOM_options_get(_options, "user");
    if (value == nil) { return nil; }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (NSString *)group {
    char const *const value = ZOOM_options_get(_options, "group");
    if (value == nil) { return nil; }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (NSString *)password {
    char const *const value = ZOOM_options_get(_options, "password");
    if (value == nil) { return nil; }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (BibAuthenticationMode)authentication {
    char const *const value = ZOOM_options_get(_options, "authenticationMode");
    if (value == nil) { return nil; }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (NSString *)lang {
    char const *const value = ZOOM_options_get(_options, "lang");
    if (value == nil) { return nil; }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (NSString *)charset {
    char const *const value = ZOOM_options_get(_options, "charset");
    if (value == nil) { return nil; }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (NSUInteger)timeout {
    char const *const value = ZOOM_options_get(_options, "timeout");
    if (value == nil) { return 15; }
    return [[NSString stringWithCString:value encoding:NSUTF8StringEncoding] integerValue];
}

- (BOOL)needsEventPolling {
    return ZOOM_options_get_bool(_options, "async", NO);
}

@end

@implementation BibMutableConnectionOptions

@dynamic user;
- (void)setUser:(NSString *)user {
    ZOOM_options_set(_options, "user", [user UTF8String]);
}

@dynamic group;
- (void)setGroup:(NSString *)group {
    ZOOM_options_set(_options, "group", [group UTF8String]);
}

@dynamic password;
- (void)setPassword:(NSString *)password {
    ZOOM_options_set(_options, "password", [password UTF8String]);
}

@dynamic authentication;
- (void)setAuthentication:(BibAuthenticationMode)authentication {
    ZOOM_options_set(_options, "authenticationMode", [authentication UTF8String]);
}

@dynamic lang;
- (void)setLang:(NSString *)lang {
    ZOOM_options_set(_options, "lang", [lang UTF8String]);
}

@dynamic charset;
- (void)setCharset:(NSString *)charset {
    ZOOM_options_set(_options, "charset", [charset UTF8String]);
}

@dynamic timeout;
- (void)setTimeout:(NSUInteger)timeout {
    ZOOM_options_set(_options, "timeout", [[@(timeout) stringValue] UTF8String]);
}

@dynamic needsEventPolling;
- (void)setNeedsEventPolling:(BOOL)needsEventPolling {
    ZOOM_options_set(_options, "async", (needsEventPolling ? "1" : "0"));
}

@end
