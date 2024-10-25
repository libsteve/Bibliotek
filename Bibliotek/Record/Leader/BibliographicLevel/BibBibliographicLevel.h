//
//  BibBibliographicLevel.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/13/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
FOUNDATION_EXTERN NSString *BibBibliographicLevelDescription(BibBibliographicLevel level) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
