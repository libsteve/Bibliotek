//
//  BibBibliographicEditionStatement.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicEditionStatement.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"250";

static NSPredicate *sStatementPredicate;
static NSPredicate *sDetailPredicate;

@implementation BibBibliographicEditionStatement

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sStatementPredicate = [NSPredicate predicateWithFormat:@"code = 'a'"];
        sDetailPredicate = [NSPredicate predicateWithFormat:@"code = 'b'"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _content = [[[[subfields filteredArrayUsingPredicate:sStatementPredicate] firstObject] content] copy];
        _detail = [[[[subfields filteredArrayUsingPredicate:sDetailPredicate] firstObject] content] copy];
        if (_content == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
    }
    return self;
}

- (NSString *)description {
    if (_detail) {
        return [@[ _content, _detail ] componentsJoinedByString:@" "];
    }
    return _content;
}

@end
