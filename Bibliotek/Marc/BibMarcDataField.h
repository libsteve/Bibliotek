//
//  BibMarcDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcIndicator;
@class BibMarcSubfield;
@class BibMarcTag;

NS_ASSUME_NONNULL_BEGIN

/// \brief A data field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(MarcDataField)
@interface BibMarcDataField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, strong, readonly) BibMarcTag *tag;
@property (nonatomic, strong, readonly) BibMarcIndicator *firstIndicator;
@property (nonatomic, strong, readonly) BibMarcIndicator *secondIndicator;
@property (nonatomic, copy, readonly) NSArray<BibMarcSubfield *> *subfields;

- (nullable instancetype)initWithTag:(BibMarcTag *)tag
                      firstIndicator:(BibMarcIndicator *)firstIndicator
                     secondIndicator:(BibMarcIndicator *)secondIndicator
                           subfields:(NSArray<BibMarcSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibMarcDataField *)other;

@end

NS_SWIFT_NAME(MarcMutableDataField)
@interface BibMarcMutableDataField : BibMarcDataField

@property (nonatomic, strong, readwrite) BibMarcTag *tag;
@property (nonatomic, strong, readwrite) BibMarcIndicator *firstIndicator;
@property (nonatomic, strong, readwrite) BibMarcIndicator *secondIndicator;
@property (nonatomic, copy, readwrite) NSArray<BibMarcSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
