//
//  BibBibliographicRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicRecord.h"
#import "BibClassificationCallNumber.h"
#import "BibLCClassificationCallNumber.h"
#import "BibDDClassificationCallNumber.h"
#import "BibBibliographicTitleStatement.h"
#import "BibRecordDirectoryEntry.h"

static NSPredicate *sLCCCallNumberPredicate;
static NSPredicate *sDDCCallNumberPredicate;
static NSPredicate *sTitleStatementPredicate;

@implementation BibBibliographicRecord

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BibRecordFieldTag const lccCallNumberTag = [BibLCClassificationCallNumber recordFieldTag];
        sLCCCallNumberPredicate = [NSPredicate predicateWithFormat:@"tag = '%@'", lccCallNumberTag];
        BibRecordFieldTag const ddcCallNumberTag = [BibDDClassificationCallNumber recordFieldTag];
        sDDCCallNumberPredicate = [NSPredicate predicateWithFormat:@"tag = '%@'", ddcCallNumberTag];
        BibRecordFieldTag const titleStatementTag = [BibBibliographicTitleStatement recordFieldTag];
        sTitleStatementPredicate = [NSPredicate predicateWithFormat:@"tag = '%@'", titleStatementTag];
    });
}

+ (NSDictionary<BibRecordFieldTag,Class> *)recordSchema {
    static NSDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = @{ [BibLCClassificationCallNumber recordFieldTag] : [BibLCClassificationCallNumber class],
                        [BibDDClassificationCallNumber recordFieldTag] : [BibDDClassificationCallNumber class],
                        [BibBibliographicTitleStatement recordFieldTag] : [BibBibliographicTitleStatement class] };
    });
    return dictionary;
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                        fields:(NSArray<id<BibRecordField>> *)fields {
    if (self = [super initWithLeader:leader directory:directory fields:fields]) {
        _lccCallNumbers = (id)[fields filteredArrayUsingPredicate:sLCCCallNumberPredicate];
        _ddcCallNumbers = (id)[fields filteredArrayUsingPredicate:sDDCCallNumberPredicate];
        _titleStatement = (id)[[fields filteredArrayUsingPredicate:sTitleStatementPredicate] firstObject];
    }
    return self;
}

@end
