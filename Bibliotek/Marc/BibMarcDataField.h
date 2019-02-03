//
//  BibMarcDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcTag;
@class BibMarcRecordFieldIndicator;
@class BibMarcRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// \brief A data field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(MarcDataField)
@interface BibMarcDataField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, strong, readonly) BibMarcTag *tag;
@property (nonatomic, strong, readonly) BibMarcRecordFieldIndicator *firstIndicator;
@property (nonatomic, strong, readonly) BibMarcRecordFieldIndicator *secondIndicator;
@property (nonatomic, copy, readonly) NSArray<BibMarcRecordSubfield *> *subfields;

- (nullable instancetype)initWithTag:(BibMarcTag *)tag
                      firstIndicator:(BibMarcRecordFieldIndicator *)firstIndicator
                     secondIndicator:(BibMarcRecordFieldIndicator *)secondIndicator
                           subfields:(NSArray<BibMarcRecordSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibMarcDataField *)other;

@end

NS_SWIFT_NAME(MarcMutableDataField)
@interface BibMarcMutableDataField : BibMarcDataField

@property (nonatomic, strong, readwrite) BibMarcTag *tag;
@property (nonatomic, strong, readwrite) BibMarcRecordFieldIndicator *firstIndicator;
@property (nonatomic, strong, readwrite) BibMarcRecordFieldIndicator *secondIndicator;
@property (nonatomic, copy, readwrite) NSArray<BibMarcRecordSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
