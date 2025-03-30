//
//  BibDescriptiveCatalogingForm.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The descriptive cataloging form used in a bibliographic record.
///
/// The descriptive cataloging form identifies punctuation conventions used when creating bibliographic records.
/// It determines how information such as titles, author names, and publication details are structured and presented.
typedef NS_ENUM(char, BibDescriptiveCatalogingForm) {
    /// Non-ISBD cataloging form.
    ///
    /// This value indicates that International Standard Bibliographic Description conventions are not followed.
    /// However, it does not specify whether an alternative punctuation standard is in use. The record may follow
    /// another cataloging system with different punctuation rules, or may have no punctuation conventions at all.
    BibDescriptiveCatalogingFormNonISBD = ' ',

    /// AACR2 cataloging form.
    ///
    /// The record follows [Anglo-American Cataloguing Rules, 2nd Edition][aacr2], including ISBD punctuation.
    ///
    /// [aacr2]: https://www.librarianshipstudies.com/2018/12/anglo-american-cataloguing-rules-aacr.html
    BibDescriptiveCatalogingFormAACR2 NS_SWIFT_NAME(aacr2) = 'a',

    /// ISBD cataloging form with punctuation omitted.
    ///
    /// The record follows [International Standard Bibliographic Description][isbd] conventions,
    /// but punctuation is omitted.
    ///
    /// [isbd]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
    BibDescriptiveCatalogingFormISBDPunctuationOmitted NS_SWIFT_NAME(isbdPunctuationOmitted) = 'c',

    /// ISBD cataloging form with punctuation included.
    ///
    /// The record follows [International Standard Bibliographic Description][isbd] conventions,
    /// with punctuation included.
    ///
    /// [isbd]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
    BibDescriptiveCatalogingFormISBDPunctuationIncluded NS_SWIFT_NAME(isbdPunctuationIncluded) = 'i',

    /// Non-ISBD cataloging form with punctuation omitted.
    ///
    /// The record does not follow International Standard Bibliographic Description conventions,
    /// and punctuation is omitted.
    ///
    /// Unlike ``BibDescriptiveCatalogingForm/BibDescriptiveCatalogingFormNonISBD``, which does not specify
    /// punctuation details, this value indicates explicitly that no punctuation is applied in the record.
    BibDescriptiveCatalogingFormNonISBDPunctuationOmitted = 'n',

    /// Unknown cataloging form.
    ///
    /// The cataloging conventions used are unknown.
    BibDescriptiveCatalogingFormUnknown = 'u',
} NS_SWIFT_NAME(DescriptiveCatalogingForm);

/// A human-readable description of the descriptive cataloging form.
///
/// - parameter form: The descriptive cataloging form of the record.
/// - returns: A human-readable description of `form`.
FOUNDATION_EXTERN NSString *BibDescriptiveCatalogingFormDescription(BibDescriptiveCatalogingForm form) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
