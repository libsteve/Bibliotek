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

/// A collection of information describing the type and state of a record.
@interface BibMetadata : NSObject

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

@interface BibMutableMetadata : BibMetadata

- (void)setValue:(int8_t)value forReservedPosition:(BibReservedPosition)index
    NS_SWIFT_NAME(setValue(_:forReservedPosition:));

@end

#pragma mark - Encoding

/// The character encoding used to represent textual data.
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
