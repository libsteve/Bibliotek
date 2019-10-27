//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMetadata.h"

@class BibControlField;
@class BibContentField;
@class BibRecordKind;

@class BibFieldTag;
@class BibFieldEnumerator<FieldType>;

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
@property (nonatomic, copy, readonly) NSArray<BibControlField *> *controlFields;

/// An ordered list of fields containing information and metadata about the item represented by a record.
@property (nonatomic, copy, readonly) NSArray<BibContentField *> *contentFields;

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
               contentFields:(NSArray<BibContentField *> *)contentFields NS_DESIGNATED_INITIALIZER;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
///
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
+ (instancetype)recordWithKind:(nullable BibRecordKind *)kind
                        status:(BibRecordStatus)status
                      metadata:(BibMetadata *)metadata
                 controlFields:(NSArray<BibControlField *> *)controlFields
                 contentFields:(NSArray<BibContentField *> *)contentFields
    NS_SWIFT_UNAVAILABLE("Use init(kind:status:controlFields:contentFields:");

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

@interface BibRecord (FieldAccess)

- (BibFieldEnumerator<BibControlField *> *)controlFieldEnumerator;
- (BibFieldEnumerator<BibContentField *> *)contentFieldEnumerator;

- (nullable BibControlField *)firstControlFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(firstControlField(with:));
- (nullable BibContentField *)firstContentFieldWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(firstControlField(with:));

- (NSArray<BibControlField *> *)controlFieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(controlFields(with:));
- (NSArray<BibContentField *> *)contentFieldsWithTag:(BibFieldTag *)fieldTag NS_SWIFT_NAME(contentFields(with:));

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
@property (nonatomic, readwrite, nullable) BibRecordKind *kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readwrite) BibRecordStatus status;

@property (nonatomic, copy, readwrite) BibMetadata *metadata;

@property (nonatomic, copy, readwrite) NSArray<BibControlField *> *controlFields;

@property (nonatomic, copy, readwrite) NSArray<BibContentField *> *contentFields;

@end

NS_ASSUME_NONNULL_END
