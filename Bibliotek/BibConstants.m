//
//  BibConstants.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/27/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConstants.h"
#import <yaz/zoom.h>

#pragma mark Error Domain

NSErrorDomain const BibConnectionErrorDomain = @"brun.steve.bibliotek.connection.error";

NSErrorUserInfoKey const BibConnectionErrorConnectionKey = @"brun.steve.bibliotek.connection.error.connection";
NSErrorUserInfoKey const BibConnectionErrorEventKey = @"brun.steve.bibliotek.connection.error.event";

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

#pragma mark - Connection Events

NSString *BibConnectionEventDescription(BibConnectionEvent const event) {
    switch (event) {
        case ZOOM_EVENT_NONE: return @"No event";
        case ZOOM_EVENT_CONNECT: return @"Open connection event";
        case ZOOM_EVENT_SEND_DATA : return @"Sent data";
        case ZOOM_EVENT_RECV_DATA: return @"Received data";
        case ZOOM_EVENT_TIMEOUT: return @"Timeout event";
        case ZOOM_EVENT_UNKNOWN: return @"Unknown event";
        case ZOOM_EVENT_SEND_APDU: return @"Sent APDU";
        case ZOOM_EVENT_RECV_APDU: return @"Received APDU";
        case ZOOM_EVENT_RECV_RECORD: return @"Received record";
        case ZOOM_EVENT_RECV_SEARCH: return @"Received search";
        case ZOOM_EVENT_END: return @"Close connection event";
        default: return nil;
    }
}
