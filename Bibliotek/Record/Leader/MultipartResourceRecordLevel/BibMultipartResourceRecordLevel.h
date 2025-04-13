//
//  BibMultipartResourceRecordLevel.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/13/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Indicates the bibliographic level of a record for a multipart resource.
///
/// This value is used when cataloging multipart items (such as multi-volume works or serials)
/// to specify whether the record describes the whole set or an individual part, and whether
/// that part has an independent or dependent title.
typedef NS_ENUM(char, BibMultipartResourceRecordLevel) {
    /// The record level is not specified or not applicable.
    BibMultipartResourceRecordLevelNotSpecifiedOrNotApplicable = ' ',

    /// The record describes the entire set of a multipart resource.
    BibMultipartResourceRecordLevelSet = 'a',

    /// The record describes a part of a multipart resource that has its own title independent
    /// of the set.
    BibMultipartResourceRecordLevelPartWithIndependentTitle = 'b',

    /// The record describes a part of a multipart resource that has a title that relies on the
    /// set for identification.
    BibMultipartResourceRecordLevelPartWithDependentTitle = 'c'
} NS_SWIFT_NAME(MultipartResourceRecordLevel);

/// A human-readable description of the multipart resource record level.
///
/// - parameter level: The multipart resource record level of a bibliographic record.
/// - returns: A human-readable description of `level`.
FOUNDATION_EXTERN NSString *BibMultipartResourceRecordLevelDescription(BibMultipartResourceRecordLevel level) NS_REFINED_FOR_SWIFT;
