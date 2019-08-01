//
//  BibMetadata.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

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
/// The reserved bytes are located at index \c 7, \c 8, \c 17, \c 18, and \c 19 within the record leader.
///
/// Use a record's \c kind to determine how to interpret these metadata values.
@interface BibMetadata : NSObject

/// Retrieve the byte stored within the reserved position in the MARC record's leader.
///
/// \param position The index location of the desired byte in the record's leader.
/// \returns The byte held at the reserved location in the record's leader.
- (int8_t)valueForReservedPosition:(BibReservedPosition)position NS_SWIFT_NAME(value(forReservedPosition:));

@end

@interface BibMetadata (Copying) <NSCopying, NSMutableCopying>
@end

@interface BibMetadata (Equality)

/// Determine whether or not the given metadata describes the same type of record as the receiver.
///
/// \param metadata The set of metadata with which the receiver should be compared.
/// \returns Returns \c YES if the given metadata and the receiver describe the same type of record.
- (BOOL)isEqualToMetadata:(BibMetadata *)metadata;

@end

#pragma mark - Mutable Metadata

/// A collection of bytes embeded within a MARC record's leader.
///
/// The significance of these metadata values are specific to the scheme used to encode the MARC record.
/// The reserved bytes are located at index \c 7, \c 8, \c 17, \c 18, and \c 19 within the record leader.
///
/// Use a record's \c kind to determine how to interpret these metadata values.
@interface BibMutableMetadata : BibMetadata

/// Set the byte value within the reserved position in the MARC record's leader.
///
/// \param value The byte to store within the record's leader.
/// \param position The index location of the desired byte in the record's leader.
- (void)setValue:(int8_t)value forReservedPosition:(BibReservedPosition)position
    NS_SWIFT_NAME(setValue(_:forReservedPosition:));

@end

#pragma mark - Encoding

/// The character encoding used to represent textual data in a MARC record.
typedef NS_ENUM(char, BibEncoding) {
    /// MARC8 Encoding
    ///
    /// String data is encoded using the ASCII standard.
    BibMARC8Encoding NS_SWIFT_NAME(marc8) = ' ',

    /// UTF-8 Encoding
    ///
    /// String data is encoded using the UTF-8 standard.
    BibUTF8Encoding  NS_SWIFT_NAME(utf8)  = 'a'
} NS_SWIFT_NAME(Encoding);

/// A human-readable description of the encoding.
///
/// \param encoding The string encoding used to represent textual data.
/// \returns A human-readable description of \c encoding.
NSString *BibEncodingDescription(BibEncoding const encoding) NS_REFINED_FOR_SWIFT;

#pragma mark - Record Status

/// The type of change last applied to a record in its originating database.
typedef NS_ENUM(char, BibRecordStatus) {
    BibRecordStatusIncreaseInEncodingLevel = 'a',

    /// The record has been edited with new information.
    BibRecordStatusRevised                 = 'c',

    /// The record has been deleted from the database.
    BibRecordStatusDeleted                 = 'd',

    /// The record is a new entry in the database.
    BibRecordStatusNew                     = 'n',

    BibRecordStatusIncreaseInEncodingLevelFromPrePublication = 'p'
} NS_SWIFT_NAME(RecordStatus);

NS_ASSUME_NONNULL_END
