//
//  BibBibliographicPublication.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicPublication.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"260";

static NSPredicate *sStatementPredicate;

@implementation BibBibliographicPublication

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sStatementPredicate = [NSPredicate predicateWithFormat:@"code IN { '3', 'a', 'b', 'c', 'e', 'f', 'g' }"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _statement = [[[subfields filteredArrayUsingPredicate:sStatementPredicate] valueForKey:@"content"]
                            componentsJoinedByString:@" "];
        if ([_statement isEqualToString:@""]) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a, $b, or $c not found"];
        }
    }
    return self;
}

- (NSString *)description {
    return _statement;
}

@end
