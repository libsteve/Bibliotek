//
//  BibMetadata.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>
#import <Bibliotek/BibRecordStatus.h>
#import <Bibliotek/BibEncoding.h>
#import <Bibliotek/BibBibliographicControlType.h>

@class BibRecordKind;

NS_ASSUME_NONNULL_BEGIN

/// An index type used to reference implementation-specific data from a record's leader.
typedef NS_CLOSED_ENUM(NSUInteger, BibReservedPosition) {
    BibReservedPosition07 NS_SWIFT_NAME(at07) =  7,
    BibReservedPosition08 NS_SWIFT_NAME(at08) =  8,
    BibReservedPosition17 NS_SWIFT_NAME(at17) = 17,
    BibReservedPosition18 NS_SWIFT_NAME(at18) = 18,
    BibReservedPosition19 NS_SWIFT_NAME(at19) = 19
} NS_SWIFT_NAME(ReservedPosition);

#pragma mark - Metadata

/// A collection of bytes embeded within a MARC record's leader.
///
/// The significance of these metadata values are specific to the scheme used to encode the MARC record.
/// The reserved bytes are located at index `7,` `8`,`17,` `18`,and `19` within the record leader.
///
/// Use a record's `kind` to determine how to interpret these metadata values.
BIB_SWIFT_BRIDGE(Metadata)
DEPRECATED_MSG_ATTRIBUTE("Replaced with BibLeader")
@interface BibMetadata : NSObject

/// Retrieve the byte stored within the reserved position in the MARC record's leader.
///
/// - parameter position: The index location of the desired byte in the record's leader.
/// - returns: The byte held at the reserved location in the record's leader.
- (int8_t)valueForReservedPosition:(BibReservedPosition)position NS_SWIFT_NAME(value(forReservedPosition:));

@end

@interface BibMetadata (Copying) <NSCopying, NSMutableCopying>
@end

@interface BibMetadata (Equality)

/// Determine whether or not the given metadata describes the same type of record as the receiver.
///
/// - parameter metadata: The set of metadata with which the receiver should be compared.
/// - returns: Returns `YES` if the given metadata and the receiver describe the same type of record.
- (BOOL)isEqualToMetadata:(BibMetadata *)metadata;

@end

#pragma mark - Mutable Metadata

/// A collection of bytes embeded within a MARC record's leader.
///
/// The significance of these metadata values are specific to the scheme used to encode the MARC record.
/// The reserved bytes are located at index `7,` `8`,`17,` `18`,and `19` within the record leader.
///
/// Use a record's `kind` to determine how to interpret these metadata values.
DEPRECATED_MSG_ATTRIBUTE("Replaced with BibMutableLeader")
@interface BibMutableMetadata : BibMetadata

/// Set the byte value within the reserved position in the MARC record's leader.
///
/// - parameter value: The byte to store within the record's leader.
/// - parameter position: The index location of the desired byte in the record's leader.
- (void)setValue:(int8_t)value forReservedPosition:(BibReservedPosition)position
    NS_SWIFT_NAME(setValue(_:forReservedPosition:));

@end

#pragma mark - Bibliographic Level

/// The specificity used to identify the item represented by a bibliographic record.
typedef NS_ENUM(char, BibBibliographicLevel) {
    /// Monographic component part
    ///
    /// An item within a larger single monographic work, such as a chapter within a book.
    BibBibliographicLevelMonographicComponentPart = 'a',

    /// Serial component part
    ///
    /// An item within instances of a recurring series of works, such as a regularly-appearing column in a news paper.
    BibBibliographicLevelSerialComponentPart = 'b',

    /// Collection
    ///
    /// An artificially combined group of items that were not originally published together.
    BibBibliographicLevelCollection = 'c',

    /// Subunit
    ///
    /// An item or group of items within a larger collection.
    BibBibliographicLevelSubunit = 'd',

    /// Integrating resource
    ///
    /// An item with components that are added and modified individually, such as individual pages in a website.
    BibBibliographicLevelIntegratingResource = 'i',

    /// Monograph/Item
    ///
    /// An item considered to be a single work on its own, such as a book or an album.
    BibBibliographicLevelMonograph = 'm',

    /// Serial
    ///
    /// An individual item within a regular series of works, such as a magazine or news paper.
    BibBibliographicLevelSerial = 's'
} NS_SWIFT_NAME(BibliographicLevel);

/// A human-readable description of the bibliographic level.
///
/// - parameter level: The bibliographic level of the record.
/// - returns: A human-readable description of `level`.
extern NSString *BibBibliographicLevelDescription(BibBibliographicLevel level) NS_REFINED_FOR_SWIFT;

#pragma mark -

@interface BibMetadata (DefinedValues)

/// The character encoding used to represent textual information within the record.
@property (nonatomic, readonly) BibEncoding encoding;

/// The type of data represented by a record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this field to determine how tags and subfield codes should be used to interpret field content.
@property (nonatomic, readonly) BibRecordKind *recordKind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, readonly) BibRecordStatus recordStatus;

/// The specificity used to identify the item represented by a bibliographic record.
@property (nonatomic, readonly) BibBibliographicLevel bibliographicLevel NS_REFINED_FOR_SWIFT;

/// The ruleset used to determine the information about the item that's included in the record.
@property (nonatomic, readonly) BibBibliographicControlType bibliographicControlType NS_REFINED_FOR_SWIFT;

@end

@interface BibMutableMetadata (DefinedValues)

/// The type of data represented by a record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this field to determine how tags and subfield codes should be used to interpret field content.
@property (nonatomic, readwrite) BibRecordKind *recordKind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, readwrite) BibRecordStatus recordStatus;

/// The specificity used to identify the item represented by a bibliographic record.
@property (nonatomic, readwrite) BibBibliographicLevel bibliographicLevel NS_REFINED_FOR_SWIFT;

/// The ruleset used to determine the information about the item that's included in the record.
@property (nonatomic, readwrite) BibBibliographicControlType bibliographicControlType NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
