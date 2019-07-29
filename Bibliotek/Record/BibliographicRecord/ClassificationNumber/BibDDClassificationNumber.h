//
//  BibDDClassificationNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibClassificationNumber.h"

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/organizations/orgshome.html
typedef NSString *BibMarcOrganization NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(MarcOrganization);

/// http://www.loc.gov/marc/bibliographic/bd082.html
NS_SWIFT_NAME(DDCCallNumber)
@interface BibDDClassificationNumber : NSObject <BibClassificationNumber, NSCopying, NSMutableCopying>

@property (nonatomic, copy, readonly, nullable) NSString *scheduleEdition;

@property (nonatomic, copy, readonly, nullable) BibMarcOrganization assigningAgency;

- (instancetype)initWithClassification:(NSString *)classification
                                  item:(nullable NSString *)item NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Mutable

@interface BibMutableDDClassificationNumber : BibDDClassificationNumber <BibMutableClassificationNumber>

@property (nonatomic, copy, readwrite, nullable) NSString *scheduleEdition;

@property (nonatomic, copy, readwrite, nullable) BibMarcOrganization assigningAgency;

@end

NS_ASSUME_NONNULL_END
