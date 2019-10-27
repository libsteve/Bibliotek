//
//  BibBibliographicRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibISBN;
@class BibDDClassificationNumber;
@class BibLCClassificationNumber;

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

@interface BibBibliographicRecord : NSObject

@property (nonatomic, copy, readonly) NSArray<BibISBN *> *isbns;

@property (nonatomic, copy, readonly) NSArray<BibDDClassificationNumber *> *ddClassificationNumbers;

@property (nonatomic, copy, readonly) NSArray<BibLCClassificationNumber *> *lcClassificationNumbers;

- (nullable instancetype)initWithRecord:(BibRecord *)record;

@end

NS_ASSUME_NONNULL_END
