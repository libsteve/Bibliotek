//
//  BibConstants.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/27/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Error Domain

extern NSErrorDomain const BibConnectionErrorDomain;

extern NSErrorUserInfoKey const BibConnectionErrorName;
extern NSErrorUserInfoKey const BibConnectionErrorInfo;

#pragma mark Query Notation

typedef NS_ENUM(NSInteger, BibQueryNotation) {
    BibQueryNotationPqf,
    BibQueryNotationCql
} NS_SWIFT_NAME(QueryNotation);

#pragma mark - Authentication Mode

typedef NSString *BibAuthenticationMode NS_STRING_ENUM NS_SWIFT_NAME(AuthenticationMode);

extern BibAuthenticationMode const BibAuthenticationModeBasic;
extern BibAuthenticationMode const BibAuthenticationModeUrl;

#pragma mark - Sort Strategy

typedef NSString *BibSortStrategy NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(ZoomSortStrategy);

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
