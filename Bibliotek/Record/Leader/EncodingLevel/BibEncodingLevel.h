//
//  BibEncodingLevel.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/5/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The level of completeness of information in a MARC 21 record.
///
/// "Completeness" is how thoroughly a MARC record captures the relevant descriptive information
/// about the resource it represents, according to cataloging standards.
///
/// This is a generic type representing encoding levels across different MARC 21 formats. It's
/// used as the underlying type for more specific enumerations that describe the completeness
/// and detail of information in MARC 21 records.
///
/// ``BibEncodingLevel`` values must be either an ASCII space (`0x20`), an ASCII digit (`0x30`
/// through `0x39`), or an ASCII lowercase letter (`0x61` through `0x7A`). All other values of
/// this type should be treated as a data validation or programming error.
///
/// Cast values of this type to the appropriate enumeration for the record's ``BibLeader/recordKind``.
/// In Swift, you can use the properties ``EncodingLevel/bibliographic``, ``EncodingLevel/authority``,
/// ``EncodingLevel/holdings``, and ``EncodingLevel/classification``.
///
/// ## Topics
///
/// ### Enumerations
///
/// - ``BibBibliographicEncodingLevel``
/// - ``BibAuthorityEncodingLevel``
/// - ``BibHoldingsEncodingLevel``
/// - ``BibClassificationEncodingLevel``
typedef char BibEncodingLevel NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(EncodingLevel);

#pragma mark Bibliographic Encoding Level

/// The level of completeness of information in a bibliographic record.
///
/// "Completeness" is how thoroughly a MARC record captures the relevant descriptive information
/// about the resource it represents, according to cataloging standards.
///
/// ## Topics
///
/// ### Enumeration Cases
///
/// - ``BibBibliographicEncodingLevelFull``
/// - ``BibBibliographicEncodingLevelFullWithMaterialNotExamined``
/// - ``BibBibliographicEncodingLevelLessThanFullWithMaterialNotExamined``
/// - ``BibBibliographicEncodingLevelAbbreviated``
/// - ``BibBibliographicEncodingLevelCore``
/// - ``BibBibliographicEncodingLevelPartial``
/// - ``BibBibliographicEncodingLevelMinimal``
/// - ``BibBibliographicEncodingLevelPrepublication``
/// - ``BibBibliographicEncodingLevelUnknown``
/// - ``BibBibliographicEncodingLevelNotApplicable``
///
/// ### Functions
///
/// - ``BibBibliographicEncodingLevelDescription``
typedef NS_ENUM(BibEncodingLevel, BibBibliographicEncodingLevel) {
    /// A complete record with comprehensive cataloging information, created after directly
    /// examining the represented material.
    BibBibliographicEncodingLevelFull = ' ',

    /// A complete record with comprehensive cataloging information, created without directly
    /// examining the material.
    ///
    /// Use this encoding level when creating a record from a description of the material, such
    /// as a preexisting full record that was created after a direct examination of the material.
    BibBibliographicEncodingLevelFullWithMaterialNotExamined = '1',

    /// A record whose encoding level lies somewhere between minimal and full, created without
    /// directly examining the material.
    BibBibliographicEncodingLevelLessThanFullWithMaterialNotExamined = '2',

    /// A record that does not meet the threshold for minimal cataloging standards.
    ///
    /// Such records are brief and often lack essential details.
    BibBibliographicEncodingLevelAbbreviated = '3',

    /// A record that has a standard level of cataloging information, focusing on essential elements.
    ///
    /// Such records meet the core standards for completeness.
    BibBibliographicEncodingLevelCore = '4',

    /// A record with preliminary cataloging information, pending further revision.
    ///
    /// Such records are not considered "final" by the creating agency.
    BibBibliographicEncodingLevelPartial = '5',

    /// A record that meets the U.S. National Level Bibliographic Record minimal level cataloging
    /// specifications.
    ///
    /// Such records are considered "final" by the creating agency.
    ///
    /// See [National Level and Minimal Level Record Requirements][nlr] for more information about
    /// the U.S. National Level Bibliographic Record minimal level cataloging specifications.
    ///
    /// [nlr]: https://www.loc.gov/marc/bibliographic/nlr/
    BibBibliographicEncodingLevelMinimal = '7',

    /// A record created before the material's publication.
    ///
    /// This includes records created through cataloging in publication programs.
    BibBibliographicEncodingLevelPrepublication = '8',

    /// A record with a "local" non-standard encoding level.
    ///
    /// This encoding level is used by agencies sending or receiving records with non-standard encoding
    /// levels. New or updated records would not use with this encoding level.
    ///
    /// Dublin core originated records would use this encoding level.
    BibBibliographicEncodingLevelUnknown = 'u',

    /// A record where the idea of an encoding level does not apply.
    BibBibliographicEncodingLevelNotApplicable = 'z'
} NS_SWIFT_NAME(BibliographicEncodingLevel);

/// A human-readable description of the bibliographic encoding level.
///
/// - parameter level: The bibliographic encoding level of the record.
/// - returns: A human-readable description of `level`.
FOUNDATION_EXTERN NSString *BibBibliographicEncodingLevelDescription(BibBibliographicEncodingLevel level) NS_REFINED_FOR_SWIFT;

#pragma mark - Authority Encoding Level

/// The level of completeness for information in an authority record.
///
/// "Completeness" is how thoroughly a MARC record captures the relevant descriptive information
/// about the resource it represents, according to cataloging standards.
///
/// This encoding level indicates how complete an authority record is with regards to national-level
/// record requirements for content and content designation.
///
/// ## Topics
///
/// ### Enumeration Cases
///
/// - ``BibAuthorityEncodingLevelComplete``
/// - ``BibAuthorityEncodingLevelIncomplete``
///
/// ### Functions
///
/// - ``BibAuthorityEncodingLevelDescription``
typedef NS_ENUM(BibEncodingLevel, BibAuthorityEncodingLevel) {
    /// The record contains all information to meet national-level record requirements for content and
    /// content designation.
    BibAuthorityEncodingLevelComplete = 'n',

    /// The record is missing information, and may or may not meet national-level record requirements.
    BibAuthorityEncodingLevelIncomplete = 'o'
} NS_SWIFT_NAME(AuthorityEncodingLevel);

/// A human-readable description of the encoding level.
///
/// - parameter level: The encoding level of an authority record.
/// - returns: A human-readable description of `level`.
FOUNDATION_EXTERN NSString *BibAuthorityEncodingLevelDescription(BibAuthorityEncodingLevel level) NS_REFINED_FOR_SWIFT;

#pragma mark - Holdings Encoding Level

/// The level of completeness for information in a holdings record.
///
/// "Completeness" is how thoroughly a MARC record captures the relevant descriptive information
/// about the resource it represents, according to cataloging standards.
///
/// See [Holdings Statements for Bibliographic Items (ANSI/NISO Z39.71)][Z39.71] for information on levels 1 through 4.
///
/// [Z39.71]: https://www.niso.org/publications/z3971-2006-r2011
///
/// ## Topics
///
/// ### Enumeration Cases
///
/// - ``BibHoldingsEncodingLevel1``
/// - ``BibHoldingsEncodingLevel2``
/// - ``BibHoldingsEncodingLevel3``
/// - ``BibHoldingsEncodingLevel4``
/// - ``BibHoldingsEncodingLevel4WithPieceDesignation``
/// - ``BibHoldingsEncodingLevelMixed``
/// - ``BibHoldingsEncodingLevelUnknown``
/// - ``BibHoldingsEncodingLevelOther``
///
/// ### Functions
///
/// - ``BibHoldingsEncodingLevelDescription``
typedef NS_ENUM(BibEncodingLevel, BibHoldingsEncodingLevel) {
    /// A record provides a basic holdings statement, including at least the location and item identifier.
    ///
    /// Item identifiers can appear in one of the following fields:
    /// - [`004` Control Number for Related Bibliographic Record][004]
    /// - [`010` Library of Congress Control Number][010]
    /// - [`014` Linkage Number][014]
    /// - [`020` International Standard Book Number (ISBN)][020]
    /// - [`022` International Standard Serial Number (ISSN)][022]
    /// - [`024` Other Standard Identifier][024]
    /// - [`027` Standard Technical Report Number][027]
    /// - [`030` CODEN Designation][030]
    ///
    /// Location identifiers are contained in subfield ‡a of field [`852` (Location)][852].
    ///
    /// [004]: https://www.loc.gov/marc/holdings/hd004.html
    /// [010]: https://www.loc.gov/marc/holdings/hd010.html
    /// [014]: https://www.loc.gov/marc/holdings/hd014.html
    /// [020]: https://www.loc.gov/marc/holdings/hd020.html
    /// [022]: https://www.loc.gov/marc/holdings/hd022.html
    /// [024]: https://www.loc.gov/marc/holdings/hd024.html
    /// [027]: https://www.loc.gov/marc/holdings/hd027.html
    /// [030]: https://www.loc.gov/marc/holdings/hd030.html
    /// [852]: https://www.loc.gov/marc/holdings/hd852.html
    BibHoldingsEncodingLevel1 NS_SWIFT_NAME(level1) = '1',

    /// A holdings record conforms to level 2 of [Holdings Statements for Bibliographic Items (ANSI/NISO Z39.71)][Z39.71].
    ///
    /// In addition to the requirements of ``BibHoldingsEncodingLevel/BibHoldingsEncodingLevel1``, level 2 holdings records
    /// always contain values in the control field [`008` (Fixed-Length Data Elements)][008] at the following character indexes:
    /// - `06` Receipt, acquisition, or access status
    /// - `12` General retention policy
    /// - `16` Completeness
    /// - `26...31` Date of report
    ///
    /// Level 2 holdings records can also contain values in the control field [`007` (Physical Description Fixed Field)][007]
    /// at the following character indexes:
    /// - `00` Category of material
    /// - `01` Specific material designation
    ///
    /// [Z39.71]: https://www.niso.org/publications/z3971-2006-r2011
    /// [008]: https://www.loc.gov/marc/holdings/hd008.html
    /// [007]: https://www.loc.gov/marc/holdings/hd007.html
    BibHoldingsEncodingLevel2 NS_SWIFT_NAME(level2) = '2',

    /// A record provides a summary holdings statement that typically lists the overall span of volumes or issues held, but does not
    /// include detailed information about individual parts.
    ///
    /// In addition to the requirements of ``BibHoldingsEncodingLevel/BibHoldingsEncodingLevel2``, level 3 holdings records always
    /// contain summary holdings information for the first level of enumeration and chronology in at least one of the following fields:
    /// - [`853` Captions and Pattern-Basic Bibliographic Unit][853]
    /// - [`854` Captions and Pattern-Supplementary Material][854]
    /// - [`855` Captions and Pattern-Indexes][855]
    /// - [`863` Enumeration and Chronology-Basic Bibliographic Unit][863]
    /// - [`864` Enumeration and Chronology-Supplementary Material][864]
    /// - [`865` Enumeration and Chronology-Indexes][865]
    /// - [`866` Textual Holdings-Basic Bibliographic Unit][866]
    /// - [`867` Textual Holdings-Supplementary Material][867]
    /// - [`868` Textual Holdings-Indexes][868]
    ///
    /// [853]: https://www.loc.gov/marc/holdings/hd853.html
    /// [854]: https://www.loc.gov/marc/holdings/hd854.html
    /// [855]: https://www.loc.gov/marc/holdings/hd855.html
    /// [863]: https://www.loc.gov/marc/holdings/hd863.html
    /// [864]: https://www.loc.gov/marc/holdings/hd864.html
    /// [865]: https://www.loc.gov/marc/holdings/hd865.html
    /// [866]: https://www.loc.gov/marc/holdings/hd866.html
    /// [867]: https://www.loc.gov/marc/holdings/hd867.html
    /// [868]: https://www.loc.gov/marc/holdings/hd868.html
    BibHoldingsEncodingLevel3 NS_SWIFT_NAME(level3) = '3',

    /// A record provides a comprehensive, detailed holdings statement, including specific enumeration and chronology of each part held.
    ///
    /// "Enumeration" in this case refers to the numbering used for the part, such as volume, issue, or part number.
    /// "Chronology" refers to the dating information for the part, such as the year, month, and/or day.
    ///
    /// In addition to the requirements of ``BibHoldingsEncodingLevel/BibHoldingsEncodingLevel2``, level 4 holdings records always
    /// contain detailed holdings information for all levels of enumeration and chronology in at least one of the following fields:
    /// - [`853` Captions and Pattern-Basic Bibliographic Unit][853]
    /// - [`854` Captions and Pattern-Supplementary Material][854]
    /// - [`855` Captions and Pattern-Indexes][855]
    /// - [`863` Enumeration and Chronology-Basic Bibliographic Unit][863]
    /// - [`864` Enumeration and Chronology-Supplementary Material][864]
    /// - [`865` Enumeration and Chronology-Indexes][865]
    /// - [`866` Textual Holdings-Basic Bibliographic Unit][866]
    /// - [`867` Textual Holdings-Supplementary Material][867]
    /// - [`868` Textual Holdings-Indexes][868]
    ///
    /// [853]: https://www.loc.gov/marc/holdings/hd853.html
    /// [854]: https://www.loc.gov/marc/holdings/hd854.html
    /// [855]: https://www.loc.gov/marc/holdings/hd855.html
    /// [863]: https://www.loc.gov/marc/holdings/hd863.html
    /// [864]: https://www.loc.gov/marc/holdings/hd864.html
    /// [865]: https://www.loc.gov/marc/holdings/hd865.html
    /// [866]: https://www.loc.gov/marc/holdings/hd866.html
    /// [867]: https://www.loc.gov/marc/holdings/hd867.html
    /// [868]: https://www.loc.gov/marc/holdings/hd868.html
    BibHoldingsEncodingLevel4 NS_SWIFT_NAME(level4) = '4',

    /// A record provides a comprehensive, detailed holdings statement, including specific enumeration and chronology of each part held,
    /// and its piece designation.
    ///
    /// "Enumeration" in this case refers to the numbering used for the part, such as volume, issue, or part number.
    /// "Chronology" refers to the dating information for the part, such as the year, month, and/or day.
    ///
    /// In addition to the requirements of ``BibHoldingsEncodingLevel/BibHoldingsEncodingLevel2``, level 4 holdings records always
    /// contain detailed holdings information for all levels of enumeration and chronology in at least one of the following fields:
    /// - [`853` Captions and Pattern-Basic Bibliographic Unit][853]
    /// - [`854` Captions and Pattern-Supplementary Material][854]
    /// - [`855` Captions and Pattern-Indexes][855]
    /// - [`863` Enumeration and Chronology-Basic Bibliographic Unit][863]
    /// - [`864` Enumeration and Chronology-Supplementary Material][864]
    /// - [`865` Enumeration and Chronology-Indexes][865]
    /// - [`866` Textual Holdings-Basic Bibliographic Unit][866]
    /// - [`867` Textual Holdings-Supplementary Material][867]
    /// - [`868` Textual Holdings-Indexes][868]
    ///
    /// The piece designation, such as a barcode, accession number, or copy number, is included in subfield ‡p (Piece designation) of
    /// one of the following fields:
    /// - [`852` Location][852]
    /// - [`863` Enumeration and Chronology-Basic Bibliographic Unit][863]
    /// - [`864` Enumeration and Chronology-Supplementary Material][864]
    /// - [`865` Enumeration and Chronology-Indexes][865]
    /// - [`876` Item Information-Basic Bibliographic Unit][876]
    /// - [`877` Item Information-Supplementary Material][877]
    /// - [`878` Item Information-Indexes][878]
    ///
    /// Alternatively, the piece designation can be included in subfield ‡a (Textual holdings) of one of the following fields:
    /// - [`866` Textual Holdings-Basic Bibliographic Unit][866]
    /// - [`867` Textual Holdings-Supplementary Material][867]
    /// - [`868` Textual Holdings-Indexes][868]
    ///
    /// [852]: https://www.loc.gov/marc/holdings/hd852.html
    /// [853]: https://www.loc.gov/marc/holdings/hd853.html
    /// [854]: https://www.loc.gov/marc/holdings/hd854.html
    /// [855]: https://www.loc.gov/marc/holdings/hd855.html
    /// [863]: https://www.loc.gov/marc/holdings/hd863.html
    /// [864]: https://www.loc.gov/marc/holdings/hd864.html
    /// [865]: https://www.loc.gov/marc/holdings/hd865.html
    /// [866]: https://www.loc.gov/marc/holdings/hd866.html
    /// [867]: https://www.loc.gov/marc/holdings/hd867.html
    /// [868]: https://www.loc.gov/marc/holdings/hd868.html
    /// [876]: https://www.loc.gov/marc/holdings/hd876.html
    /// [877]: https://www.loc.gov/marc/holdings/hd877.html
    /// [878]: https://www.loc.gov/marc/holdings/hd878.html
    BibHoldingsEncodingLevel4WithPieceDesignation NS_SWIFT_NAME(level4WithPieceDesignation) = '5',

    /// A holdings record includes a mixture of different encoding levels.
    ///
    /// Mixed-level encoding may occur when one part of the holdings conforms to a detailed
    /// level (such as level 4), while another part is summarized or abbreviated (like level 3 or 2).
    /// This code is used when the record cannot be described by a single encoding level.
    ///
    /// The first indicator (Field encoding level) indicates the level for the data in each of the
    /// following fields:
    /// - [`863` Enumeration and Chronology-Basic Bibliographic Unit][863]
    /// - [`864` Enumeration and Chronology-Supplementary Material][864]
    /// - [`865` Enumeration and Chronology-Indexes][865]
    /// - [`866` Textual Holdings-Basic Bibliographic Unit][866]
    /// - [`867` Textual Holdings-Supplementary Material][867]
    /// - [`868` Textual Holdings-Indexes][868]
    ///
    /// [863]: https://www.loc.gov/marc/holdings/hd863.html
    /// [864]: https://www.loc.gov/marc/holdings/hd864.html
    /// [865]: https://www.loc.gov/marc/holdings/hd865.html
    /// [866]: https://www.loc.gov/marc/holdings/hd866.html
    /// [867]: https://www.loc.gov/marc/holdings/hd867.html
    /// [868]: https://www.loc.gov/marc/holdings/hd868.html
    BibHoldingsEncodingLevelMixed NS_SWIFT_NAME(mixed) = 'm',

    /// The encoding level of the holdings record is not known.
    ///
    /// This code is used when there is no information available about the record’s completeness
    /// or adherence to any specific holdings standard.
    BibHoldingsEncodingLevelUnknown NS_SWIFT_NAME(unknown) = 'u',

    /// The encoding level of the holdings record does not fit any defined category.
    ///
    /// Use this code for encoding levels that are not covered by levels 1 through 5, mixed, or unknown.
    /// This might apply to records created under a local or experimental schema.
    BibHoldingsEncodingLevelOther NS_SWIFT_NAME(other) = 'z'
} NS_SWIFT_NAME(HoldingsEncodingLevel);

/// A human-readable description of the encoding level.
///
/// - parameter level: The encoding level of a holdings record.
/// - returns: A human-readable description of `level`.
FOUNDATION_EXTERN NSString *BibHoldingsEncodingLevelDescription(BibHoldingsEncodingLevel level) NS_REFINED_FOR_SWIFT;

#pragma mark - Classification Encoding Level

/// The level of completeness for information in a classification record.
///
/// "Completeness" is how thoroughly a MARC record captures the relevant descriptive information
/// about the resource it represents, according to cataloging standards.
///
/// ## Topics
///
/// ### Enumeration Cases
///
/// - ``BibClassificationEncodingLevelComplete``
/// - ``BibClassificationEncodingLevelIncomplete``
///
/// ### Functions
///
/// - ``BibClassificationEncodingLevelDescription``
typedef NS_ENUM(BibEncodingLevel, BibClassificationEncodingLevel) {
    /// A record contains all the information necessary to be considered complete.
    BibClassificationEncodingLevelComplete = 'n',

    /// A record doesn't contain all the information for a complete record.
    ///
    /// This is used for new records that are incomplete, and for records that are being updated.
    /// Records can be identified as being updated when the value in field `008` at index 10 is "b".
    BibClassificationEncodingLevelIncomplete = 'o'
} NS_SWIFT_NAME(ClassificationEncodingLevel);

/// A human-readable description of the encoding level.
///
/// - parameter level: The encoding level of a classification record.
/// - returns: A human-readable description of `level`.
FOUNDATION_EXTERN NSString *BibClassificationEncodingLevelDescription(BibClassificationEncodingLevel level) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END


