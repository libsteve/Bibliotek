//
//  BibClassificationCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibLibraryOfCongressOwnership) {
    BibLibraryOfCongressOwnershipUnknown = ' ',
    BibLibraryOfCongressOwnershipOwned = '0',
    BibLibraryOfCongressOwnershipUnowned = '1'
} NS_SWIFT_NAME(LibraryOfCongressOwnership);

NS_SWIFT_NAME(ClassificationNumber)
@protocol BibClassificationNumber <NSObject>

@property (nonatomic, copy, readonly) NSString *classification;

@property (nonatomic, copy, readonly, nullable) NSString *item;

@property (nonatomic, copy, readonly) NSArray<NSString *> *alternatives;

@property (nonatomic, assign, readonly) BibLibraryOfCongressOwnership libraryOfCongressOwnership;

@end

NS_SWIFT_NAME(MutableClassificationNumber)
@protocol BibMutableClassificationNumber <BibClassificationNumber>

@property (nonatomic, copy, readwrite) NSString *classification;

@property (nonatomic, copy, readwrite, nullable) NSString *item;

@property (nonatomic, copy, readwrite) NSArray<NSString *> *alternatives;

@property (nonatomic, assign, readwrite) BibLibraryOfCongressOwnership libraryOfCongressOwnership;

@end

NS_ASSUME_NONNULL_END
