//
//  BibGenericRecordDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
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
NS_SWIFT_NAME(Record.GenericDataField)
@interface BibGenericRecordDataField : BibRecordDataField

- (instancetype)initWithData:(NSData *)data NS_UNAVAILABLE;

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray *)subfields NS_UNAVAILABLE;

- (instancetype)initWithTag:(BibRecordFieldTag)tag data:(NSData *)data NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTag:(BibRecordFieldTag)tag
                 indicators:(NSArray<BibRecordFieldIndicator> *)indicators
                  subfields:(NSArray<BibRecordSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
