//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibClassification;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Record)
@interface BibRecord : NSObject

@property(nonatomic, readonly, copy) NSString *syntax;
@property(nonatomic, readonly, copy) NSString *schema;
@property(nonatomic, readonly, copy) NSString *database;

@property(nonatomic, readonly, copy) NSString *isbn;
@property(nonatomic, readonly, copy) NSArray<BibClassification *> *classifications;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
