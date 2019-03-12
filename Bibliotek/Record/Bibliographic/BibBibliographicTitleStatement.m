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
        if (_title == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
    }
    return self;
}

- (NSString *)description {
    NSString *content[5] = {_title, _subtitle, _authorStatement, _sectionIndex, _sectionName};
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:5];
    for (int index = 0; index < 5; index += 1) {
        NSString *string = content[index];
        if (string) {
            [strings addObject:string];
        }
    }
    return [strings componentsJoinedByString:@" "];
}

@end
