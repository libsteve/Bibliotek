//
//  BibMetadata.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark Encoding

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
NSString *BibEncodingDescription(BibEncoding const encoding);

#pragma mark - Record Kind

/// The type of data represented by a MARC 21 record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
typedef NS_ENUM(char, BibRecordKind) {
    /// Classification
    BibRecordKindClassification = 'w',

    /// Language Material
    BibRecordKindLanguageMaterial = 'a',

    /// Notated Music
    BibRecordKindNotatedMusic = 'c',

    /// Manuscript Notated Music
    BibRecordKindManuscriptNotatedMusic = 'd',

    /// Cartographic Material
    BibRecordKindCartographicMaterial = 'e',

    /// Manuscript Cartographic Material
    BibRecordKindManuscriptCartographicMaterial = 'f',

    /// Projected Medium
    BibRecordKindProjectedMedium = 'g',

    /// NonMusical Sound Recording
    BibRecordKindNonMusicalSoundRecording = 'i',

    /// Musical Sound Recording
    BibRecordKindMusicalSoundRecording = 'j',

    /// Two-Dimensional Non-Projectable Graphic
    BibRecordKindTwoDimensionalNonProjectableGraphic = 'k',

    /// Computer File
    BibRecordKindComputerFile = 'm',

    /// Kit
    BibRecordKindKit = 'o',

    /// Mixed Materials
    BibRecordKindMixedMaterials = 'p',

    /// Three-Dimensional Artifact
    BibRecordKindThreeDimensionalArtifact = 'r',

    /// Manuscript LanguageMateral
    BibRecordKindManuscriptLanguageMateral = 't',

    /// An invalid record type.
    BibRecordKindUndefined = ' '
} NS_SWIFT_NAME(RecordKind);

/// Does a record with the given type represent classification information?
/// \param recordKind The type of data represented by a record.
/// \returns @c YES if a record with this type contains classification information.
extern BOOL BibRecordKindIsClassification(BibRecordKind const recordKind) NS_SWIFT_NAME(RecordKind.isClassification(_:));

/// Does a record with the given type represent bibliographic information?
/// \param recordKind The type of data represented by a record.
/// \returns @c YES if a record with this type contains bibliographic information.
extern BOOL BibRecordKindIsBibliographic(BibRecordKind const recordKind) NS_SWIFT_NAME(RecordKind.isBibliographic(_:));

extern NSString *BibRecordKindDescription(BibRecordKind const recordKind);

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

#pragma mark - Implementation Defined Values

/// An index type used to reference implementation-specific data from a record's leader.
typedef NS_CLOSED_ENUM(NSUInteger, BibImplementationDefinedValueIndex) {
    BibImplementationDefinedValueIndex07 NS_SWIFT_NAME(at07) =  7,
    BibImplementationDefinedValueIndex08 NS_SWIFT_NAME(at08) =  8,
    BibImplementationDefinedValueIndex17 NS_SWIFT_NAME(at17) = 17,
    BibImplementationDefinedValueIndex18 NS_SWIFT_NAME(at18) = 18,
    BibImplementationDefinedValueIndex19 NS_SWIFT_NAME(at19) = 19
} NS_SWIFT_NAME(LeaderImplementationDefinedValueIndex);

#pragma mark - Metadata

/// A collection of information describing the type and state of a record.
@interface BibMetadata : NSObject

/// The type of information represented by the record.
@property (nonatomic, assign, readonly) BibRecordKind kind;

/// The type of change last applied to the record in its originating database.
@property (nonatomic, assign, readonly) BibRecordStatus status;

/// Create a set of metadata for some record.
///
/// \param kind The type of information represented by some record.
- (instancetype)initWithKind:(BibRecordKind)kind status:(BibRecordStatus)status NS_DESIGNATED_INITIALIZER;

+ (instancetype)metadataWithKind:(BibRecordKind)kind status:(BibRecordStatus)status NS_SWIFT_UNAVAILABLE("Use init(kind:status:)");

- (char)implementationDefinedValueAtIndex:(BibImplementationDefinedValueIndex)index;

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

#pragma mark -

@interface BibMutableMetadata : BibMetadata

/// The type of information represented by the record.
@property (nonatomic, assign, readwrite) BibRecordKind kind;

/// The type of change last applied to the record in its originating database.
@property (nonatomic, assign, readwrite) BibRecordStatus status;

- (void)setImplementationDefinedValue:(char)value atIndex:(BibImplementationDefinedValueIndex)index;

@end

NS_ASSUME_NONNULL_END
