//
//  BibConnectionEndpoint.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnectionEndpoint.h"

NSString *const kDefaultHost = @"localhost";
NSInteger const kDefaultPort = 210;
NSString *const kDefaultDatabase = @"Default";

@implementation BibConnectionEndpoint {
@protected
    NSString *_host;
    NSInteger _port;
    NSString *_database;
}

@synthesize host = _host;
@synthesize port = _port;
@synthesize database = _database;

- (instancetype)init {
    return [self initWithHost:kDefaultHost port:kDefaultPort database:kDefaultDatabase];
}

- (instancetype)initWithHost:(NSString *)host {
    return [self initWithHost:host port:kDefaultPort database:kDefaultDatabase];
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port {
    return [self initWithHost:host port:port database:kDefaultDatabase];
}

- (instancetype)initWithHost:(NSString *)host database:(NSString *)database {
    return [self initWithHost:host port:kDefaultPort database:database];
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database {
    if (self = [super init]) {
        _host = [host copy];
        _port = port;
        _database = [database copy];
    }
    return self;
}

- (instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint {
    return [self initWithHost:[endpoint host] port:[endpoint port] database:[endpoint database]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibConnectionEndpoint allocWithZone:zone] initWithEndpoint:self];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableConnectionEndpoint allocWithZone:zone] initWithEndpoint:self];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _host = [aDecoder decodeObjectForKey:@"host"];
        _port = [aDecoder decodeIntegerForKey:@"port"];
        _database = [aDecoder decodeObjectForKey:@"database"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_host forKey:@"host"];
    [aCoder encodeInteger:_port forKey:@"port"];
    [aCoder encodeObject:_database forKey:@"database"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@:%ld/%@", _host, (long)_port, _database];
}

@end

@implementation BibMutableConnectionEndpoint

@dynamic host;
- (void)setHost:(NSString *)host {
    [self willChangeValueForKey:@"host"];
    _host = [host copy];
    [self didChangeValueForKey:@"host"];
}

@dynamic port;
- (void)setPort:(NSInteger)port {
    [self willChangeValueForKey:@"port"];
    _port = port;
    [self didChangeValueForKey:@"port"];
}

@dynamic database;
- (void)setDatabase:(NSString *)database {
    [self willChangeValueForKey:@"database"];
    _database = [database copy];
    [self didChangeValueForKey:@"database"];
}

@end
