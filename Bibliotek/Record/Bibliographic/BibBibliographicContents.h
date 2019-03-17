//
//  BibBibliographicContents.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicContentsKind) {
    BibBibliographicContentsKindContents = '0',
    BibBibliographicContentsKindIncomplete = '1',
    BibBibliographicContentsKindPartial = '2',
    BibBibliographicContentsKindOther = '8'
} NS_SWIFT_NAME(BibliographicContents.Kind);

typedef NS_ENUM(NSUInteger, BibBibliographicContentsLevel) {
    BibBibliographicContentsLevelBasic = ' ',
    BibBibliographicContentsLevelEnhanced = '0'
} NS_SWIFT_NAME(BibliographicContents.Level);

/// http://www.loc.gov/marc/bibliographic/bd505.html
NS_SWIFT_NAME(BibliographicContents)
@interface BibBibliographicContents : BibRecordDataField

@property (nonatomic, assign, readonly) BibBibliographicContentsKind kind;

@property (nonatomic, assign, readonly) BibBibliographicContentsLevel level;

@property (nonatomic, copy, readonly) NSString *note;

@property (nonatomic, copy, readonly) NSArray<NSURL *> *urls;

@property (nonatomic, copy, readonly) NSArray<NSString *> *contents;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
