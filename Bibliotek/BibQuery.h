//
//  BibQuery.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *BibSortStrategy NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(ZoomSortStrategy);

typedef NS_ENUM(NSInteger, BibQueryNotation) {
    BibQueryNotationPqf,
    BibQueryNotationCql
} NS_SWIFT_NAME(Query.Notation);

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Query)
@interface BibQuery : NSObject <NSCopying>

@property(nonatomic, readonly, copy) NSString *query;

@property(nonatomic, readonly, assign) BibQueryNotation notation;

@property(nonatomic, readwrite, copy, nullable) BibSortStrategy strategy;

@property(nonatomic, readwrite, copy, nullable) NSString *criteria;

- (instancetype)initWithQuery:(NSString *)query notation:(BibQueryNotation)notation NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Sort Strategy

/// Z39.50 resultset sort.
extern BibSortStrategy const BibSortStrategyZ3950;

/// Sorting embedded in RPN(Type-7).
extern BibSortStrategy const BibSortStrategyType7;

/// CQL SORTBY.
extern BibSortStrategy const BibSortStrategyCql;

/// SRU sortKeys parameter.
extern BibSortStrategy const BibSortStrategySrull;

/// Solr sort.
extern BibSortStrategy const BibSortStrategySolr;

/// type7 for Z39.50, cql for SRU, solr for Solr protocol.
extern BibSortStrategy const BibSortStrategyEmbed;

NS_ASSUME_NONNULL_END
