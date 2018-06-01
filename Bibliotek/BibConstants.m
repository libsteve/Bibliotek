//
//  BibConstants.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/27/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConstants.h"

#pragma mark Error Domain

NSErrorDomain const BibConnectionErrorDomain = @"BibConnectionErrorDomain";

NSErrorUserInfoKey const BibConnectionErrorName = @"BibConnectionErrorName";
NSErrorUserInfoKey const BibConnectionErrorInfo = @"BibConnectionErrorInfo";

#pragma mark - Authentication Mode

BibAuthenticationMode const BibAuthenticationModeBasic = @"basic";
BibAuthenticationMode const BibAuthenticationModeUrl = @"url";

#pragma mark - Sort Strategy

BibSortStrategy const BibSortStrategyZ3950 = @"z39.50";
BibSortStrategy const BibSortStrategyType7 = @"type7";
BibSortStrategy const BibSortStrategyCql = @"cql";
BibSortStrategy const BibSortStrategySrull = @"srull";
BibSortStrategy const BibSortStrategySolr = @"solr";
BibSortStrategy const BibSortStrategyEmbed = @"embed";

#pragma mark - Bibliographic Fields

BibFetchRequestScope const BibFetchRequestScopePersonalName = @"@attr 1=1";
BibFetchRequestScope const BibFetchRequestScopeTitle = @"@attr 1=4";
BibFetchRequestScope const BibFetchRequestScopeTitleSeries = @"@attr 1=5";
BibFetchRequestScope const BibFetchRequestScopeIsbn = @"@attr 1=7";
BibFetchRequestScope const BibFetchRequestScopeDDC = @"@attr 1=13";
BibFetchRequestScope const BibFetchRequestScopeLCC = @"@attr 1=16";
BibFetchRequestScope const BibFetchRequestScopeSubject = @"@attr 1=21";
BibFetchRequestScope const BibFetchRequestScopeLanguage = @"@attr 1=54";
BibFetchRequestScope const BibFetchRequestScopeName = @"@attr 1=1002";
BibFetchRequestScope const BibFetchRequestScopeAuthor = @"@attr 1=1003";
BibFetchRequestScope const BibFetchRequestScopeBodyOfText = @"@attr 1=1010";
BibFetchRequestScope const BibFetchRequestScopeAny = @"@attr 1=1016";
BibFetchRequestScope const BibFetchRequestScopePublisher = @"@attr 1=1018";
BibFetchRequestScope const BibFetchRequestScopeAnywhere = @"@attr 1=1035";
BibFetchRequestScope const BibFetchRequestScopeAuthorTitleSubject = @"@attr 1=1036";

NSString *BibFetchRequestScopeDescription(BibFetchRequestScope const scope) {
    if (scope == BibFetchRequestScopePersonalName) return @"Personal-Name";
    if (scope == BibFetchRequestScopeTitle) return @"Title";
    if (scope == BibFetchRequestScopeTitleSeries) return @"Title-Series";
    if (scope == BibFetchRequestScopeIsbn) return @"ISBN";
    if (scope == BibFetchRequestScopeDDC) return @"DDC";
    if (scope == BibFetchRequestScopeLCC) return @"LCC";
    if (scope == BibFetchRequestScopeSubject) return @"Subject";
    if (scope == BibFetchRequestScopeLanguage) return @"Language";
    if (scope == BibFetchRequestScopeName) return @"Name";
    if (scope == BibFetchRequestScopeAuthor) return @"Author";
    if (scope == BibFetchRequestScopeBodyOfText) return @"Body-of-Text";
    if (scope == BibFetchRequestScopeAny) return @"Any";
    if (scope == BibFetchRequestScopePublisher) return @"Publisher";
    if (scope == BibFetchRequestScopeAnywhere) return @"Anywhere";
    if (scope == BibFetchRequestScopeAuthorTitleSubject) return @"Author-Title-Subject";
    return @"Invalid BibFetchRequestScope";
}

#pragma mark - Query Structure

BibFetchRequestStructure const BibFetchRequestStructurePhrase = @"@attr 4=1";
BibFetchRequestStructure const BibFetchRequestStructureWord = @"@attr 4=2";
BibFetchRequestStructure const BibFetchRequestStructureKey = @"@attr 4=3";
BibFetchRequestStructure const BibFetchRequestStructureYear = @"@attr 4=4";
BibFetchRequestStructure const BibFetchRequestStructureDate = @"@attr 4=5";
BibFetchRequestStructure const BibFetchRequestStructureWordList = @"@attr 4=6";
BibFetchRequestStructure const BibFetchRequestStructureFreeFormText = @"@attr 4=105";
BibFetchRequestStructure const BibFetchRequestStructureDocumentText = @"@attr 4=106";

NSString *BibFetchRequestStructureDescription(BibFetchRequestStructure const structure) {
    if (structure == BibFetchRequestStructurePhrase) return @"Phrase";
    if (structure == BibFetchRequestStructureWord) return @"Word";
    if (structure == BibFetchRequestStructureKey) return @"Key";
    if (structure == BibFetchRequestStructureYear) return @"Year";
    if (structure == BibFetchRequestStructureDate) return @"Date";
    if (structure == BibFetchRequestStructureWordList) return @"Word-List";
    if (structure == BibFetchRequestStructureFreeFormText) return @"Free-Form-Text";
    if (structure == BibFetchRequestStructureDocumentText) return @"Document-Text";
    return @"Invalid BibFetchRequestStructure";
}

#pragma mark - Query Search Strategy

BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySuffix = @"@attr 5=1";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyPrefix = @"@attr 5=2";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySubstring = @"@attr 5=3";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyStrict = @"@attr 5=100";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyFuzzy = @"@attr 5=101";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyRegex = @"@attr 5=102";

NSString *BibFetchRequestSearchStrategyDescription(BibFetchRequestSearchStrategy const strategy) {
    if (strategy == BibFetchRequestSearchStrategySuffix) return @"Suffix";
    if (strategy == BibFetchRequestSearchStrategyPrefix) return @"Prefix";
    if (strategy == BibFetchRequestSearchStrategySubstring) return @"Substring";
    if (strategy == BibFetchRequestSearchStrategyStrict) return @"Strict";
    if (strategy == BibFetchRequestSearchStrategyFuzzy) return @"Fuzzy";
    if (strategy == BibFetchRequestSearchStrategyRegex) return @"Regex";
    return @"Invalid BibFetchRequestSearchStrategy";
}
