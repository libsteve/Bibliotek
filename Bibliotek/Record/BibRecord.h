//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibMetadata.h>
#import <Bibliotek/BibSubfield.h>

@class BibControlField;
@class BibContentField;
@class BibRecordField;
@class BibRecordKind;

@class BibFieldTag;
@class BibFieldEnumerator<FieldType>;
@class BibFieldPath;
@protocol BibField;

NS_ASSUME_NONNULL_BEGIN

/// A collection of information about an item or entity organized using the MARC 21 standard.
///
/// MARC 21 records are comprised of metadata about the record itself, a set of control fields storing metadata about
/// how the record should be processed, and a set of control fields that provide bibliographic, classification,
/// or other data describing the represented item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/spechome.html
@interface BibRecord : NSObject

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this field to determine how tags and subfield codes should be used to interpret field content.
@property (nonatomic, strong, readonly, nullable) BibRecordKind *kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readonly) BibRecordStatus status;

/// Implementation-defined metadata from the MARC record's leader.
///
/// MARC records can have arbitrary implementation-defined data embeded in their leader.
/// The reserved bytes are located at index \c 7, \c 8, \c 17, \c 18, and \c 19 within the record leader.
///
/// Use this field to access those bytes, which should be interpreted using the scheme identified in \c kind.
@property (nonatomic, copy, readonly) BibMetadata *metadata;

/// An ordered list of fields containing information and metadata about how a record's content should be processed.
@property (nonatomic, copy, readonly) NSArray<BibControlField *> *controlFields DEPRECATED_MSG_ATTRIBUTE("replaced with '-fields'");

/// An ordered list of fields containing information and metadata about the item represented by a record.
@property (nonatomic, copy, readonly) NSArray<BibContentField *> *contentFields DEPRECATED_MSG_ATTRIBUTE("replaced with '-fields'");

/// An ordered list of fields containing information and metadata about the record and its represented item.
@property (nonatomic, copy, readonly) NSArray<BibRecordField *> *fields;

/// Create a MARC 21 record with the given data.
///
/// \param kind The type of record.
/// \param status The record's status in its originating database.
/// \param metadata A set of implementation-defined bytes.
/// \param controlFields An ordered list of fields describing how the record should be processed.
/// \param contentFields An ordered list of fields describing the item represented by the record.
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
- (instancetype)initWithKind:(nullable BibRecordKind *)kind
                      status:(BibRecordStatus)status
                    metadata:(BibMetadata *)metadata
               controlFields:(NSArray<BibControlField *> *)controlFields
               contentFields:(NSArray<BibContentField *> *)contentFields
    DEPRECATED_MSG_ATTRIBUTE("replaced with '-initWithKind:status:metadata:fields:'");

/// Create a MARC 21 record with the given data.
///
/// \param kind The type of record.
/// \param status The record's status in its originating database.
/// \param metadata A set of implementation-defined bytes.
/// \param fields An ordered list of control fields and data fields describing the record and its represented item.
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
- (instancetype)initWithKind:(nullable BibRecordKind *)kind
                      status:(BibRecordStatus)status
                    metadata:(BibMetadata *)metadata
                      fields:(NSArray<BibRecordField *> *)fields NS_DESIGNATED_INITIALIZER;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
///
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
+ (instancetype)recordWithKind:(nullable BibRecordKind *)kind
                        status:(BibRecordStatus)status
                      metadata:(BibMetadata *)metadata
                 controlFields:(NSArray<BibControlField *> *)controlFields
                 contentFields:(NSArray<BibContentField *> *)contentFields
    NS_SWIFT_UNAVAILABLE("use 'init(kind:status:metadata:controlFields:contentFields:)'")
    DEPRECATED_MSG_ATTRIBUTE("replaced with '+recordWithKind:status:metadata:fields:'");

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
///
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
+ (instancetype)recordWithKind:(nullable BibRecordKind *)kind
                        status:(BibRecordStatus)status
                      metadata:(BibMetadata *)metadata
                        fields:(NSArray<BibRecordField *> *)controlFields
    NS_SWIFT_UNAVAILABLE("use 'init(kind:status:metadata:fields:)'");


@end

#pragma mark - Copying

@interface BibRecord (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibRecord (Equality)

/// Determine whether or not the given MARC 21 record contains the same data as the receiver.
/// \param record The record with which the receiver should be compared.
/// \returns Returns \c YES if the given record and the receiver contain the same data
- (BOOL)isEqualToRecord:(BibRecord *)record;

@end

#pragma mark - Field Access

@interface BibRecord (DeprecatedFieldAccess)

- (BibFieldEnumerator<BibControlField *> *)controlFieldEnumerator DEPRECATED_ATTRIBUTE;
- (BibFieldEnumerator<BibContentField *> *)contentFieldEnumerator DEPRECATED_ATTRIBUTE;

- (nullable BibControlField *)firstControlFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(firstControlField(with:)) DEPRECATED_ATTRIBUTE;
- (nullable BibContentField *)firstContentFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(firstControlField(with:)) DEPRECATED_ATTRIBUTE;

- (NSArray<BibControlField *> *)controlFieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(controlFields(with:)) DEPRECATED_ATTRIBUTE;
- (NSArray<BibContentField *> *)contentFieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(contentFields(with:)) DEPRECATED_ATTRIBUTE;

- (nullable BibControlField *)controlFieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(controlField(at:)) DEPRECATED_MSG_ATTRIBUTE("replaced with '-fieldAtIndexPath:'");
- (nullable BibContentField *)contentFieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(contentField(at:)) DEPRECATED_MSG_ATTRIBUTE("replaced with '-fieldAtIndexPath:'");

@end

@interface BibRecord (FieldAccess)

/// Get the field at the given index.
/// \param index The index of the record field to access.
/// \returns The data field or control field located at the given index.
- (BibRecordField *)fieldAtIndex:(NSUInteger)index NS_SWIFT_NAME(field(at:));

/// Test to see if the record contains a field with the given tag.
/// \param fieldTag If this record has a field with this value, \c YES is returned.
/// \returns \c YES if at least one record field is marked with the given tag.
- (BOOL)containsFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(containsField(with:));

/// Get the index of the first record field with the given tag.
/// \param fieldTag The field tag marking the data field or control field to access.
/// \returns The index of the first record with the given tag. If no such field exists, \c NSNotFound is returned.
- (NSUInteger)indexOfFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(indexOfField(with:));

/// Get the first record field with the given tag.
/// \param fieldTag The field tag marking the data field or control field to access.
/// \returns The first record with the given tag. If no such field exists, \c nil is returned.
- (nullable BibRecordField *)fieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(field(with:));

/// Get the record field referenced by the given index path.
/// \param indexPath The index path value pointing to the field or one of its subfields.
/// \returns The record field referenced by the index path.
///          If the index path points to a subfield, its field is returned.
- (BibRecordField *)fieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(field(at:));

/// Get the subfield referenced by the given index path.
/// \param indexPath The index path value pointing to a specific subfield value.
/// \returns The subfield object referenced byt the index path.
/// \throws \c NSRangeException when given an index path that points to a field instead of its subfield,
///         or if the index path points into a control field instead of a data field.
- (BibSubfield *)subfieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(subfield(at:));

/// Get a string representation of the value stored at the given index path.
/// \param indexPath The index path of a control field, data field, or subfield.
/// \returns A string representation of the data contained within the referenced control field, data field, or subfield.
- (NSString *)contentAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(content(at:));

@end

@interface BibRecord (MultipleFieldAccess)

- (NSArray<BibRecordField *> *)allFieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(fields(with:));

- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(indexPaths(for:));
- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_NAME(indexPaths(for:code:));
- (NSArray<NSIndexPath *> *)indexPathsForFieldPath:(BibFieldPath *)fieldPath NS_SWIFT_NAME(indexPaths(for:));

- (NSArray<NSString *> *)contentWithFieldTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(content(with:));
- (NSArray<NSString *> *)contentWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_NAME(content(with:code:));
- (NSArray<NSString *> *)contentWithFieldPath:(BibFieldPath *)fieldPath NS_SWIFT_NAME(content(with:));

@end

#pragma mark - Mutable

/// A mutable collection of information about an item or entity organized using the MARC 21 standard.
///
/// MARC 21 records are comprised of metadata about the record itself, a set of control fields storing metadata about
/// how the record should be processed, and a set of control fields that provide bibliographic, classification,
/// or other data describing the represented item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/spechome.html
@interface BibMutableRecord : BibRecord

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@property (nonatomic, strong, readwrite, nullable) BibRecordKind *kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readwrite) BibRecordStatus status;

@property (nonatomic, copy, readwrite) BibMetadata *metadata;

@property (nonatomic, copy, readwrite) NSArray<BibControlField *> *controlFields DEPRECATED_MSG_ATTRIBUTE("replaced with '-fields'");

@property (nonatomic, copy, readwrite) NSArray<BibContentField *> *contentFields DEPRECATED_MSG_ATTRIBUTE("replaced with '-fields'");

/// An ordered list of fields containing information and metadata about the record and its represented item.
@property (nonatomic, copy, readwrite) NSArray<BibRecordField *> *fields;

@end

NS_ASSUME_NONNULL_END
