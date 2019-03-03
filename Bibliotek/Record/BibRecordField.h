//
//  BibRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RecordField)
@protocol BibRecordField <NSObject>

/// A three-digit code used to identify this control field's semantic purpose.
@property (nonatomic, readonly) BibRecordFieldTag tag;

- (instancetype)initWithData:(NSData *)data;

@end

/// \brief A control field contains information and metadata pertaining to the processing of a record's data.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record.ControlField)
@interface BibRecordControlField : NSObject <BibRecordField>

- (instancetype)initWithContent:(NSString *)content;

/// Determine whether or not the given control field represents the same data as the receiver.
/// \param controlField The control field with which the receiver should be compared.
/// \returns Returns \c YES if the given control field and the receiver have the same tag and content data.
- (BOOL)isEqualToControlField:(BibRecordControlField *)controlField;

@end

/// \brief A data field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record.DataField)
@interface BibRecordDataField : NSObject <BibRecordField>

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields;

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField;

@end

NS_ASSUME_NONNULL_END
