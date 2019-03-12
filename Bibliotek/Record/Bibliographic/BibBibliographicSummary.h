//
//  BibBibliographicSummary.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/12/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicSummaryKind) {
    BibBibliographicSummaryKindSummary = ' ',
    BibBibliographicSummaryKindSubject = '0',
    BibBibliographicSummaryKindReview = '1',
    BibBibliographicSummaryKindScopeAndContent = '2',
    BibBibliographicSummaryKindAbstract = '3',
    BibBibliographicSummaryKindContentAdvice = '4',
    BibBibliographicSummaryKindNone = '8'
} NS_SWIFT_NAME(BibliographicSummary.Kind);

/// http://www.loc.gov/marc/bibliographic/bd520.html
NS_SWIFT_NAME(BibliographicSummary)
@interface BibBibliographicSummary : BibRecordDataField

@property (nonatomic, assign, readonly) BibBibliographicSummaryKind kind;

@property (nonatomic, copy, readonly) NSString *content;

@property (nonatomic, copy, readonly, nullable) NSString *detail;

@property (nonatomic, copy, readonly, nullable) NSString *source;

@property (nonatomic, copy, readonly) NSArray<NSURL *> *urls;

@property (nonatomic, copy, readonly, nullable) NSString *adviceClassificationSystem;

@property (class, nonatomic, strong, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
