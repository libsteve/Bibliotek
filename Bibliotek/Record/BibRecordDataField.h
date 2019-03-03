//
//  BibRecordDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordField.h"

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// \brief A data field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record.DataField)
@interface BibRecordDataField : NSObject <BibRecordField>

@property (nonatomic, copy, readonly) NSArray<BibRecordFieldIndicator> *indicators;

@property (nonatomic, copy, readonly) NSArray<BibRecordSubfield *> *subfields;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields;

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField;

@end

NS_ASSUME_NONNULL_END
