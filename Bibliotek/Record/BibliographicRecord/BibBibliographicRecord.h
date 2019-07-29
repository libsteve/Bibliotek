//
//  BibBibliographicRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibISBN;
@class BibDDCCallNumber;
@class BibLCCCallNumber;
@class BibContentDescription;
@class BibItemDescription;
@class BibTitleStatement;

NS_ASSUME_NONNULL_BEGIN

@interface BibBibliographicRecord : NSObject

@property (nonatomic, copy, readonly) NSArray<BibISBN *> *isbns;

@property (nonatomic, copy, readonly) NSArray<BibDDCCallNumber *> *ddcCallNumbers;

@property (nonatomic, copy, readonly) NSArray<BibLCCCallNumber *> *lccCallNumbers;

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly, nullable) NSString *author;

@property (nonatomic, copy, readonly) BibTitleStatement *titleStatement;

@property (nonatomic, copy, readonly) NSArray<BibItemDescription *> *descriptions;

@property (nonatomic, copy, readonly, nullable) BibContentDescription *contentDescription;

@end

NS_ASSUME_NONNULL_END
