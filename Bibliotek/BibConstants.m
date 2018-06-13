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
    if ([scope isEqualToString:BibFetchRequestScopePersonalName]) return @"Personal-Name";
    if ([scope isEqualToString:BibFetchRequestScopeTitle]) return @"Title";
    if ([scope isEqualToString:BibFetchRequestScopeTitleSeries]) return @"Title-Series";
    if ([scope isEqualToString:BibFetchRequestScopeIsbn]) return @"ISBN";
    if ([scope isEqualToString:BibFetchRequestScopeDDC]) return @"Dewey-Decimal-Classification";
    if ([scope isEqualToString:BibFetchRequestScopeLCC]) return @"Library-of-Congress-Classification";
    if ([scope isEqualToString:BibFetchRequestScopeSubject]) return @"Subject";
    if ([scope isEqualToString:BibFetchRequestScopeLanguage]) return @"Language";
    if ([scope isEqualToString:BibFetchRequestScopeName]) return @"Name";
    if ([scope isEqualToString:BibFetchRequestScopeAuthor]) return @"Author";
    if ([scope isEqualToString:BibFetchRequestScopeBodyOfText]) return @"Body-of-Text";
    if ([scope isEqualToString:BibFetchRequestScopeAny]) return @"Any";
    if ([scope isEqualToString:BibFetchRequestScopePublisher]) return @"Publisher";
    if ([scope isEqualToString:BibFetchRequestScopeAnywhere]) return @"Anywhere";
    if ([scope isEqualToString:BibFetchRequestScopeAuthorTitleSubject]) return @"Author-Title-Subject";
    return [NSString stringWithFormat:@"Unknown-Scope(%@)", scope];
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
    if ([structure isEqualToString:BibFetchRequestStructurePhrase]) return @"Phrase";
    if ([structure isEqualToString:BibFetchRequestStructureWord]) return @"Word";
    if ([structure isEqualToString:BibFetchRequestStructureKey]) return @"Key";
    if ([structure isEqualToString:BibFetchRequestStructureYear]) return @"Year";
    if ([structure isEqualToString:BibFetchRequestStructureDate]) return @"Date";
    if ([structure isEqualToString:BibFetchRequestStructureWordList]) return @"Word-List";
    if ([structure isEqualToString:BibFetchRequestStructureFreeFormText]) return @"Free-Form-Text";
    if ([structure isEqualToString:BibFetchRequestStructureDocumentText]) return @"Document-Text";
    return [NSString stringWithFormat:@"Unknown-Structure(%@)", structure];
}

#pragma mark - Query Search Strategy

BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySuffix = @"@attr 5=1";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyPrefix = @"@attr 5=2";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategySubstring = @"@attr 5=3";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyStrict = @"@attr 5=100";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyFuzzy = @"@attr 5=101";
BibFetchRequestSearchStrategy const BibFetchRequestSearchStrategyRegex = @"@attr 5=102";

NSString *BibFetchRequestSearchStrategyDescription(BibFetchRequestSearchStrategy const strategy) {
    if ([strategy isEqualToString:BibFetchRequestSearchStrategySuffix]) return @"Suffix";
    if ([strategy isEqualToString:BibFetchRequestSearchStrategyPrefix]) return @"Prefix";
    if ([strategy isEqualToString:BibFetchRequestSearchStrategySubstring]) return @"Substring";
    if ([strategy isEqualToString:BibFetchRequestSearchStrategyStrict]) return @"Strict";
    if ([strategy isEqualToString:BibFetchRequestSearchStrategyFuzzy]) return @"Fuzzy";
    if ([strategy isEqualToString:BibFetchRequestSearchStrategyRegex]) return @"Regex";
    return [NSString stringWithFormat:@"Unknown-Strategy(%@)", strategy];
}

#pragma mark - Record Field Tags

BibRecordFieldTag const BibRecordFieldTagIsbn = @"020";
BibRecordFieldTag const BibRecordFieldTagLCC = @"050";
BibRecordFieldTag const BibRecordFieldTagDDC = @"082";
BibRecordFieldTag const BibRecordFieldTagAuthor = @"100";
BibRecordFieldTag const BibRecordFieldTagTitle = @"245";
BibRecordFieldTag const BibRecordFieldTagEdition = @"250";
BibRecordFieldTag const BibRecordFieldTagPublication = @"264";
BibRecordFieldTag const BibRecordFieldTagPhysicalDescription = @"300";
BibRecordFieldTag const BibRecordFieldTagNote = @"500";
BibRecordFieldTag const BibRecordFieldTagBibliography = @"504";
BibRecordFieldTag const BibRecordFieldTagSummary = @"520";
BibRecordFieldTag const BibRecordFieldTagSubject = @"650";
BibRecordFieldTag const BibRecordFieldTagGenre = @"655";
BibRecordFieldTag const BibRecordFieldTagSeries = @"940";

NSString *BibRecordFieldTagDescription(BibRecordFieldTag const tag) {
    if ([tag isEqualToString: BibRecordFieldTagIsbn]) return @"ISBN";
    if ([tag isEqualToString: BibRecordFieldTagLCC]) return @"LCC";
    if ([tag isEqualToString: BibRecordFieldTagDDC]) return @"DDC";
    if ([tag isEqualToString: BibRecordFieldTagAuthor]) return @"Author";
    if ([tag isEqualToString: BibRecordFieldTagTitle]) return @"Title";
    if ([tag isEqualToString: BibRecordFieldTagEdition]) return @"Edition";
    if ([tag isEqualToString: BibRecordFieldTagPublication]) return @"Publication";
    if ([tag isEqualToString: BibRecordFieldTagPhysicalDescription]) return @"Physical-Description";
    if ([tag isEqualToString: BibRecordFieldTagNote]) return @"Note";
    if ([tag isEqualToString: BibRecordFieldTagBibliography]) return @"Bibliography";
    if ([tag isEqualToString: BibRecordFieldTagSummary]) return @"Summary";
    if ([tag isEqualToString: BibRecordFieldTagSubject]) return @"Subject";
    if ([tag isEqualToString: BibRecordFieldTagGenre]) return @"Genre";
    if ([tag isEqualToString: BibRecordFieldTagSeries]) return @"Series";
    return [NSString stringWithFormat:@"Unknown-Tag(%@)", tag];
}

#pragma mark - Record Field Indicator

NSString *BibRecordFieldIndicatorDescription(BibRecordFieldIndicator const indicator) {
    return [NSString stringWithFormat:@"%c", indicator];
}

#pragma mark - Record Field Code

NSString *BibRecordFieldCodeDescription(BibRecordFieldCode const code) {
    return [NSString stringWithFormat:@"$%c", code];
}

#pragma mark - Classification System

BibClassificationSystem const BibClassificationSystemLCC = @"Library of Congress";
BibClassificationSystem const BibClassificationSystemDDC = @"Dewey Decimal";

NSString *BibClassificationSystemDescription(BibClassificationSystem const system) {
    return [NSString stringWithFormat:@"%@ System", system];
}
