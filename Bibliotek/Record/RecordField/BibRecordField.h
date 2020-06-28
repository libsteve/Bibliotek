//
//  BibRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/31/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibFieldIndicator;
@class BibFieldTag;
@class BibSubfield;

NS_ASSUME_NONNULL_BEGIN

/// A set of information and/or metadata about the item represented by a MARC record.
///
/// The semantic meaning of a record field is indicated by its \c fieldTag value.
/// A control field contains information and metadata about how a record's content should be processed.
///
/// The semantic meaning of a data field is indicated by its \c fieldTag value, and its indicators are used as flags
/// that determine how the data in its subfields should be interpreted or displayed.
///
/// Data fields are composed of \c subfields, which are portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
@interface BibRecordField : NSObject <NSCopying, NSMutableCopying>

/// A value indicating the semantic purpose of the record field.
@property (nonatomic, readonly, strong) BibFieldTag *fieldTag;

/// The information contained within the control field.
///
/// \note This value is \c nil for data fields.
/// \note This value is never \c nil for control fields.
///       Setting it to \c nil will change its value to the empty string.
@property (nonatomic, readonly, copy, nullable) NSString *controlValue;

/// The first metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// \note This value is \c nil for control fields.
/// \note This value is never \c nil for data fields.
///       Setting it to \c nil will change its value to the blank indicator.
@property (nonatomic, readonly, copy, nullable) BibFieldIndicator *firstIndicator;

/// The second metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// \note This value is \c nil for control fields.
/// \note This value is never \c nil for data fields.
///       Setting it to \c nil will change its value to the blank indicator.
@property (nonatomic, readonly, copy, nullable) BibFieldIndicator *secondIndicator;

/// An ordered list of subfields containing portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// \note This value is \c nil for control fields.
/// \note This value is never \c nil for data fields.
///       Setting it to \c nil will change its value to an empty array.
@property (nonatomic, readonly, copy, nullable) NSArray<BibSubfield *> *subfields;

/// This object is a control field containing a control value.
@property (nonatomic, readonly) BOOL isControlField;

/// This object is a data field with contnet indicators and subfield data.
@property (nonatomic, readonly) BOOL isDataField;

/// Create an empty record field with the given record field tag.
/// \param fieldTag The field tag identifying the semantic purpose for the new record field.
/// \returns An empty record field object.
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag NS_DESIGNATED_INITIALIZER;

/// Create an empty record field with the given record field tag.
/// \param fieldTag The field tag identifying the semantic purpose for the new record field.
/// \param controlValue The control value for the field.
/// \returns An control field object.
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag controlValue:(NSString *)controlValue;

/// Create an empty record field with the given record field tag.
/// \param fieldTag The field tag identifying the semantic purpose for the new record field.
/// \param firstIndicator The first indicator value for a data field.
/// \param secondIndicator The second indicator value for a data field.
/// \param subfields A list of subfields for a data field.
/// \returns A data field object.
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag
                  firstIndicator:(BibFieldIndicator *)firstIndicator
                 secondIndicator:(BibFieldIndicator *)secondIndicator
                       subfields:(NSArray<BibSubfield *> *)subfields;

@end

@interface BibRecordField (SubfieldAccess)

@property (nonatomic, readonly) NSUInteger subfieldCount;

- (BibSubfield *)subfieldAtIndex:(NSUInteger)index;
- (BibSubfield *)objectAtIndexedSubscript:(NSUInteger)index;

@end

@interface BibRecordField (Equality)

/// Determine whether or not the given record field represents the same data as the receiver.
///
/// \param recordField The record field with which the receiver should be compared.
/// \returns Returns \c YES if the given record field and the receiver have the same field tag and semantic value.
- (BOOL)isEqualToRecordField:(BibRecordField *)recordField;

@end

@interface BibRecordField (Serialization) <NSSecureCoding>
@end

#pragma mark - Mutable

@interface BibMutableRecordField : BibRecordField

/// A value indicating the semantic purpose of the record field.
@property (nonatomic, readwrite, strong) BibFieldTag *fieldTag;

/// The information contained within the control field.
///
/// \note This value is \c nil for data fields.
/// \note This value is never \c nil for control fields.
///       Setting it to \c nil will change its value to the empty string.
@property (nonatomic, readwrite, copy, nullable) NSString *controlValue;

/// The first metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// \note This value is \c nil for control fields.
/// \note This value is never \c nil for data fields.
///       Setting it to \c nil will change its value to the blank indicator.
@property (nonatomic, readwrite, copy, nullable) BibFieldIndicator *firstIndicator;

/// The second metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// \note This value is \c nil for control fields.
/// \note This value is never \c nil for data fields.
///       Setting it to \c nil will change its value to the blank indicator.
@property (nonatomic, readwrite, copy, nullable) BibFieldIndicator *secondIndicator;

/// An ordered list of subfields containing portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// \note This value is \c nil for control fields.
/// \note This value is never \c nil for data fields.
///       Setting it to \c nil will change its value to an empty array.
@property (nonatomic, readwrite, copy, nullable) NSArray<BibSubfield *> *subfields;

@end

@interface BibMutableRecordField (SubfieldAccess)

- (void)addSubfield:(BibSubfield *)subfield;
- (void)removeSubfield:(BibSubfield *)subfield;
- (void)insertSubfield:(BibSubfield *)subfield atIndex:(NSUInteger)index;
- (void)replaceSubfieldAtIndex:(NSUInteger)index withSubfield:(BibSubfield *)subfield;

- (void)setSubfield:(BibSubfield *)subfield atIndex:(NSUInteger)index;
- (void)setObject:(BibSubfield *)subfield atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
