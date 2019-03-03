//
//  BibDDClassificationCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibClassificationCallNumber.h"
#import "BibRecordField.h"

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/bibliographic/bd082.html
NS_SWIFT_NAME(DDClassificationCallNumber)
@interface BibDDClassificationCallNumber : BibRecordDataField <BibClassificationCallNumber>

@property (nonatomic, assign, readonly) BibEditionKind editionKind;

@property (nonatomic, copy, readonly, nullable) NSString *scheduleEdition;

@property (nonatomic, copy, readonly, nullable) BibMarcOrganization assigningAgency;

@end

NS_ASSUME_NONNULL_END
