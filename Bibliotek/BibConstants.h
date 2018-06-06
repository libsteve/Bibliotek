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

typedef NS_ENUM(NSInteger, BibFetchRequestNotation) {
    BibFetchRequestNotationPqf,
    BibFetchRequestNotationCql
} NS_SWIFT_NAME(QueryNotation);

#pragma mark - Authentication Mode

typedef NSString *BibAuthenticationMode NS_TYPED_ENUM NS_SWIFT_NAME(AuthenticationMode);

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

#pragma mark - Bibliographic Fields

typedef NSString *BibFetchRequestScope NS_TYPED_ENUM NS_SWIFT_NAME(FetchRequest.Scope);

extern BibFetchRequestScope const BibFetchRequestScopePersonalName;
extern BibFetchRequestScope const BibFetchRequestScopeTitle;
extern BibFetchRequestScope const BibFetchRequestScopeTitleSeries;
extern BibFetchRequestScope const BibFetchRequestScopeIsbn;
extern BibFetchRequestScope const BibFetchRequestScopeDDC NS_SWIFT_NAME(ddc);
extern BibFetchRequestScope const BibFetchRequestScopeLCC NS_SWIFT_NAME(lcc);
extern BibFetchRequestScope const BibFetchRequestScopeSubject;
extern BibFetchRequestScope const BibFetchRequestScopeLanguage;
extern BibFetchRequestScope const BibFetchRequestScopeName;
extern BibFetchRequestScope const BibFetchRequestScopeAuthor;
extern BibFetchRequestScope const BibFetchRequestScopeBodyOfText;
extern BibFetchRequestScope const BibFetchRequestScopeAny;
extern BibFetchRequestScope const BibFetchRequestScopePublisher;
extern BibFetchRequestScope const BibFetchRequestScopeAnywhere;
extern BibFetchRequestScope const BibFetchRequestScopeAuthorTitleSubject;

extern NSString *BibFetchRequestScopeDescription(BibFetchRequestScope const scope) NS_REFINED_FOR_SWIFT;

#pragma mark - Query Structure

typedef NSString *BibFetchRequestStructure NS_TYPED_ENUM NS_SWIFT_NAME(FetchRequest.Structure);

extern BibFetchRequestStructure const BibFetchRequestStructurePhrase;
extern BibFetchRequestStructure const BibFetchRequestStructureWord;
extern BibFetchRequestStructure const BibFetchRequestStructureKey;
extern BibFetchRequestStructure const BibFetchRequestStructureYear;
extern BibFetchRequestStructure const BibFetchRequestStructureDate;
extern BibFetchRequestStructure const BibFetchRequestStructureWordList;
extern BibFetchRequestStructure const BibFetchRequestStructureFreeFormText;
extern BibFetchRequestStructure const BibFetchRequestStructureDocumentText;

extern NSString *BibFetchRequestStructureDescription(BibFetchRequestStructure const structure) NS_REFINED_FOR_SWIFT;

#pragma mark - Query Search Strategy

typedef NSString *BibFetchRequestSearchStrategy NS_TYPED_ENUM NS_SWIFT_NAME(FetchRequest.SearchStrategy);

extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySuffix;
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyPrefix;
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySubstring;
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyStrict;
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyFuzzy;
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyRegex;

extern NSString *BibFetchRequestSearchStrategyDescription(BibFetchRequestSearchStrategy const strategy) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
