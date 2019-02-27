//
//  BibClassificationNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibLibraryOfCongressOwnership) {
    BibLibraryOfCongressOwnershipUnknown = ' ',
    BibLibraryOfCongressOwnershipOwned = '0',
    BibLibraryOfCongressOwnershipUnowned = '1'
} NS_SWIFT_NAME(LibraryOfCongressOwnership);

NS_SWIFT_NAME(ClassificationNumber)
@protocol BibClassificationNumber <NSObject>

@property (nonatomic, copy, readonly) NSString *classificationNumber;

@property (nonatomic, copy, readonly, nullable) NSString *itemNumber;

@property (nonatomic, copy, readonly) NSArray<NSString *> *alternativeNumbers;

@property (nonatomic, assign, readonly) BibLibraryOfCongressOwnership libraryOfCongressOwnership;

@property (class, nonatomic, strong, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
