//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibSubfield.h>
#import <Bibliotek/BibRecordStatus.h>
#import <Bibliotek/BibAttributes.h>
#import <Bibliotek/BibRecordKind.h>
#import <Bibliotek/BibRecordField.h>

@class BibFieldTag;
@class BibFieldPath;
@class BibLeader;

NS_ASSUME_NONNULL_BEGIN

/// A collection of information about an item or entity organized using the MARC 21 standard.
///
/// MARC 21 records are comprised of metadata about the record itself, a set of control fields storing metadata about
/// how the record should be processed, and a set of control fields that provide bibliographic, classification,
/// or other data describing the represented item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/spechome.html).
BIB_SWIFT_BRIDGE(Record)
@interface BibRecord : NSObject

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this field to determine how tags and subfield codes should be used to interpret field content.
@property (nonatomic, assign, readonly) BibRecordKind kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readonly) BibRecordStatus status;

/// Implementation-defined metadata from the MARC record's leader.
///
/// MARC records can have arbitrary implementation-defined data embedded in their leader.
/// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
///
/// Use this field to access those bytes, which should be interpreted using the scheme identified in `kind`.
@property (nonatomic, copy, readonly) BibLeader *leader;

/// An ordered list of fields containing information and metadata about the record and its represented item.
@property (nonatomic, copy, readonly) NSArray<BibRecordField *> *fields;

/// Create a MARC 21 record with the given data.
///
/// - parameter leader: A set of metadata describing the record, its encoding, and its state in the database.
/// - parameter fields: An ordered list of control fields and data fields describing the record and its
///                     represented item.
/// - returns: Returns a valid MARC 21 record for some item or entity described by the given fields.
- (instancetype)initWithLeader:(BibLeader *)leader
                        fields:(NSArray<BibRecordField *> *)fields NS_DESIGNATED_INITIALIZER;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
///
/// - parameter leader: A set of metadata describing the record, its encoding, and its state in the database.
/// - parameter fields: An ordered list of control fields and data fields describing the record and its
///                     represented item.
/// - returns Returns a valid MARC 21 record for some item or entity described by the given fields.
+ (instancetype)recordWithLeader:(BibLeader *)leader
                          fields:(NSArray<BibRecordField *> *)fields
    NS_SWIFT_UNAVAILABLE("use init(leader:fields:)");


@end

#pragma mark - Copying

@interface BibRecord (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibRecord (Equality)

/// Determine whether or not the given MARC 21 record contains the same data as the receiver.
///
/// - parameter record: The record with which the receiver should be compared.
/// - returns: Returns `YES` if the given record and the receiver contain the same data
- (BOOL)isEqualToRecord:(BibRecord *)record;

@end

#pragma mark - Field Access

@interface BibRecord (FieldAccess)

/// The total number of control fields and data fields in the record.
@property (nonatomic, assign, readonly) NSUInteger countOfFields;

/// Get the field at the given index.
///
/// - parameter index: The index for the record field to access.
/// - returns: The data field or control field located at the given index.
- (BibRecordField *)fieldAtIndex:(NSUInteger)index NS_SWIFT_NAME(field(at:));

/// Get the fields at the given indexes.
///
/// - parameter indexes: The set of all locations in the record to get fields from.
/// - returns: An array of the fields at the given locations.
- (NSArray<BibRecordField *> *)fieldsAtIndexes:(NSIndexSet *)indexes NS_SWIFT_NAME(fields(at:));

/// Test to see if the record contains a field with the given tag.
///
/// - parameter fieldTag: If this record has a field with this value, `YES` is returned.
/// - returns: `YES` if at least one record field is marked with the given tag.
- (BOOL)containsFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(containsField(with:));

/// Get the index of the first record field with the given tag.
///
/// - parameter fieldTag: The field tag marking the data field or control field to access.
/// - returns: The index of the first record with the given tag. If no such field exists, `NSNotFound` is returned.
- (NSUInteger)indexOfFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(indexOfField(with:));

/// Get the index of the first record field with the given tag.
///
/// - parameter fieldTag: The field tag marking the data field or control field to access.
/// - parameter range: The range of indexes to search within for the field with the given tag.
/// - returns: The index of the first record in the range with the given tag. If no such field exists, `NSNotFound` is returned.
- (NSUInteger)indexOfFieldWithTag:(BibFieldTag *)fieldTag inRange:(NSRange)range NS_SWIFT_NAME(indexOfField(with:in:));

/// Get the indexes of all control or data fields with the given tag.
///
/// - parameter fieldTag: The field tag marking the control or data fields to access.
/// - returns: The locations of all fields in the record with the given field tag.
- (NSIndexSet *)indexesOfFieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(indexesOfFields(with:));

/// Get the first control or data field with the given tag.
///
/// - parameter fieldTag: The field tag marking the data field or control field to access.
/// - returns: The first record with the given tag. If no such field exists, `nil` is returned.
- (nullable BibRecordField *)fieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(field(with:));

/// Get the first control or data field with the given tag.
///
/// - parameter fieldTag: The field tag marking the data field or control field to access.
/// - parameter range: The range of indexes to search within for the field with the given tag.
/// - returns: The first record with the given tag. If no such field exists, `nil` is returned.
- (nullable BibRecordField *)fieldWithTag:(BibFieldTag *)fieldTag inRange:(NSRange)range NS_SWIFT_NAME(field(with:in:));

/// Get all control or data fields with the given tag.
///
/// - parameter fieldTag: The field tag marking the data fields or control fields to access.
/// - returns: An array of the fields with the given tag.
- (NSArray<BibRecordField *> *)fieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(fields(with:));

/// Get the control or data field referenced by the given index path.
///
/// - parameter indexPath: The index path value pointing to the field or one of its subfields.
/// - returns: The record field referenced by the index path.
///            If the index path points to a subfield, its field is returned.
- (BibRecordField *)fieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(field(at:));

/// Get the subfield referenced by the given index path.
///
/// - parameter indexPath: The index path value pointing to a specific subfield value.
/// - returns: The subfield object referenced by the index path.
/// - throws: `NSRangeException` when given an index path that points to a field instead of its subfield,
///            or if the index path points into a control field instead of a data field.
- (BibSubfield *)subfieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(subfield(at:));

/// Get a string representation of the value stored at the given index path.
/// 
/// - parameter indexPath: The index path of a control field, data field, or subfield.
/// - returns: A string representation of the data contained within the referenced control field, data field, or subfield.
- (NSString *)contentAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(content(at:));

@end

@interface BibRecord (MultipleFieldAccess)

/// Get index paths for all control or data fields with the given tag.
///
/// - parameter fieldTag: The field tag marking the control or data fields to access.
/// - returns: Index paths locating all the control or data fields with the given field tag.
- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(indexPaths(for:));

/// Get index paths for all subfields with the given code, whose data fields have the given tag.
///
/// - parameter fieldTag: The field tag marking the data fields to access.
/// - parameter subfieldCode: The code of the subfields to access.
/// - returns: Index paths locating all the subfields with the given code in data fields with the given tag.
- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_NAME(indexPaths(for:code:));

/// Get index paths for all control fields, data fields, or subfields identified by the given path.
///
/// - parameter fieldPath: The path identifying particular control fields, data fields, or subfields.
/// - returns: An array of index paths locating the data identified by the given field path.
- (NSArray<NSIndexPath *> *)indexPathsForFieldPath:(BibFieldPath *)fieldPath NS_SWIFT_NAME(indexPaths(for:));

/// Get the string representation for all control or data field with the given tag.
///
/// - parameter fieldTag: The field tag marking the control or data fields to access.
/// - returns: An array of string values representing the contents of all identified fields.
- (NSArray<NSString *> *)contentWithFieldTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(content(with:));

/// Get the contents of all subfields with the given code, whose data fields have the given tag.
///
/// - parameter fieldTag: The field tag marking the data fields to access.
/// - parameter subfieldCode: The code of the subfields to access.
/// - returns: An array of string values representing the contents of all identified subfields.
- (NSArray<NSString *> *)contentWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_NAME(content(with:code:));

/// Get the string representation of all control fields, data fields, or subfields identified by the given path.
///
/// - parameter fieldPath: The path identifying particular control fields, data fields, or subfields.
/// - returns: An array of string values representing the data identified by the given field path.
- (NSArray<NSString *> *)contentWithFieldPath:(BibFieldPath *)fieldPath NS_SWIFT_NAME(content(with:));

@end

#pragma mark - Mutable Record

/// A mutable collection of information about an item or entity organized using the MARC 21 standard.
///
/// MARC 21 records are comprised of metadata about the record itself, a set of control fields storing metadata about
/// how the record should be processed, and a set of control fields that provide bibliographic, classification,
/// or other data describing the represented item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/spechome.html).
@interface BibMutableRecord : BibRecord

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@property (nonatomic, assign, readwrite) BibRecordKind kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readwrite) BibRecordStatus status;

/// Implementation-defined metadata from the MARC record's leader.
///
/// MARC records can have arbitrary implementation-defined data embedded in their leader.
/// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
///
/// Use this field to access those bytes, which should be interpreted using the scheme identified in `kind`.
@property (nonatomic, copy, readwrite) BibLeader *leader;

/// An ordered list of fields containing information and metadata about the record and its represented item.
@property (nonatomic, copy, readwrite) NSArray<BibMutableRecordField *> *fields;

@end

#pragma mark - Mutable Field Access

@interface BibMutableRecord (FieldAccess)

/// Get the field at the given index.
///
/// - parameter index: The index for the record field to access.
/// - returns: The data field or control field located at the given index.
- (BibMutableRecordField *)fieldAtIndex:(NSUInteger)index NS_SWIFT_NAME(field(at:));

/// Get the fields at the given indexes.
///
/// - parameter indexes: The set of all locations in the record to get fields from.
/// - returns: An array of the fields at the given locations.
- (NSArray<BibMutableRecordField *> *)fieldsAtIndexes:(NSIndexSet *)indexes NS_SWIFT_NAME(fields(at:));

/// Get the first record field with the given tag.
///
/// - parameter fieldTag: The field tag marking the data field or control field to access.
/// - returns: The first record with the given tag. If no such field exists, `nil` is returned.
- (nullable BibMutableRecordField *)fieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(field(with:));

/// Get the first record field with the given tag.
///
/// - parameter fieldTag: The field tag marking the data field or control field to access.
/// - parameter range: The range of indexes to search within for the field with the given tag.
/// - returns: The first record with the given tag. If no such field exists, `nil` is returned.
- (nullable BibMutableRecordField *)fieldWithTag:(BibFieldTag *)fieldTag inRange:(NSRange)range NS_SWIFT_NAME(field(with:in:));

/// Get all fields with the given tag.
///
/// - parameter fieldTag: The field tag marking the data fields or control fields to access.
/// - returns: An array of the fields with the given tag.
- (NSArray<BibMutableRecordField *> *)fieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(fields(with:));

/// Get the record field referenced by the given index path.
///
/// - parameter indexPath: The index path value pointing to the field or one of its subfields.
/// - returns: The record field referenced by the index path.
///            If the index path points to a subfield, its field is returned.
- (BibMutableRecordField *)fieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(field(at:));

/// Get the subfield referenced by the given index path.
///
/// - parameter indexPath: The index path value pointing to a specific subfield value.
/// - returns: The subfield object referenced by the index path.
/// - throws: `NSRangeException` when given an index path that points to a field instead of its subfield,
///            or if the index path points into a control field instead of a data field.
- (BibMutableSubfield *)subfieldAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(subfield(at:));

@end

@interface BibMutableRecord (FieldModification)

/// Add a control or data field to the end of the record.
///
/// - parameter field: The control or data field to add to the record.
- (void)addField:(BibMutableRecordField *)field;

/// Insert a control or data field into the record at a given location.
///
/// - parameter field: The control or data field to insert into the record.
/// - parameter index: The location in the record to insert the given field.
- (void)insertField:(BibMutableRecordField *)field atIndex:(NSUInteger)index;

/// Insert a collection of control or data fields into the record at the given locations.
///
/// - parameter fields: An array of control or data fields to insert into the record.
/// - parameter indexes: The locations in the record to insert each field.
/// - precondition: There should be an equal amount of fields and indexes.
///
/// The `fields` array should be ordered such that the first field is inserted at the first
/// index in `indexes`, the second field is inserted at the second index in `indexes`, and so on.
///
/// Each successive index in `indexes` should have its location in the record assume that field has
/// been inserted at the location before it.
- (void)insertFields:(NSArray<BibMutableRecordField *> *)fields atIndexes:(NSIndexSet *)indexes;

/// Replace a control or data field in the record with another field.
///
/// - parameter index: The location of the control or data field to replace.
/// - parameter field: The control or data field to set as the new field at the location.
- (void)replaceFieldAtIndex:(NSUInteger)index withField:(BibMutableRecordField *)field;

/// Replace multiple control or data fields in the record with new control or data fields.
///
/// - parameter indexes: The locations in the record of fields to replace with new values.
/// - parameter fields: An array of control or data fields to set as the new values for each location in the record.
/// - precondition: There should be an equal amount of fields and indexes.
///
/// The `fields` array should be ordered such that the first index in `indexes` is where the first
/// field in `fields` is set, the second index in `indexes` is where the second field in `fields`
/// is set, and so on.
- (void)replaceFieldsAtIndexes:(NSIndexSet *)indexes withFields:(NSArray<BibMutableRecordField *> *)fields;

/// Remove a control or data field from the record.
///
/// - parameter index: The location of the control or data field to remove.
- (void)removeFieldAtIndex:(NSUInteger)index;

/// Remove multiple control or data fields from the record at once.
///
/// - parameter indexes: The locations of each control or data field to remove from the record.
- (void)removeFieldsAtIndexes:(NSIndexSet *)indexes;

@end

NS_ASSUME_NONNULL_END
