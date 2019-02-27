//
//  BibDeweyDecimalClassificationNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibClassificationNumber.h"
#import "BibRecordConstants.h"

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/bibliographic/bd082.html
NS_SWIFT_NAME(DeweyDecimalClassificationNumber)
@interface BibDeweyDecimalClassificationNumber : NSObject <BibClassificationNumber>

@property (nonatomic, assign, readonly) BibEditionKind editionKind;

@property (nonatomic, copy, readonly, nullable) NSString *scheduleEdition;

@property (nonatomic, copy, readonly, nullable) BibMarcOrganization assigningAgency;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields;

- (instancetype)initWithClassificationNumber:(NSString *)classificationNumber
                                  itemNumber:(nullable NSString *)itemNumber
                          alternativeNumbers:(nullable NSArray<NSString *> *)alternativeNumbers
                             scheduleEdition:(NSString *)scheduleEdition
                                 editionKind:(BibEditionKind)editionKind
                             assigningAgency:(nullable BibMarcOrganization)assigningAgency
                  libraryOfCongressOwnership:(BibLibraryOfCongressOwnership)libraryOfCongressOwnership NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
