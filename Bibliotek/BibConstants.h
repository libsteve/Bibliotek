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

/// An error pertaining to the connection with a z39.50 host.
extern NSErrorDomain const BibConnectionErrorDomain NS_REFINED_FOR_SWIFT;

extern NSErrorUserInfoKey const BibConnectionErrorConnectionKey;
extern NSErrorUserInfoKey const BibConnectionErrorEventKey;

/// An indicator for the cause of an error encountered while making a connection with a host.
typedef NS_ERROR_ENUM(BibConnectionErrorDomain, BibConnectionError) {
    /// A connection with the specified host, port, and database could not be made.
    BibConnectionErrorFailed = 10000,

    /// The connection was abruptly closed.
    BibConnectionErrorLost = 10004,

    /// The endpoint rejected the connection request, possibly due to incorrect credentials.
    BibConnectionErrorDenied = 10005,

    /// The endpoint did not respond within the expected amount of time.
    BibConnectionErrorTimeout = 10007,
} NS_SWIFT_NAME(ConnectionError);

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

/// The type of sorting that should be used when returning results from a fetch request.
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

/// The semantic meaning for search terms used in a fetch request.
typedef NSString *BibFetchRequestScope NS_TYPED_ENUM NS_SWIFT_NAME(FetchRequest.Scope);

extern BibFetchRequestScope const BibFetchRequestScopePersonalName;

/// Find records whose titles match a query.
extern BibFetchRequestScope const BibFetchRequestScopeTitle;

/// Find records whose series matches a query.
extern BibFetchRequestScope const BibFetchRequestScopeTitleSeries;

/// Find records whose ISBN matches a query.
extern BibFetchRequestScope const BibFetchRequestScopeIsbn;

/// Find records whose Dewey Decimal classifications match a query.
extern BibFetchRequestScope const BibFetchRequestScopeDDC NS_SWIFT_NAME(ddc);

/// Find records whose Library of Congress classifications match a query.
extern BibFetchRequestScope const BibFetchRequestScopeLCC NS_SWIFT_NAME(lcc);

/// Find records whose subjects match a query.
extern BibFetchRequestScope const BibFetchRequestScopeSubject;

/// Find records based on their language.
extern BibFetchRequestScope const BibFetchRequestScopeLanguage;

extern BibFetchRequestScope const BibFetchRequestScopeName;

/// Find records whose authors match a query.
extern BibFetchRequestScope const BibFetchRequestScopeAuthor;

/// Find records whose content matches a query.
extern BibFetchRequestScope const BibFetchRequestScopeBodyOfText;

/// Find records with any field that matches a query.
extern BibFetchRequestScope const BibFetchRequestScopeAny;

/// Find records whose publishers match a query.
extern BibFetchRequestScope const BibFetchRequestScopePublisher;

/// Find records with any field that matches a query.
extern BibFetchRequestScope const BibFetchRequestScopeAnywhere;

/// Find records whose titles, subjects, or authors match the query.
extern BibFetchRequestScope const BibFetchRequestScopeAuthorTitleSubject;

/// \returns A string description of the given scope.
extern NSString *BibFetchRequestScopeDescription(BibFetchRequestScope const scope) NS_REFINED_FOR_SWIFT;

#pragma mark - Query Structure

/// The method with which a fetch request should treat keywords.
typedef NSString *BibFetchRequestStructure NS_TYPED_ENUM NS_SWIFT_NAME(FetchRequest.Structure);

/// Treat the keywords in a fetch request as a complete phrase.
extern BibFetchRequestStructure const BibFetchRequestStructurePhrase;

/// Treat each keyword in a fetch request as an individual word.
extern BibFetchRequestStructure const BibFetchRequestStructureWord;
extern BibFetchRequestStructure const BibFetchRequestStructureKey;

/// Treat each keyword in a fetch request as a year.
extern BibFetchRequestStructure const BibFetchRequestStructureYear;

/// Treat each keyword in a fetch request as a date.
extern BibFetchRequestStructure const BibFetchRequestStructureDate;

/// Treat the keywords in a fetch request as a list of possible words with which to match records.
extern BibFetchRequestStructure const BibFetchRequestStructureWordList;
extern BibFetchRequestStructure const BibFetchRequestStructureFreeFormText;
extern BibFetchRequestStructure const BibFetchRequestStructureDocumentText;

/// \returns A string description of the given structure.
extern NSString *BibFetchRequestStructureDescription(BibFetchRequestStructure const structure) NS_REFINED_FOR_SWIFT;

#pragma mark - Query Search Strategy

/// The location within the search scope to match keywords within a fetch request.
typedef NSString *BibFetchRequestSearchStrategy NS_TYPED_ENUM NS_SWIFT_NAME(FetchRequest.SearchStrategy);

/// Match keywords to records only if the relevant scope ends with the keyword.
///
/// For example, the keyword "piece" would match both "piece" and "masterpiece".
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySuffix;

/// Match keywords to records only if the relevant scope begins with the keyword.
///
/// For example, the keyword "hot" would match both "hot" and "hotdog".
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyPrefix;

/// Match keywords to records if the relevant scope contains the keyword.
///
/// For example, the keyword "big" would match "ambiguous".
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySubstring;

/// Match keywords to records only if the relevant scope exactly matches the keyword.
///
/// For example, the keyword "chair" would match only "chair", and not "chairman".
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyStrict;

/// Match keywords to records strictly matching all characters, while treating "#" as a wildcard.
///
/// For example, the keyword "d#r" would match "dr", "door", "driver", and "darker".
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyFuzzy;

/// Treat keywords like regular expressions when matching them against records' scopes.
///
/// For example, the keyword "a.*" would match both "animal" and "anaconda".
extern BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyRegex;

/// \returns A string description of the given strategy.
extern NSString *BibFetchRequestSearchStrategyDescription(BibFetchRequestSearchStrategy const strategy) NS_REFINED_FOR_SWIFT;

#pragma mark - Record Field Tags

/// An code identifying the semantic purpose of a record field.
typedef NSString *BibRecordFieldTag NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldTag);

/// The field contains an item's ISBN.
extern BibRecordFieldTag const BibRecordFieldTagIsbn;

/// The field contains a Library of Congress classification number.
extern BibRecordFieldTag const BibRecordFieldTagLCC NS_SWIFT_NAME(lcc);

/// The field contains a Dewey Decimal classification number.
extern BibRecordFieldTag const BibMarcRecordFieldTagDDC NS_SWIFT_NAME(ddc);

/// The field contains an author's name.
extern BibRecordFieldTag const BibRecordFieldTagAuthor;

/// The field contains the title of the item.
extern BibRecordFieldTag const BibRecordFieldTagTitle;

/// The field contains edition information about the item.
extern BibRecordFieldTag const BibRecordFieldTagEdition;

/// The field contains information about the publisher.
extern BibRecordFieldTag const BibRecordFieldTagPublication;

/// The field contains a description of an item's physical condition.
extern BibRecordFieldTag const BibRecordFieldTagPhysicalDescription;

/// The field contains a note within the record.
extern BibRecordFieldTag const BibRecordFieldTagNote;
extern BibRecordFieldTag const BibRecordFieldTagBibliography;

/// The field contains a summary about the item.
extern BibRecordFieldTag const BibRecordFieldTagSummary;

/// The field contains a subject heading.
extern BibRecordFieldTag const BibRecordFieldTagSubject;

/// The field contains a genre to which an item belongs.
extern BibRecordFieldTag const BibRecordFieldTagGenre;

/// The field contains the name of the series to which an item belongs.
extern BibRecordFieldTag const BibRecordFieldTagSeries;

/// \returns A string description of the given feild tag.
extern NSString *BibRecordFieldTagDescription(BibRecordFieldTag const tag) NS_REFINED_FOR_SWIFT;

#pragma mark - Record Field Indicator

typedef char BibRecordFieldIndicator NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldIndicator);

extern NSString *BibRecordFieldIndicatorDescription(BibRecordFieldIndicator const indicator) NS_REFINED_FOR_SWIFT;

#pragma mark - Record Field Code

typedef char BibRecordFieldCode NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldCode);

extern NSString *BibRecordFieldCodeDescription(BibRecordFieldCode const code) NS_REFINED_FOR_SWIFT;

#pragma mark - Connetion Events

typedef NS_ENUM(NSInteger, BibConnectionEvent) {
    BibConnectionEventNone = 0,
    BibConnectionEventDidConnect = 1,
    BibConnectionEventDidSendData = 2,
    BibConnectionEventDidReceiveData = 3,
    BibConnectionEventDidTimeout = 4,
    BibConnectionEventUnknown = 5,
    BibConnectionEventDidSendAPDU = 6,
    BibConnectionEventDidReceiveAPDU = 7,
    BibConnectionEventDidReceiveRecord = 8,
    BibConnectionEventDidReceiveSearch = 9,
    BibConnectionEventDidEndConnection = 10
} NS_SWIFT_NAME(Connection.Event);

extern NSString *BibConnectionEventDescription(BibConnectionEvent const event) NS_REFINED_FOR_SWIFT;


NS_ASSUME_NONNULL_END
