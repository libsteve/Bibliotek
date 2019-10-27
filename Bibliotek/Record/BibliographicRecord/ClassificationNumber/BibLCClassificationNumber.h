//
//  BibLCClassificationNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibClassificationNumber.h"

@class BibContentField;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibLibraryOfCongressOwnership) {
    BibLibraryOfCongressOwnershipUnknown = ' ',
    BibLibraryOfCongressOwnershipOwned = '0',
    BibLibraryOfCongressOwnershipUnowned = '1'
} NS_SWIFT_NAME(LibraryOfCongressOwnership);

/// http://www.loc.gov/marc/bibliographic/bd050.html
NS_SWIFT_NAME(LCClassificationNumber)
@interface BibLCClassificationNumber : NSObject <BibClassificationNumber, NSCopying, NSMutableCopying>

@property (nonatomic, assign, readonly) BibLibraryOfCongressOwnership libraryOfCongressOwnership;

- (instancetype)initWithClassification:(NSString *)classification item:(nullable NSString *)item;

@end

@interface BibLCClassificationNumber (Equality)

- (BOOL)isEqualToLCClassificationNumber:(BibLCClassificationNumber *)classificationNumber;

@end

#pragma mark - Mutable

@interface BibMutableLCClassificationNumber : BibLCClassificationNumber <BibMutableClassificationNumber>

@property (nonatomic, assign, readwrite) BibLibraryOfCongressOwnership libraryOfCongressOwnership;

@end

NS_ASSUME_NONNULL_END
