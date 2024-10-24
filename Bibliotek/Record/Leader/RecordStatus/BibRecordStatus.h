//
//  BibRecordStatus.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/12/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The type of change last applied to a record in its originating database.
typedef NS_ENUM(uint8_t, BibRecordStatus) {
    BibRecordStatusIncreaseInEncodingLevel  = 'a',

    /// The record has been edited with new information.
    BibRecordStatusRevised                  = 'c',

    /// The record has been deleted from the database.
    BibRecordStatusDeleted                  = 'd',

    /// The record is a new entry in the database.
    BibRecordStatusNew                      = 'n',

    BibRecordStatusObsolete                 = 'o',

    BibRecordStatusIncreaseInEncodingLevelFromPrePublication = 'p',

    BibRecordStatusDeletedSplittingHeading  = 's',

    BibRecordStatusDeletedReplacingHeading  = 'x',
} NS_SWIFT_NAME(RecordStatus);

/// A human-readable description of the status.
///
/// - parameter status: The type of change last applied to a record in its originating database.
/// - returns: A human-readable description of `status`.
extern NSString *BibRecordStatusDescription(BibRecordStatus status) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
