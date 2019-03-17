//
//  BibBibliographicISBN.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicISBNKind) {
    BibBibliographicISBNKindISBN10 NS_SWIFT_NAME(isbn10),
    BibBibliographicISBNKindISBN13 NS_SWIFT_NAME(isbn13)
} NS_SWIFT_NAME(BibliographicISBN.Kind);

/// http://www.loc.gov/marc/bibliographic/bd020.html
NS_SWIFT_NAME(BibliographicISBN)
@interface BibBibliographicISBN : BibRecordDataField

@property (nonatomic, copy, readonly) NSString *stringValue;

@property (nonatomic, assign, readonly) BibBibliographicISBNKind kind;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
