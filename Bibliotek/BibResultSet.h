//
//  BibResultSet.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibConnection;
@class BibQuery;
@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ResultSet)
@interface BibResultSet : NSObject

@property(nonatomic, readonly, copy, nonnull) NSArray<BibRecord *> *records;

- (instancetype)initWithConnection:(BibConnection *)connection query:(BibQuery *)query NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (BibRecord *)objectAtIndexedSubscript:(int)index;

@end

NS_ASSUME_NONNULL_END
