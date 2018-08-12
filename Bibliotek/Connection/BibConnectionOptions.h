//
//  BibConnectionOptions.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Connection.Options)
@interface BibConnectionOptions : NSObject <NSCopying, NSMutableCopying>

/// A username to gain access to the database.
@property(nonatomic, readonly, copy, nullable) NSString *user;

/// The group name used to gain access to the database.
@property(nonatomic, readonly, copy, nullable) NSString *group;

/// A password to gain entry to the database.
@property(nonatomic, readonly, copy, nullable) NSString *password;

/// The authentication method used to sign into the database.
@property(nonatomic, readonly, copy, nullable) BibAuthenticationMode authentication;

@property(nonatomic, readonly, copy, nullable) NSString *lang;

@property(nonatomic, readonly, copy, nullable) NSString *charset;

@property(nonatomic, readonly, assign) BOOL needsEventPolling;

- (instancetype)initWithOptions:(BibConnectionOptions *)options;

@end

NS_SWIFT_NAME(Connection.MutableOptions)
@interface BibMutableConnectionOptions : BibConnectionOptions

/// A username to gain access to the database.
@property(nonatomic, readwrite, copy, nullable) NSString *user;

/// The group name used to gain access to the database.
@property(nonatomic, readwrite, copy, nullable) NSString *group;

/// A password to gain entry to the database.
@property(nonatomic, readwrite, copy, nullable) NSString *password;

/// The authentication method used to sign into the database.
@property(nonatomic, readwrite, copy, nullable) BibAuthenticationMode authentication;

@property(nonatomic, readwrite, copy, nullable) NSString *lang;

@property(nonatomic, readwrite, copy, nullable) NSString *charset;

@property(nonatomic, readwrite, assign) BOOL needsEventPolling;

@end

NS_ASSUME_NONNULL_END
