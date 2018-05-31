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

#pragma mark - Bibliographic Attributes

BibQueryAttribute const BibQueryAttributePersonalName = @"@attr 1=1";
BibQueryAttribute const BibQueryAttributeTitle = @"@attr 1=4";
BibQueryAttribute const BibQueryAttributeTitleSeries = @"@attr 1=5";
BibQueryAttribute const BibQueryAttributeIsbn = @"@attr 1=7";
BibQueryAttribute const BibQueryAttributeDDC = @"@attr 1=13";
BibQueryAttribute const BibQueryAttributeLCC = @"@attr 1=16";
BibQueryAttribute const BibQueryAttributeSubjectHeading = @"@attr 1=21";
BibQueryAttribute const BibQueryAttributeAuthor = @"@attr 1=1003";
BibQueryAttribute const BibQueryAttributeBodyOfText = @"@attr 1=1010";
BibQueryAttribute const BibQueryAttributeAny = @"@attr 1=1016";
BibQueryAttribute const bibQueryAttributePublisher = @"@attr 1=1018";
BibQueryAttribute const BibQueryAttributeAnywhere = @"@attr 1=1035";
BibQueryAttribute const bibQueryAttributeAuthorTitleSubject = @"@attr 1=1036";
