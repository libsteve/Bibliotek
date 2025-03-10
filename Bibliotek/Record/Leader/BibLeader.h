//
//  BibLeader.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>
#import <Bibliotek/BibRecordKind.h>
#import <Bibliotek/BibRecordFormat.h>
#import <Bibliotek/BibRecordStatus.h>
#import <Bibliotek/BibBibliographicLevel.h>
#import <Bibliotek/BibBibliographicControlType.h>
#import <Bibliotek/BibEncoding.h>
#import <Bibliotek/BibRecordKind.h>

NS_ASSUME_NONNULL_BEGIN

/// A MARC record leader is always exactly 24 bytes of visible ASCII characters.
extern NSUInteger const BibLeaderRawDataLength NS_REFINED_FOR_SWIFT;

typedef char BibLeaderValue NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(LeaderValue);

typedef NS_ENUM(uint8_t, BibLeaderLocation) {
    BibLeaderLocationRecordStatus = 5,
    BibLeaderLocationRecordKind = 6,
    BibLeaderLocationBibliographicLevel = 7,
    BibLeaderLocationKindOfCommunityData = 7,
    BibLeaderLocationBibliographicControlType = 8,
    BibLeaderLocationCharacterEncoding = 9,
    BibLeaderLocationEncodingLevel = 17,
    BibLeaderLocationDescriptiveCatalogingForm = 18,
    BibLeaderLocationPunctuationPolicy = 18,
    BibLeaderLocationMultipartRecordLevel = 19
} NS_SWIFT_NAME(LeaderLocation);

#pragma mark - Leader

/// A collection of metadata preceding a the encoded data for a record.
///
/// The record leader provides information about the layout of data within a record, and the semantics to use
/// when interpreting record data. Such information includes the total size in memory of the record, the layout
/// of fields' tags and indicators, and other miscellaneous metadata.
///
/// The bytes located at index `07`, `08`, `17`, `18`, and `19` within the record leader are reserved for
/// implementation-defined semantics. Use the leader's ``recordKind`` to determine how to interpret these values.
///
/// More information about the MARC 21 leader can be found in
/// [the Library of Congress's documentation on MARC 21 Record Structure][record-structure].
///
/// [record-structure]: (https://www.loc.gov/marc/specifications/specrecstruc.html#leader)
BIB_SWIFT_BRIDGE(Leader)
@interface BibLeader : NSObject

/// The 24-byte encoded representation of the leader's data.
///
/// All 24 bytes within the record leader are visible ASCII characters.
@property (nonatomic, copy, readonly) NSData *rawData NS_SWIFT_NAME(rawValue);

/// Create the leader for a MARC 21 record.
///
/// - parameter data: A buffer of 24 bytes in which leader data is encoded.
/// - returns: A new record leader backed by the given data representation.
/// 
/// More information about the MARC 21 leader can be found in
/// [the Library of Congress's documentation on MARC 21 Record Structure][record-structure].
///
/// [record-structure]: (https://www.loc.gov/marc/specifications/specrecstruc.html#leader)
- (nullable instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;

/// Create the leader for a MARC 21 record.
///
/// - parameter string: The raw string representation of the leader data.
/// - returns: Returns a new record leader backed by the given string value.
- (nullable instancetype)initWithString:(NSString *)string;

- (BibLeaderValue)leaderValueAtLocation:(BibLeaderLocation)location;

@end

#pragma mark - Copying

@interface BibLeader (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibLeader (Equality)

/// Determine whether or not the given leader describes the same MARC 21 record as the receiver.
///
/// - parameter leader: The leader with which the receiver should be compared.
/// - returns: Returns `YES` if the given leader and the receiver describe the same MARC 21 record.
///
/// - note: This method cannot be used to determine equality between two MARC 21 records.
- (BOOL)isEqualToLeader:(BibLeader *)leader;

@end

#pragma mark - Mutable Leader

/// A mutable collection of metadata preceding a the encoded data for a record.
///
/// The record leader provides information about the layout of data within a record.
/// Such information includes the total size in memory of the record, the layout of fields' tags and indicators,
/// and other miscellaneous metadata.
///
/// More information about the MARC 21 leader can be found in
/// [the Library of Congress's documentation on MARC 21 Record Structure][record-structure].
///
/// [record-structure]: (https://www.loc.gov/marc/specifications/specrecstruc.html#leader)
@interface BibMutableLeader : BibLeader

/// The 24-byte encoded representation of the leader's data.
@property (nonatomic, copy, readwrite) NSData *rawData NS_SWIFT_NAME(rawValue);

- (void)setLeaderValue:(BibLeaderValue)value atLocation:(BibLeaderLocation)location;

@end

#pragma mark - Metadata

@interface BibLeader (Metadata)

/// The range of bytes that contain the record's fields.
@property (nonatomic, readonly) NSRange recordRange;

/// The record's current status in the database it was fetched from.
@property (nonatomic, readonly) BibRecordStatus recordStatus;

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this field to determine how tags and subfield codes should be used to interpret field content.
@property (nonatomic, readonly) BibRecordKind recordKind;

/// The character encoding used to represent textual information within the record.
@property (nonatomic, readonly) BibEncoding recordEncoding;

/// The specificity used to identify the item represented by a bibliographic record.
@property (nonatomic, readonly) BibBibliographicLevel bibliographicLevel NS_REFINED_FOR_SWIFT;

/// The ruleset used to determine the information about the item that's included in the record.
@property (nonatomic, readonly) BibBibliographicControlType bibliographicControlType NS_REFINED_FOR_SWIFT;

@end

@interface BibLeader (EntryMap)

@property (nonatomic, readonly) NSUInteger lengthOfLengthOfField;

@property (nonatomic, readonly) NSUInteger lengthOfFieldLocation;

@end

@interface BibLeader (ContentField)

@property (nonatomic, readonly) NSUInteger numberOfIndicators;

@property (nonatomic, readonly) NSUInteger lengthOfSubfieldCode;

@end

#pragma mark - Mutable Metadata

@interface BibMutableLeader (Metadata)

/// The range of bytes that contain the record's fields.
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

/// The specificity used to identify the item represented by a bibliographic record.
@property (nonatomic, readwrite) BibBibliographicLevel bibliographicLevel NS_REFINED_FOR_SWIFT;

/// The ruleset used to determine the information about the item that's included in the record.
@property (nonatomic, readwrite) BibBibliographicControlType bibliographicControlType NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
