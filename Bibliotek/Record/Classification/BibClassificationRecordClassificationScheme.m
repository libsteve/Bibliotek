//
//  BibClassificationRecordScheme.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationRecord.h"
#import "BibClassificationRecordClassificationScheme.h"
#import "BibRecordSubfield.h"

static BibRecordFieldIndicator sFullEdition;
static BibRecordFieldIndicator sAbridgedEdition;
static BibRecordFieldIndicator sOtherEdition;

static NSPredicate *sSchemePredicate;
static NSPredicate *sEditionTitlePredicate;
static NSPredicate *sEditionIdentifierPredicate;
static NSPredicate *sLanguagePredicate;
static NSPredicate *sAuthorizationPredicate;
static NSPredicate *sAssigningAgencyPredicate;

@implementation BibClassificationRecordClassificationScheme

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFullEdition = [NSString stringWithFormat:@"%c", (char)BibEditionKindFull];
        sAbridgedEdition = [NSString stringWithFormat:@"%c", (char)BibEditionKindAbridged];
        sOtherEdition = [NSString stringWithFormat:@"%c", (char)BibEditionKindOther];

        sSchemePredicate = [NSPredicate predicateWithFormat:@"code == 'a'"];
        sEditionTitlePredicate = [NSPredicate predicateWithFormat:@"code == 'b'"];
        sEditionIdentifierPredicate = [NSPredicate predicateWithFormat:@"code == 'c'"];
        sLanguagePredicate = [NSPredicate predicateWithFormat:@"code == 'e'"];
        sAuthorizationPredicate = [NSPredicate predicateWithFormat:@"code == 'f'"];
        sAssigningAgencyPredicate = [NSPredicate predicateWithFormat:@"code == 'q'"];
    });
}

+ (BibRecordFieldTag)recordFieldTag {
    return BibRecordFieldTagClassificationRecordClassificationScheme;
}

- (instancetype)init {
    return [self initWithIndicators:@[sOtherEdition, BibRecordFieldIndicatorBlank]
                          subfields:@[[[BibRecordSubfield alloc] initWithCode:@"a" content:@"lcc"]]];
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super init]) {
        _editionKind = [[indicators firstObject] characterAtIndex:0];
        _classificationScheme = [[[subfields filteredArrayUsingPredicate:sSchemePredicate] firstObject] content];
        _editionTitle = [[[subfields filteredArrayUsingPredicate:sEditionTitlePredicate] firstObject] content];
        _editionIdentifier = [[[subfields filteredArrayUsingPredicate:sEditionIdentifierPredicate] firstObject] content];
        _language = [[[subfields filteredArrayUsingPredicate:sLanguagePredicate] firstObject] content];
        _authorization = [[[subfields filteredArrayUsingPredicate:sAuthorizationPredicate] firstObject] content];
        _assigningAgency = [[[subfields filteredArrayUsingPredicate:sAssigningAgencyPredicate] firstObject] content];
    }
    return self;
}

@end
