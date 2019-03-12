//
//  BibBibliographicSummary.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/12/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicSummary.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"520";

static NSPredicate *sSummaryPredicate;
static NSPredicate *sExpansionPredicate;
static NSPredicate *sSourcePredicate;
static NSPredicate *sURLPredicate;
static NSPredicate *sAdviceSourcePredicate;

@implementation BibBibliographicSummary

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSummaryPredicate = [NSPredicate predicateWithFormat:@"code = 'a'"];
        sExpansionPredicate = [NSPredicate predicateWithFormat:@"code = 'b'"];
        sSourcePredicate = [NSPredicate predicateWithFormat:@"code = 'c'"];
        sURLPredicate = [NSPredicate predicateWithFormat:@"code = 'u'"];
        sAdviceSourcePredicate = [NSPredicate predicateWithFormat:@"code = '2'"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _kind = [[indicators firstObject] characterAtIndex:0];
        _content = [[[[subfields filteredArrayUsingPredicate:sSummaryPredicate] firstObject] content] copy];
        _detail = [[[[subfields filteredArrayUsingPredicate:sExpansionPredicate] firstObject] content] copy];
        _source = [[[[subfields filteredArrayUsingPredicate:sSourcePredicate] firstObject] content] copy];
        _urls = ({
            NSArray *urlStrings = [[subfields filteredArrayUsingPredicate:sURLPredicate] valueForKey:@"content"];
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:[urlStrings count]];
            for (NSString *string in urlStrings) {
                [urls addObject:[NSURL URLWithString:string]];
            }
            [urls copy];
        });
        _adviceClassificationSystem = ({
            [[[[subfields filteredArrayUsingPredicate:sAdviceSourcePredicate] firstObject] content] copy];
        });
        if (_content == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
    }
    return self;
}

@end
