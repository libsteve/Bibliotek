//
//  BibConnectionEndpoint.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Connection.Endpoint)
@interface BibConnectionEndpoint : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

/// The URL to the z39.50 host server.
@property(nonatomic, readonly, copy) NSString *host;

/// The port number used to connect to the server.
@property(nonatomic, readonly, assign) NSInteger port;

/// The name of the database with wich to make queries.
@property(nonatomic, readonly, copy) NSString *database;

@property(nonatomic, readonly, copy, nullable) NSString *name;

@property(nonatomic, readonly, copy, nullable) NSString *catalog;

- (instancetype)initWithHost:(NSString *)host;

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port;

- (instancetype)initWithHost:(NSString *)host database:(NSString *)database;

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database;

- (instancetype)initWithEndpoint:(BibConnectionEndpoint *)endpoint NS_SWIFT_NAME(init(_:));

@end

NS_SWIFT_NAME(Connection.MutableEndpoint)
@interface BibMutableConnectionEndpoint : BibConnectionEndpoint

/// The URL to the z39.50 host server.
@property(nonatomic, readwrite, copy) NSString *host;

/// The port number used to connect to the server.
@property(nonatomic, readwrite, assign) NSInteger port;

/// The name of the database with wich to make queries.
@property(nonatomic, readwrite, copy) NSString *database;

@property(nonatomic, readwrite, copy, nullable) NSString *name;

@property(nonatomic, readwrite, copy, nullable) NSString *catalog;

@end

NS_ASSUME_NONNULL_END
