//
//  BibBibliographicControlType.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/13/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The ruleset used to determine the information about the item that's included in the record.
typedef NS_ENUM(char, BibBibliographicControlType) {
    /// No control type specified.
    ///
    /// The record described the item using traditional bibliographic rules.
    BibBibliographicControlTypeNone = ' ',

    /// Archival control type.
    ///
    /// The record describes an item using archival rather than bibliographic rules, which can be found
    /// in field `040` subfield `$e`
    BibBibliographicControlTypeArchival = 'a'
} NS_SWIFT_NAME(BibliographicControlType);

/// A human-readable description of a bibliographic record's control type.
///
/// - parameter type: The control type of a bibliographic record.
/// - returns: A human-readable description of `type`.
FOUNDATION_EXTERN NSString *BibBibliographicControlTypeDescription(BibBibliographicControlType type) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
