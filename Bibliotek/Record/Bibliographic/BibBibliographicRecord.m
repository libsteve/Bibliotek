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
#import "BibBibliographicPersonalName.h"
#import "BibBibliographicSummary.h"
#import "BibSubjectHeading.h"
#import "BibTopicalSubjectHeading.h"
#import "BibBibliographicContents.h"
#import "BibRecordDirectoryEntry.h"

static NSPredicate *sLCCCallNumberPredicate;
static NSPredicate *sDDCCallNumberPredicate;
static NSPredicate *sCallNumberPredicate;
static NSPredicate *sTitleStatementPredicate;
static NSPredicate *sAuthorPredicate;
static NSPredicate *sSubjectHeadingPredicate;
static NSPredicate *sSummaryPredicate;
static NSPredicate *sContentsPredicate;

@implementation BibBibliographicRecord

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BibRecordFieldTag const lccCallNumberTag = [BibLCClassificationCallNumber recordFieldTag];
        sLCCCallNumberPredicate = [NSPredicate predicateWithFormat:@"tag = %@", lccCallNumberTag];
        BibRecordFieldTag const ddcCallNumberTag = [BibDDClassificationCallNumber recordFieldTag];
        sDDCCallNumberPredicate = [NSPredicate predicateWithFormat:@"tag = %@", ddcCallNumberTag];
        sCallNumberPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[ sLCCCallNumberPredicate,
                                                                                    sDDCCallNumberPredicate ]];
        BibRecordFieldTag const titleStatementTag = [BibBibliographicTitleStatement recordFieldTag];
        sTitleStatementPredicate = [NSPredicate predicateWithFormat:@"tag = %@", titleStatementTag];
        BibRecordFieldTag const authorTag = [BibBibliographicPersonalName recordFieldTag];
        sAuthorPredicate = [NSPredicate predicateWithFormat:@"tag = %@", authorTag];
        BibRecordFieldTag const topicalSubjectTag = [BibTopicalSubjectHeading recordFieldTag];
        sSubjectHeadingPredicate = [NSPredicate predicateWithFormat:@"tag = %@", topicalSubjectTag];
        sSummaryPredicate = [NSPredicate predicateWithFormat:@"tag = %@", [BibBibliographicSummary recordFieldTag]];
        BibRecordFieldTag const formattedContentsTag = [BibBibliographicContents recordFieldTag];
        sContentsPredicate = [NSPredicate predicateWithFormat:@"tag = %@", formattedContentsTag];
    });
}

+ (NSDictionary<BibRecordFieldTag,Class> *)recordSchema {
    static NSDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = @{ [BibLCClassificationCallNumber recordFieldTag] : [BibLCClassificationCallNumber class],
                        [BibDDClassificationCallNumber recordFieldTag] : [BibDDClassificationCallNumber class],
                        [BibBibliographicTitleStatement recordFieldTag] : [BibBibliographicTitleStatement class],
                        [BibBibliographicPersonalName recordFieldTag] : [BibBibliographicPersonalName class],
                        [BibTopicalSubjectHeading recordFieldTag] : [BibTopicalSubjectHeading class],
                        [BibBibliographicSummary recordFieldTag] : [BibBibliographicSummary class],
                        [BibBibliographicContents recordFieldTag] : [BibBibliographicContents class] };
    });
    return dictionary;
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                        fields:(NSArray<id<BibRecordField>> *)fields {
    if (self = [super initWithLeader:leader directory:directory fields:fields]) {
        _lccCallNumbers = (id)[fields filteredArrayUsingPredicate:sLCCCallNumberPredicate];
        _ddcCallNumbers = (id)[fields filteredArrayUsingPredicate:sDDCCallNumberPredicate];
        _callNumbers = (id)[fields filteredArrayUsingPredicate:sCallNumberPredicate];
        _titleStatement = (id)[[fields filteredArrayUsingPredicate:sTitleStatementPredicate] firstObject];
        _author = (id)[[fields filteredArrayUsingPredicate:sAuthorPredicate] firstObject];
        _subjectHeadings = (id)[fields filteredArrayUsingPredicate:sSubjectHeadingPredicate];
        _summaries = (id)[fields filteredArrayUsingPredicate:sSummaryPredicate];
        _contents = (id)[fields filteredArrayUsingPredicate:sContentsPredicate];
    }
    return self;
}

- (NSString *)description {
    NSMutableArray *content = [NSMutableArray array];
    [content addObjectsFromArray:_callNumbers];
    [content addObjectsFromArray:@[_titleStatement, _author]];
    [content addObjectsFromArray:_summaries];
    [content addObjectsFromArray:_subjectHeadings];
    [content addObjectsFromArray:_contents];
    return [content componentsJoinedByString:@"\n"];
}

@end
