//
//  BibLeader.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMetadata.h"

NS_ASSUME_NONNULL_BEGIN

extern NSUInteger const BibLeaderRawDataLength NS_SWIFT_NAME(Leader.rawValueLength);

/// A collection of metadata preceeding a the encoded data for a record.
///
/// The record leader provides information about the layout of data within a record.
/// Such information includes the total size in memory of the record, the layout of fields' tags and indicators,
/// and other miscellaneous metadata.
///
/// More information about the MARC 21 leader can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader
NS_SWIFT_NAME(Leader)
@interface BibLeader : NSObject

/// The 24-byte encoded representation of the leader's data.
@property (nonatomic, copy, readonly) NSData *rawData NS_SWIFT_NAME(rawValue);

/// Create the leader for a MARC 21 record.
///
/// \param data A buffer of 24 bytes in which leader data is encoded.
/// \returns A new record leader backed by the given data representation.
/// 
/// \discussion More information about the MARC 21 leader can be found in the Library of Congress's
/// documentation on MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader
- (instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;

/// Create the leader for a MARC 21 record.
///
/// \param string The raw string representation of the leader data.
/// \returns Returns a new record leader backed by the given string value.
- (nullable instancetype)initWithString:(NSString *)string;

@end

#pragma mark -

@interface BibLeader (Equality)

/// Determine whether or not the given leader describes the same MARC 21 record as the receiver.
///
/// \param leader The leader with which the receiver should be compared.
/// \returns Returns \c YES if the given leader and the receiver describe the same MARC 21 record.
///
/// \note This method cannot be used to determine equality between two MARC 21 records.
- (BOOL)isEqualToLeader:(BibLeader *)leader;

@end

#pragma mark -

@interface BibLeader (Copying) <NSCopying, NSMutableCopying>
@end

/// A mutable collection of metadata preceeding a the encoded data for a record.
///
/// The record leader provides information about the layout of data within a record.
/// Such information includes the total size in memory of the record, the layout of fields' tags and indicators,
/// and other miscellaneous metadata.
///
/// More information about the MARC 21 leader can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader
NS_SWIFT_NAME(MutableLeader)
@interface BibMutableLeader : BibLeader

/// The 24-byte encoded representation of the leader's data.
@property (nonatomic, copy, readwrite) NSData *rawData NS_SWIFT_NAME(rawValue);

@end

#pragma mark -

@interface BibLeader (Metadata)

/// The range of bytes that contain the record's fields..
@property (nonatomic, readonly) NSRange recordRange;

/// The record's current status in the database it was fetched from.
@property (nonatomic, readonly) BibRecordStatus recordStatus;

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@property (nonatomic, readonly) BibRecordKind recordKind;

/// The character encoding used to represent textual information within the record.
@property (nonatomic, readonly) BibEncoding recordEncoding;

/// Implementation defined bytes
- (char)implementationDefinedValueAtIndex:(BibImplementationDefinedValueIndex)index;

@end

@interface BibLeader (EntryMap)

@property (nonatomic, readonly) NSUInteger lengthOfLengthOfField;

@property (nonatomic, readonly) NSUInteger lengthOfFieldLocation;

@end

#pragma mark -

@interface BibMutableLeader (Metadata)

/// The range of bytes that contain the record's fields..
@property (nonatomic, readwrite) NSRange recordRange;

/// The record's current status in the database it was fetched from.
@property (nonatomic, readwrite) BibRecordStatus recordStatus;

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@property (nonatomic, readwrite) BibRecordKind recordKind;

/// The character encoding used to represent textual information within the record.
@property (nonatomic, readwrite) BibEncoding recordEncoding;

- (void)setImplementationDefinedValue:(char)value atIndex:(BibImplementationDefinedValueIndex)index;

@end

NS_ASSUME_NONNULL_END
