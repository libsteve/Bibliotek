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

#pragma mark Record Kind

/// The type of data represented by a MARC 21 record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic,
/// classification, etc.—which each use different schemas to present their
/// information.
///
/// Use this value to determine how tags and subfield codes should be used to
/// interpret a record's content.
///
/// ## Topics
///
/// ### Bibliographic Records
///
/// Bibliographic records contain information about print, manuscript text,
/// computer files, music, maps, visual media, and physical materials.
///
/// - ``BibRecordKindLanguageMaterial``
/// - ``BibRecordKindNotatedMusic``
/// - ``BibRecordKindManuscriptNotatedMusic``
/// - ``BibRecordKindCartographicMaterial``
/// - ``BibRecordKindManuscriptCartographicMaterial``
/// - ``BibRecordKindProjectedMedium``
/// - ``BibRecordKindNonMusicalSoundRecording``
/// - ``BibRecordKindMusicalSoundRecording``
/// - ``BibRecordKindTwoDimensionalNonProjectableGraphic``
/// - ``BibRecordKindComputerFile``
/// - ``BibRecordKindKit``
/// - ``BibRecordKindMixedMaterials``
/// - ``BibRecordKindThreeDimensionalArtifact``
/// - ``BibRecordKindManuscriptLanguageMaterial``
///
/// ### Community Records
///
/// Community records contain information about non-bibliographic resources
/// available to a library's community.
///
/// - ``BibRecordKindCommunityInformation``
///
/// ### Holdings Records
///
/// Holdings records contain information about the specific cataloged owned,
/// controlled, or licensed in a collection. They include information about
/// the specific copies of bibliographic items in a collection, such as their
/// location, condition, and availability.
///
/// - ``BibRecordKindUnknownHoldings``
/// - ``BibRecordKindMultipartItemHoldings``
/// - ``BibRecordKindSinglePartItemHoldings``
/// - ``BibRecordKindSerialItemHoldings``
///
/// ### Classification Records
///
/// Classification records contain information about classification numbers
/// and the caption hierarchies associated with them.
///
/// - ``BibRecordKindClassification``
///
/// ### Authority Records
///
/// Authority records contain the authorized forms of names, subjects, and
/// subject subdivisions that should appear in a MARC record.
///
/// - ``BibRecordKindAuthorityData``
///
/// ### RecordKind Subtypes
///
/// - ``BibBibliographicRecordKind``
/// - ``BibCommunityRecordKind``
/// - ``BibHoldingsRecordKind``
/// - ``BibClassificationRecordKind``
/// - ``BibAuthorityRecordKind``
typedef NS_ENUM(char, BibRecordKind) {
    /// Language Material
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindLanguageMaterial = 'a',

    /// Notated Music
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindNotatedMusic = 'c',

    /// Manuscript Notated Music
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
   BibRecordKindManuscriptNotatedMusic = 'd',

    /// Cartographic Material
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
   BibRecordKindCartographicMaterial = 'e',

    /// Manuscript Cartographic Material
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindManuscriptCartographicMaterial = 'f',

    /// Projected Medium
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindProjectedMedium = 'g',

    /// Non-Musical Sound Recording
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindNonMusicalSoundRecording = 'i',

    /// Musical Sound Recording
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindMusicalSoundRecording = 'j',

    /// Two-Dimensional Non-Projectable Graphic
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindTwoDimensionalNonProjectableGraphic = 'k',

    /// Computer File
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindComputerFile = 'm',

    /// Kit
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindKit = 'o',

    /// Mixed Materials
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindMixedMaterials = 'p',

    /// Community Information
    ///
    /// Community record containing information about non-bibliographic resources
    /// available to a library's community.
    ///
    /// For more information about community records, see the Library of Congress
    /// document [MARC 21 Format for Community Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/community/ciintro.html
    BibRecordKindCommunityInformation = 'q',

    /// Three-Dimensional Artifact
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindThreeDimensionalArtifact = 'r',

    /// Manuscript Language Material
    ///
    /// For more information about bibliographic records, see the Library of
    /// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordKindManuscriptLanguageMaterial = 't',

    /// Unknown Holdings
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
    BibRecordKindUnknownHoldings = 'u',

    /// Multipart Item Holdings
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
    BibRecordKindMultipartItemHoldings = 'v',

    /// Classification
    ///
    /// Classification records contain information about classification numbers
    /// and the caption hierarchies associated with them.
    ///
    /// For more information about classification records, see the Library of
    /// Congress document [MARC 21 Format for Classification Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/classification/cdintro.html
    BibRecordKindClassification = 'w',

    /// Single Part Item Holdings
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
    BibRecordKindSinglePartItemHoldings = 'x',

    /// Serial Item Holdings
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
    BibRecordKindSerialItemHoldings = 'y',

    /// Authority Data
    ///
    /// Authority records contain the authorized forms of names, subjects, and
    /// subject subdivisions that should appear in a MARC record.
    ///
    /// For more information about authority records, see the Library of Congress
    /// document [MARC 21 Format for Authority Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/authority/adintro.html
    BibRecordKindAuthorityData = 'z'
} NS_SWIFT_NAME(RecordKind);

#pragma mark - Bibliographic Record Kind

/// The type of bibliographic information contained in a record.
///
/// Bibliographic records contain information about print, manuscript text,
/// computer files, music, maps, visual media, and physical materials.
///
/// For more information about bibliographic records, see the Library of
/// Congress document [MARC 21 Format for Bibliographic Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
typedef NS_ENUM(char, BibBibliographicRecordKind) {
    /// Language Material
    BibBibliographicRecordKindLanguageMaterial = BibRecordKindLanguageMaterial,

    /// Notated Music
    BibBibliographicRecordKindNotatedMusic = BibRecordKindNotatedMusic,

    /// Manuscript Notated Music
    BibBibliographicRecordKindManuscriptNotatedMusic = BibRecordKindManuscriptNotatedMusic,

    /// Cartographic Material
    BibBibliographicRecordKindCartographicMaterial = BibRecordKindCartographicMaterial,

    /// Manuscript Cartographic Material
    BibBibliographicRecordKindManuscriptCartographicMaterial = BibRecordKindManuscriptCartographicMaterial,

    /// Projected Medium
    BibBibliographicRecordKindProjectedMedium = BibRecordKindProjectedMedium,

    /// Non-Musical Sound Recording
    BibBibliographicRecordKindNonMusicalSoundRecording = BibRecordKindNonMusicalSoundRecording,

    /// Musical Sound Recording
    BibBibliographicRecordKindMusicalSoundRecording = BibRecordKindMusicalSoundRecording,

    /// Two-Dimensional Non-Projectable Graphic
    BibBibliographicRecordKindTwoDimensionalNonProjectableGraphic = BibRecordKindTwoDimensionalNonProjectableGraphic,

    /// Computer File
    BibBibliographicRecordKindComputerFile = BibRecordKindComputerFile,

    /// Kit
    BibBibliographicRecordKindKit = BibRecordKindKit,

    /// Mixed Materials
    BibBibliographicRecordKindMixedMaterials = BibRecordKindMixedMaterials,

    /// Three-Dimensional Artifact
    BibBibliographicRecordKindThreeDimensionalArtifact = BibRecordKindThreeDimensionalArtifact,

    /// Manuscript Language Material
    BibBibliographicRecordKindManuscriptLanguageMaterial = BibRecordKindManuscriptLanguageMaterial
} NS_SWIFT_NAME(BibRecordKind.Bibliographic);

#pragma mark - Community Record Kind

/// The kind of community information contained in a record.
///
/// Community record containing information about non-bibliographic resources
/// available to a library's community.
///
/// For more information about community records, see the Library of Congress
/// document [MARC 21 Format for Community Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/community/ciintro.html
typedef NS_ENUM(char, BibCommunityRecordKind) {
    /// Community Information
    BibCommunityRecordKindCommunityInformation = BibRecordKindCommunityInformation
} NS_SWIFT_NAME(BibRecordKind.Community);

#pragma mark - Holdings Record Kind

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
typedef NS_ENUM(char, BibHoldingsRecordKind) {
    /// Unknown Holdings
    BibHoldingsRecordKindUnknownHoldings = BibRecordKindUnknownHoldings,

    /// Multipart Item Holdings
    BibHoldingsRecordKindMultipartItemHoldings = BibRecordKindMultipartItemHoldings,

    /// Single Part Item Holdings
    BibHoldingsRecordKindSinglePartItemHoldings = BibRecordKindSinglePartItemHoldings,

    /// Serial Item Holdings
    BibHoldingsRecordKindSerialItemHoldings = BibRecordKindSerialItemHoldings
} NS_SWIFT_NAME(BibRecordKind.Holdings);

#pragma mark - Classification Record Kind

/// The kind of classification information contained in a record.
///
/// Classification records contain information about classification numbers
/// and the caption hierarchies associated with them.
///
/// For more information about classification records, see the Library of
/// Congress document [MARC 21 Format for Classification Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/classification/cdintro.html
typedef NS_ENUM(char, BibClassificationRecordKind) {
    /// Classification
    BibClassificationRecordKindClassification = BibRecordKindClassification
} NS_SWIFT_NAME(BibRecordKind.Classification);

#pragma mark - Authority Record Kind

/// The type of authority information contained in a record.
///
/// Authority records contain the authorized forms of names, subjects, and
/// subject subdivisions that should appear in a MARC record.
///
/// For more information about authority records, see the Library of Congress
/// document [MARC 21 Format for Authority Data: Introduction][1].
///
/// [1]: https://www.loc.gov/marc/authority/adintro.html
typedef NS_ENUM(char, BibAuthorityRecordKind) {
    /// Authority Data
    BibAuthorityRecordKindAuthorityData = BibRecordKindAuthorityData
} NS_SWIFT_NAME(BibRecordKind.Authority);

#pragma mark - Description

FOUNDATION_EXTERN BibRecordFormat BibRecordKindFormat(BibRecordKind kind) NS_REFINED_FOR_SWIFT;

FOUNDATION_EXTERN NSString *BibRecordKindDescription(BibRecordKind kind) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
