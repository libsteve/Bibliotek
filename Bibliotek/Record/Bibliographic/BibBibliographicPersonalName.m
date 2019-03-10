//
//  BibBibliographicPersonalName.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicPersonalName.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"100";

static NSPredicate *sNamePredicate;
static NSPredicate *sNumerationPredicate;
static NSPredicate *sTitlesPredicate;
static NSPredicate *sDatesPredicate;
static NSPredicate *sRelationTermsPredicate;
static NSPredicate *sAttributionPredicate;
static NSPredicate *sFullerNamePredicate;
static NSPredicate *sAffiliationPredicate;
static NSPredicate *sRelationCodesPredicate;

@implementation BibBibliographicPersonalName

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sNamePredicate = [NSPredicate predicateWithFormat:@"code = 'a'"];
        sNumerationPredicate = [NSPredicate predicateWithFormat:@"code = 'b'"];
        sTitlesPredicate = [NSPredicate predicateWithFormat:@"code = 'c'"];
        sDatesPredicate = [NSPredicate predicateWithFormat:@"code = 'd'"];
        sRelationTermsPredicate = [NSPredicate predicateWithFormat:@"code = 'e'"];
        sAttributionPredicate = [NSPredicate predicateWithFormat:@"code = 'j'"];
        sFullerNamePredicate = [NSPredicate predicateWithFormat:@"code = 'q'"];
        sAffiliationPredicate = [NSPredicate predicateWithFormat:@"code = 'u'"];
        sRelationCodesPredicate = [NSPredicate predicateWithFormat:@"code = '4'"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _kind = [[indicators firstObject] characterAtIndex:0];
        _name = [[[subfields filteredArrayUsingPredicate:sNamePredicate] firstObject] content];
        _numeration = [[[subfields filteredArrayUsingPredicate:sNumerationPredicate] firstObject] content];
        _title = [[[subfields filteredArrayUsingPredicate:sTitlesPredicate] firstObject] content];
        _dates = [[[subfields filteredArrayUsingPredicate:sDatesPredicate] firstObject] content];
        _relationTerms = [[subfields filteredArrayUsingPredicate:sRelationTermsPredicate] valueForKey:@"content"];
        _attributionQualifiers = [[subfields filteredArrayUsingPredicate:sAttributionPredicate] valueForKey:@"content"];
        _fullerName = [[[subfields filteredArrayUsingPredicate:sFullerNamePredicate] firstObject] content];
        _affiliation = [[[subfields filteredArrayUsingPredicate:sAffiliationPredicate] firstObject] content];
        _relationCodes = [[subfields filteredArrayUsingPredicate:sRelationCodesPredicate] valueForKey:@"content"];
        if (_name == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
    }
    return self;
}

@end
