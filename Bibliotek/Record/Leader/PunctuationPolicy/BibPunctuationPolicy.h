//
//  BibPunctuationPolicy.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The punctuation policy used in an authority record.
///
/// The punctuation policy defines how punctuation is handled in the record's data fields.
typedef NS_ENUM(char, BibPunctuationPolicy) {
    /// No consistent punctuation policy is identified.
    ///
    /// Some data fields may include AACR2, RDA, or other standard punctuation, while other data fields may not.
    BibPunctuationPolicyNoInformationProvided = ' ',

    /// Punctuation is omitted from the record's content.
    ///
    /// No data fields contain AACR2, RDA, or other standard punctuation.
    BibPunctuationPolicyPunctuationOmitted = 'c',

    /// Punctuation is included as part of the record's content.
    ///
    /// All data fields contain AACR2, RDA, or other standard punctuation.
    BibPunctuationPolicyPunctuationIncluded = 'i',

    /// An unknown or undetermined punctuation policy.
    BibPunctuationPolicyUnknown = 'u',
} NS_SWIFT_NAME(PunctuationPolicy);

/// A human-readable description of the punctuation policy.
///
/// - parameter policy: The punctuation policy of the record.
/// - returns: A human-readable description of `policy`.
FOUNDATION_EXTERN NSString *BibPunctuationPolicyDescription(BibPunctuationPolicy policy) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
