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
    [self willChangeValueForKey:@"user"];
    ZOOM_options_set(_options, "user", [user UTF8String]);
    [self didChangeValueForKey:@"user"];
}

@dynamic group;
- (void)setGroup:(NSString *)group {
    [self willChangeValueForKey:@"group"];
    ZOOM_options_set(_options, "group", [group UTF8String]);
    [self didChangeValueForKey:@"group"];
}

@dynamic password;
- (void)setPassword:(NSString *)password {
    [self willChangeValueForKey:@"password"];
    ZOOM_options_set(_options, "password", [password UTF8String]);
    [self didChangeValueForKey:@"password"];
}

@dynamic authentication;
- (void)setAuthentication:(BibAuthenticationMode)authentication {
    [self willChangeValueForKey:@"authentication"];
    ZOOM_options_set(_options, "authenticationMode", [authentication UTF8String]);
    [self didChangeValueForKey:@"authentication"];
}

@dynamic lang;
- (void)setLang:(NSString *)lang {
    [self willChangeValueForKey:@"lang"];
    ZOOM_options_set(_options, "lang", [lang UTF8String]);
    [self didChangeValueForKey:@"lang"];
}

@dynamic charset;
- (void)setCharset:(NSString *)charset {
    [self willChangeValueForKey:@"charset"];
    ZOOM_options_set(_options, "charset", [charset UTF8String]);
    [self didChangeValueForKey:@"charset"];
}

@dynamic timeout;
- (void)setTimeout:(NSUInteger)timeout {
    [self willChangeValueForKey:@"timeout"];
    ZOOM_options_set(_options, "timeout", [[@(timeout) stringValue] UTF8String])
    [self didChangeValueForKey:@"timeout"];
}

@dynamic needsEventPolling;
- (void)setNeedsEventPolling:(BOOL)needsEventPolling {
    [self willChangeValueForKey:@"needsEventPolling"];
    ZOOM_options_set(_options, "async", (needsEventPolling ? "1" : "0"));
    [self didChangeValueForKey:@"needsEventPolling"];
}

@end
