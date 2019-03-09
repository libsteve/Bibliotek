//
//  BibBibliographicTitleStatement.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicTitleStatement.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"245";

static NSPredicate *sTitlePredicate;
static NSPredicate *sSubtitlePredicate;
static NSPredicate *sAuthorPredicate;
static NSPredicate *sSectionIndexPredicate;
static NSPredicate *sSectionNamePredicate;

@implementation BibBibliographicTitleStatement

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTitlePredicate = [NSPredicate predicateWithFormat:@"code == 'a'"];
        sSubtitlePredicate = [NSPredicate predicateWithFormat:@"code = 'b'"];
        sAuthorPredicate = [NSPredicate predicateWithFormat:@"code = 'c'"];
        sSectionIndexPredicate = [NSPredicate predicateWithFormat:@"code = 'n'"];
        sSectionNamePredicate = [NSPredicate predicateWithFormat:@"code = 'p'"];
    });
}

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _nonfillingCharacterCount = [[indicators lastObject] integerValue];
        _title = [[[[subfields filteredArrayUsingPredicate:sTitlePredicate] firstObject] content] copy];
        _subtitle = [[[[subfields filteredArrayUsingPredicate:sSubtitlePredicate] firstObject] content] copy];
        _authorStatement = [[[[subfields filteredArrayUsingPredicate:sAuthorPredicate] firstObject] content] copy];
        _sectionIndex = [[[[subfields filteredArrayUsingPredicate:sSectionIndexPredicate] firstObject] content] copy];
        _sectionName = [[[[subfields filteredArrayUsingPredicate:sSectionNamePredicate] firstObject] content] copy];
    }
    return self;
}

@end
