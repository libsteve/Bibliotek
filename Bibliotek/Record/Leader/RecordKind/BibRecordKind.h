//
//  BibRecordKind.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>
#import <Bibliotek/BibRecordFormat.h>

NS_ASSUME_NONNULL_BEGIN

/// The type of data represented by a MARC 21 record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic,
/// classification, etc.—which each use different schemas to present their
/// information.
///
/// Use this value to determine how tags and subfield codes should be used to
/// interpret a record's content.
///
/// - note: ``BibRecordKind`` is a class cluster. Subclasses must implement
///   ``initWithByte:``, ``byteValue``, and ``recordFormat``.
NS_SWIFT_NAME(RecordKind) NS_SWIFT_SENDABLE
@interface BibRecordKind : NSObject <NSCopying>

/// The raw character value used in a record's leader to indicate the record's kind.
@property (nonatomic, assign, readonly) uint8_t byteValue NS_SWIFT_NAME(rawValue);

/// Identifies the general kind of data contained in a record.
@property (nonatomic, readonly) BibRecordFormat recordFormat;

/// Create a `BibRecordKind` instance using the given byte.
///
/// - parameter byteValue: The character value in a record's leader that indicates a record's kind.
- (nullable instancetype)initWithByte:(uint8_t)byteValue NS_SWIFT_NAME(init(rawValue:));

/// Create a ``BibRecordKind`` instance using the given byte.
///
/// - parameter byteValue: The character value in a record's leader that indicates a record's kind.
/// - returns: An instance of ``BibRecordKind`` when given a `byteValue` representing a known record kind.
+ (nullable instancetype)recordKindWithByte:(uint8_t)byteValue NS_SWIFT_UNAVAILABLE("Use init(rawValue:)");

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark -

/// The type of bibliographic information contained in a record.
///
/// Bibliographic records contain information about print, manuscript text,
/// computer files, music, maps, visual media, and physical materials.
///
/// For more information about authority records, see the Library of Congress
/// document [MARC 21 Format for Bibliographic Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
NS_SWIFT_NAME(BibRecordKind.Bibliographic) NS_SWIFT_SENDABLE
@interface BibBibliographicRecordKind : BibRecordKind
@end

/// The type of authority information contained in a record.
///
/// Authority records contain the authorized forms of names, subjects, and
/// subject subdivisions that should appear in a MARC record.
///
/// For more information about authority records, see the Library of Congress
/// document [MARC 21 Format for Authority Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/authority/adintro.html
NS_SWIFT_NAME(BibRecordKind.Authority) NS_SWIFT_SENDABLE
@interface BibAuthorityRecordKind : BibRecordKind
@end

/// The type of holdings information contained in a record.
///
/// Holdings records contain information about the specific cataloged owned,
/// controlled, or licensed in a collection. They include information about
/// the specific copies of bibliographic items in a collection, such as their
/// location, condition, and availability.
///
/// For more information about holdings records, see the Library of Congress
/// document [MARC 21 Format for Holdings Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/holdings/hdintro.html
NS_SWIFT_NAME(BibRecordKind.Holdings) NS_SWIFT_SENDABLE
@interface BibHoldingsRecordKind : BibRecordKind
@end

/// The kind of classification information contained in a record.
///
/// Classification records contain information about classification numbers
/// and the caption hierarchies associated with them.
///
/// For more information about holdings records, see the Library of Congress
/// document [MARC 21 Format for Classification Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/classification/cdintro.html
NS_SWIFT_NAME(BibRecordKind.Classification) NS_SWIFT_SENDABLE
@interface BibClassificationRecordKind : BibRecordKind
@end

/// The kind of community information contained in a record.
///
/// Community record containing information about non-bibliographic resources
/// available to a library's community.
///
/// For more information about community records, see the Library of Congress
/// document [MARC 21 Format for Community Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/community/ciintro.html
NS_SWIFT_NAME(BibRecordKind.Community) NS_SWIFT_SENDABLE
@interface BibCommunityRecordKind : BibRecordKind
@end

#pragma mark - Equality

@interface BibRecordKind (Equality)

/// Is the given record kind equivalent to the receiver?
///
/// - parameter recordKind: The record kind with which the receiver should be compared.
/// - returns: Returns `YES` if the given record kind and the receiver are equivalent.
- (BOOL)isEqualToRecordKind:(BibRecordKind *)recordKind;

@end

#pragma mark - MARC 21 Categories

@interface BibRecordKind (MARC21Categories)

/// Does a record marked with this kind represent classification information?
@property (nonatomic, readonly) BOOL isClassificationKind NS_SWIFT_NAME(isClassification);

/// Does a record marked with this kind represent bibliographic information?
@property (nonatomic, readonly) BOOL isBibliographicKind NS_SWIFT_NAME(isBibliographic);

@end

#pragma mark - MARC 21 Record Kinds

@interface BibRecordKind (MARC21RecordKinds)

/// Language Material
@property (class, nonatomic, readonly) BibBibliographicRecordKind *languageMaterial;

/// Notated Music
@property (class, nonatomic, readonly) BibBibliographicRecordKind *notatedMusic;

/// Manuscript Notated Music
@property (class, nonatomic, readonly) BibBibliographicRecordKind *manuscriptNotatedMusic;

/// Cartographic Material
@property (class, nonatomic, readonly) BibBibliographicRecordKind *cartographicMaterial;

/// Manuscript Cartographic Material
@property (class, nonatomic, readonly) BibBibliographicRecordKind *manuscriptCartographicMaterial;

/// Projected Medium
@property (class, nonatomic, readonly) BibBibliographicRecordKind *projectedMedium;

/// Non-Musical Sound Recording
@property (class, nonatomic, readonly) BibBibliographicRecordKind *nonMusicalSoundRecording;

/// Musical Sound Recording
@property (class, nonatomic, readonly) BibBibliographicRecordKind *musicalSoundRecording;

/// Two-Dimensional Non-Projectable Graphic
@property (class, nonatomic, readonly) BibBibliographicRecordKind *twoDimensionalNonProjectableGraphic;

/// Computer File
@property (class, nonatomic, readonly) BibBibliographicRecordKind *computerFile;

/// Kit
@property (class, nonatomic, readonly) BibBibliographicRecordKind *kit;

/// Mixed Materials
@property (class, nonatomic, readonly) BibBibliographicRecordKind *mixedMaterials;

/// Community Information
@property (class, nonatomic, readonly) BibCommunityRecordKind *communityInformation;

/// Three-Dimensional Artifact
@property (class, nonatomic, readonly) BibBibliographicRecordKind *threeDimensionalArtifact;

/// Manuscript Language Material
@property (class, nonatomic, readonly) BibBibliographicRecordKind *manuscriptLanguageMaterial;

/// Unknown Holdings
@property (class, nonatomic, readonly) BibHoldingsRecordKind *unknownHoldings;

/// Multipart Item Holdings
@property (class, nonatomic, readonly) BibHoldingsRecordKind *multipartItemHoldings;

/// Classification
@property (class, nonatomic, readonly) BibClassificationRecordKind *classification;

/// Single Part Item Holdings
@property (class, nonatomic, readonly) BibHoldingsRecordKind *singlePartItemHoldings;

/// Serial Item Holdings
@property (class, nonatomic, readonly) BibHoldingsRecordKind *serialItemHoldings;

/// Authority Data
@property (class, nonatomic, readonly) BibAuthorityRecordKind *authorityData;

@end

NS_ASSUME_NONNULL_END
