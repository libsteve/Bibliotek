//
//  BibRecordFormat.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/20/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Identifies the MARC 21 record format used for data in a record.
///
/// Use ``BibRecordKind`` to get more specific information about what data is
/// contained within a record.
typedef NS_CLOSED_ENUM(char, BibRecordFormat) {
    /// The format for a bibliographic record containing information about
    /// cataloged items.
    ///
    /// Bibliographic records contain information about print, manuscript text,
    /// computer files, music, maps, visual media, and physical materials.
    ///
    /// For more information about authority records, see the Library of Congress
    /// document [MARC 21 Format for Bibliographic Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/bibliographic/bdintro.html
    BibRecordFormatBibliographic = 'b',

    /// The format for an authority record containing authoritative information.
    ///
    /// Authority records contain the authorized forms of names, subjects, and
    /// subject subdivisions that should appear in a MARC record.
    ///
    /// For more information about authority records, see the Library of Congress
    /// document [MARC 21 Format for Authority Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/authority/adintro.html
    BibRecordFormatAuthority = 'a',

    /// The format for a holdings record containing information about owned
    /// cataloged items.
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
    BibRecordFormatHoldings = 'h',

    /// The format for a classification record containing information from a
    /// classification schedule.
    ///
    /// Classification records contain information about classification numbers
    /// and the caption hierarchies associated with them.
    ///
    /// For more information about holdings records, see the Library of Congress
    /// document [MARC 21 Format for Classification Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/classification/cdintro.html
    BibRecordFormatClassification = 'c',

    /// The format for a community record containing information about
    /// non-bibliographic resources available to the community.
    ///
    /// For more information about community records, see the Library of Congress
    /// document [MARC 21 Format for Community Data: Introduction][1].
    ///
    /// [1]: https://www.loc.gov/marc/community/ciintro.html
    BibRecordFormatCommunity = 'o'
} NS_SWIFT_NAME(RecordFormat);

/// A human-readable description of the format.
///
/// - parameter format: The format used to encode information in a record.
/// - returns: A human-readable description of `format`.
FOUNDATION_EXTERN NSString *BibRecordFormatDescription(BibRecordFormat format) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
