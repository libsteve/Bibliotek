//
//  BibLibraryOfCongressClassificationNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibClassificationNumber.h"

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibLibraryOfCongressClassificationNumberSource) {
    BibLibraryOfCongressClassificationNumberSourceUnknown = ' ',
    BibLibraryOfCongressClassificationNumberSourceLibraryOfCongress = '0',
    BibLibraryOfCongressClassificationNumberSourceOther = '4'
} NS_SWIFT_NAME(LibraryOfCongressClassificationNumber.Source);

/// http://www.loc.gov/marc/bibliographic/bd050.html
NS_SWIFT_NAME(LibraryOfCongressClassificationNumber)
@interface BibLibraryOfCongressClassificationNumber : NSObject <BibClassificationNumber>

@property (nonatomic, assign, readonly) BibLibraryOfCongressClassificationNumberSource source;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields;

- (instancetype)initWithClassificationNumber:(NSString *)classificationNumber
                                  itemNumber:(nullable NSString *)itemNumber
                          alternativeNumbers:(nullable NSArray<NSString *> *)alternativeNumbers
                  libraryOfCongressOwnership:(BibLibraryOfCongressOwnership)libraryOfCongressOwnership
                                      source:(BibLibraryOfCongressClassificationNumberSource)source NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
