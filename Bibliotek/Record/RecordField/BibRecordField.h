//
//  BibRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/31/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibSubfield.h>
#import <Bibliotek/BibAttributes.h>

@class BibFieldIndicator;
@class BibFieldTag;
@class BibSubfield;

NS_ASSUME_NONNULL_BEGIN

#pragma mark Record Field

/// A set of information and/or metadata about the item represented by a MARC record.
///
/// The semantic meaning of a record field is indicated by its ``BibRecordField/fieldTag`` value.
///
/// Control fields contain information and metadata about how a record's content should be processed.
///
/// Data fields are composed of ``BibRecordField/subfields``, which are portions of data semantically identified by
/// their ``BibSubfield/subfieldCode``. The interpretation of data within a content field is often determined by its
/// indicators and the formatting of its subfields' contents. For example, a bibliographic record's title statement,
/// identified with the tag `245`, formats its content using ISBD principles and uses subfield codes to semantically
/// tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page: [International Standard Bibliographic Description][isbd].
///
/// The ISBD punctuation standard can be found in section A3 in [the consolidated technical specification][spec].
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// [MARC 21 Record Structure][marc].
///
/// [isbd]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
/// [spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
/// [marc]: https://www.loc.gov/marc/specifications/specrecstruc.html
BIB_SWIFT_BRIDGE(RecordField)
@interface BibRecordField : NSObject <NSCopying, NSMutableCopying>

/// A value indicating the semantic purpose of the record field.
@property (nonatomic, readonly, copy) BibFieldTag *fieldTag;

/// The information contained within the control field.
///
/// This value is `nil` for data fields.
///
/// However, this value is never `nil` for control fields.
/// Setting it to `nil` will change its value to the empty string.
@property (nonatomic, readonly, copy, nullable) NSString *controlValue;

/// The first metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// - note: This value is `nil` for control fields.
/// - note: This value is never `nil` for data fields.
///         Setting it to `nil` will change its value to the blank indicator.
@property (nonatomic, readonly, copy, nullable) BibFieldIndicator *firstIndicator;

/// The second metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// - note: This value is `nil` for control fields.
/// - note: This value is never `nil` for data fields.
///         Setting it to `nil` will change its value to the blank indicator.
@property (nonatomic, readonly, copy, nullable) BibFieldIndicator *secondIndicator;

/// An ordered list of subfields containing portions of data semantically identified by their ``BibSubfield/subfieldCode``.
///
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag `245`,formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page: [International Standard Bibliographic Description][isbd].
///
/// The ISBD punctuation standard can be found in section A3 in [the consolidated technical specification][spec].
///
/// - note: This value is `nil` for control fields.
/// - note: This value is never `nil` for data fields.
///         Setting it to `nil` will change its value to an empty array.
///
/// [isbd]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
/// [spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
@property (nonatomic, readonly, copy, nullable) NSArray<BibSubfield *> *subfields;

/// This object is a control field containing a control value.
@property (nonatomic, readonly) BOOL isControlField;

/// This object is a data field with content indicators and subfield data.
@property (nonatomic, readonly) BOOL isDataField;

/// Create a record field with the given record field tag.
/// - parameter fieldTag: The field tag identifying the semantic purpose for the new record field.
/// - returns: An empty record field object.
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag NS_DESIGNATED_INITIALIZER;

/// Create a record field with the given control field tag.
/// - parameter fieldTag: The field tag identifying the semantic purpose for the new record field.
/// - parameter controlValue: The control value for the field.
/// - returns: An control field object.
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag controlValue:(NSString *)controlValue NS_DESIGNATED_INITIALIZER;

/// Create a record field with the given data field tag.
/// - parameter fieldTag: The field tag identifying the semantic purpose for the new record field.
/// - parameter firstIndicator: The first indicator value for a data field.
/// - parameter secondIndicator: The second indicator value for a data field.
/// - parameter subfields: A list of subfields for a data field.
/// - returns: A data field object.
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag
                  firstIndicator:(BibFieldIndicator *)firstIndicator
                 secondIndicator:(BibFieldIndicator *)secondIndicator
                       subfields:(NSArray<BibSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

@end

@interface BibRecordField (SubfieldAccess)

/// The total amount of subfields contained in this data field.
/// - note: This values is always `0` for control fields.
@property (nonatomic, readonly) NSUInteger subfieldCount;

/// Get this data field's subfield at the given index.
/// - parameter index: The index of the subfield to access.
/// - returns: This data field's subfield located at the given index.
/// - note: This method will throw an `NSSRangeException` for control fields.
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index;

/// Use indexed subscripting syntax to access a subfield from this data field.
/// - parameter index: The index of the subfield to access.
/// - returns: This data field's subfield located at the given index.
/// - note: This method will throw an `NSSRangeException` for control fields.
- (BibSubfield *)objectAtIndexedSubscript:(NSUInteger)index;

/// Get the first subfield marked with the given code.
/// - parameter subfieldCode: The subfield code that the resulting subfield should have.
/// - returns: The first subfield in this data field with the given subfield code.
///            `nil` is returned if there is no such matching subfield.
/// - note: This method always returns `nil` for control fields.
- (nullable BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(subfield(with:));

/// Get the first subfield marked with the given code within a specified range.
/// - parameter subfieldCode: The subfield code that the resulting subfield should have.
/// - parameter range: The range of indexes to search within for the subfield with the given code.
/// - returns: The first subfield in this data field with the given subfield code.
///            `nil` is returned if there is no such matching subfield.
/// - note: This method always returns `nil` for control fields.
- (nullable BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode inRange:(NSRange)range NS_SWIFT_NAME(subfield(with:in:));

/// Get all subfields marked with the given code.
/// - parameter subfieldCode: The subfield code that the resulting subfields should have.
/// - returns: An array of all subfields with the given subfield code.
///            An empty array is returned when no subfields with the given code are found.
/// - note: This method always returns an empty array for control fields.
- (NSArray<BibSubfield *> *)subfieldsWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(subfields(with:));

/// Get the index of the first subfield marked with the given code.
/// - parameter subfieldCode: The subfield code that the matching subfield should have.
/// - returns: The index of the first subfield in this data field with the given subfield code.
///            `NSNotFound` is returned if there is no such matching subfield.
/// - note: This method always returns `NSNotFound` for control fields.
- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(indexOfSubfield(with:));

/// Get the index of the first subfield marked with the given code within a specified range.
/// - parameter subfieldCode: The subfield code that the matching subfield should have.
/// - parameter range: The range of indexes to search within for the subfield with the given code.
/// - returns: The index of the first occurrence of a subfield with the given code.
///            `NSNotFound` is returned if there is no such matching subfield.
/// - note: This method always returns `NSNotFound` for control fields.
- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode inRange:(NSRange)range NS_SWIFT_NAME(indexOfSubfield(with:in:));

/// The indexes of all subfields marked with the given code.
/// - parameter subfieldCode: The subfield code that the matching subfields should have.
/// - returns: An index set of all indexes of subfields with the given subfield code.
///            An empty set is returned if there are no such matching subfields.
/// - note: This method always returns the empty set for control fields.
- (NSIndexSet *)indexesOfSubfieldsWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(indexesOfSubfields(with:));

/// Check to see if this data field has a subfield marked with the given code.
/// - parameter subfieldCode: The subfield code used to check the presence of any relevant subfields.
/// - returns: `YES` when this data field contains a subfield marked with the given code.
///            `NO` is returned when no such subfield is found.
/// - note: This method always returns `NO` for control fields.
- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(containsSubfield(with:));

@end

@interface BibRecordField (Equality)

/// Determine whether or not the given record field represents the same data as the receiver.
///
/// - parameter recordField: The record field with which the receiver should be compared.
/// - returns: Returns `YES` if the given record field and the receiver have the same field tag and semantic value.
- (BOOL)isEqualToRecordField:(BibRecordField *)recordField;

@end

@interface BibRecordField (Serialization) <NSSecureCoding>
@end

#pragma mark - Mutable Record Field

/// A mutable set of information and/or metadata about the item represented by a MARC record.
///
/// The semantic meaning of a record field is indicated by its ``BibRecordField/fieldTag`` value.
///
/// Control fields contain information and metadata about how a record's content should be processed.
///
/// Data fields are composed of ``BibRecordField/subfields``, which are portions of data semantically identified by
/// their ``BibSubfield/subfieldCode``. The interpretation of data within a content field is often determined by its
/// indicators and the formatting of its subfields' contents. For example, a bibliographic record's title statement,
/// identified with the tag `245`, formats its content using ISBD principles and uses subfield codes to semantically
/// tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page: [International Standard Bibliographic Description][isbd].
///
/// The ISBD punctuation standard can be found in section A3 in [the consolidated technical specification][spec].
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// [MARC 21 Record Structure][marc].
///
/// [isbd]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
/// [spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
/// [marc]: https://www.loc.gov/marc/specifications/specrecstruc.html
@interface BibMutableRecordField : BibRecordField

/// A value indicating the semantic purpose of the record field.
@property (nonatomic, readwrite, copy) BibFieldTag *fieldTag;

/// The information contained within the control field.
///
/// - note: This value is `nil` for data fields.
/// - note: This value is never `nil` for control fields.
///         Setting it to `nil` will change its value to the empty string.
@property (nonatomic, readwrite, copy, nullable) NSString *controlValue;

/// The first metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// - note: This value is `nil` for control fields.
/// - note: This value is never `nil` for data fields.
///         Setting it to `nil` will change its value to the blank indicator.
@property (nonatomic, readwrite, copy, nullable) BibFieldIndicator *firstIndicator;

/// The second metadata value in a data field, which can identify some semantic meaning to the field as a whole.
///
/// - note: This value is `nil` for control fields.
/// - note: This value is never `nil` for data fields.
///         Setting it to `nil` will change its value to the blank indicator.
@property (nonatomic, readwrite, copy, nullable) BibFieldIndicator *secondIndicator;

/// An ordered list of subfields containing portions of data semantically identified by their ``BibSubfield/subfieldCode``.
///
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag `245`,formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// - note: This value is `nil` for control fields.
/// - note: This value is never `nil` for data fields.
///         Setting it to `nil` will change its value to an empty array.
@property (nonatomic, readwrite, copy, nullable) NSArray<BibMutableSubfield *> *subfields;

@end

@interface BibMutableRecordField (SubfieldAccess)

/// Get this data field's subfield at the given index.
/// - parameter index: The index of the subfield to access.
/// - returns: This data field's subfield located at the given index.
/// - note: This method will throw an `NSSRangeException` for control fields.
- (BibMutableSubfield *)subfieldAtIndex:(NSUInteger)index;

/// Use indexed subscripting syntax to access a subfield from this data field.
/// - parameter index: The index of the subfield to access.
/// - returns: This data field's subfield located at the given index.
/// - note: This method will throw an `NSSRangeException` for control fields.
- (BibMutableSubfield *)objectAtIndexedSubscript:(NSUInteger)index;

/// Get the first subfield marked with the given code.
/// - parameter subfieldCode: The subfield code that the resulting subfield should have.
/// - returns: The first subfield in this data field with the given subfield code.
///            `nil` is returned if there is no such matching subfield.
/// - note: This method always returns `nil` for control fields.
- (nullable BibMutableSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(subfield(with:));

/// Get the first subfield marked with the given code within a specified range.
/// - parameter subfieldCode: The subfield code that the resulting subfield should have.
/// - parameter range: The range of indexes to search within for the subfield with the given code.
/// - returns: The first subfield in this data field with the given subfield code.
///            `nil` is returned if there is no such matching subfield.
/// - note: This method always returns `nil` for control fields.
- (nullable BibMutableSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode inRange:(NSRange)range NS_SWIFT_NAME(subfield(with:in:));

/// Get all subfields marked with the given code.
/// - parameter subfieldCode: The subfield code that the resulting subfields should have.
/// - returns: An array of all subfields with the given subfield code.
///            An empty array is returned when no subfields with the given code are found.
/// - note: This method always returns an empty array for control fields.
- (NSArray<BibMutableSubfield *> *)subfieldsWithCode:(BibSubfieldCode)subfieldCode NS_SWIFT_NAME(subfields(with:));

@end

@interface BibMutableRecordField (SubfieldModification)

/// Append a subfield to the end of the field.
/// - parameter subfield: The subfield to add to the end of the field.
- (void)addSubfield:(BibMutableSubfield *)subfield;

/// Remove the subfield from the field.
/// - parameter subfield: The subfield to remove.
- (void)removeSubfield:(BibMutableSubfield *)subfield;

/// Remove the subfield at the given location from the field.
/// - parameter index: The location of the subfield to remove.
- (void)removeSubfieldAtIndex:(NSUInteger)index;

/// Add a subfield to the field at the given location.
/// - parameter subfield: The subfield to add to the field.
/// - parameter index: The location in the field to add the subfield.
- (void)insertSubfield:(BibMutableSubfield *)subfield atIndex:(NSUInteger)index;

/// Replace the subfield at the given location with another subfield.
/// - parameter index: The location of the subfield to replace.
/// - parameter subfield: The subfield to replace the previous subfield with.
- (void)replaceSubfieldAtIndex:(NSUInteger)index withSubfield:(BibMutableSubfield *)subfield;

/// Replace the subfield at the given location with another subfield.
/// - parameter subfield: The subfield to replace the previous subfield with.
/// - parameter index: The location of the subfield to replace.
- (void)setObject:(BibMutableSubfield *)subfield atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
