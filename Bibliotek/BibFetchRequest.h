//
//  BibFetchRequest.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibQueryNotation.h"
#import "BibSortStrategy.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FetchRequest)
@interface BibFetchRequest : NSObject <NSCopying>

@property(nonatomic, readonly, copy) NSString *query;

/// Defaults to @c BibQueryNotationPqf (@c QueryNotation.pqf in Swift).
@property(nonatomic, readonly, assign) BibQueryNotation notation;

@property(nonatomic, readwrite, copy, nullable) BibSortStrategy strategy;

@property(nonatomic, readwrite, copy, nullable) NSString *criteria;

- (instancetype)initWithQuery:(NSString *)query notation:(BibQueryNotation)notation NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
