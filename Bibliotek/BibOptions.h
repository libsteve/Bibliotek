//
//  BibOptions.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Options)
@interface BibOptions: NSObject <NSCopying>

@property(nonatomic, readwrite, copy, nullable) NSString *user;
@property(nonatomic, readwrite, copy, nullable) NSString *group;
@property(nonatomic, readwrite, copy, nullable) NSString *password;
@property(nonatomic, readwrite, copy, nullable) NSString *lang;
@property(nonatomic, readwrite, copy, nullable) NSString *charset;
@property(nonatomic, readwrite, copy, nullable) NSString *databaseName;

@end

NS_ASSUME_NONNULL_END
