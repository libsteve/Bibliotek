//
//  BibLCCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibLCCallNumber : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *stringValue;

- (nullable instancetype)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)callNumberWithString:(NSString *)string NS_SWIFT_UNAVAILABLE("Use init(string:)");

- (NSComparisonResult)compare:(BibLCCallNumber *)other;

- (BOOL)isEqualToCallNumber:(BibLCCallNumber *)other;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
