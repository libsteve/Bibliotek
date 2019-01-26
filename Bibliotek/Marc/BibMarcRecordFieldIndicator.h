//
//  BibMarcRecordFieldIndicator.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// \brief A single-character code used within MARC records to mark its semantic meaning.
NS_SWIFT_NAME(MarcRecord.FieldIndicator)
@interface BibMarcRecordFieldIndicator : NSObject

/// A string representation of the indicator's code.
@property (nonatomic, strong, readonly) NSString *stringValue;

/// \brief An indicator is considered blank when it has no set value.
/// \discussion Some MARC 21 formats define record fields that don't use one or both of the indicator fields.
/// When one such records is created, it sets its indicator fields to this blank value.
@property (nonatomic, assign, readonly, getter=isBlank) BOOL blank;

/// Create a record field indicator from the given string value.
/// \param stringValue A string containing a single-character code.
/// \pre String codes must be exactly one lowercase alphanumeric or space character.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_SWIFT_NAME(init(stringValue:));

/// Create a record field indicator from the given string value.
/// \param stringValue A string containing a single-character code.
/// \pre String codes must be exactly one lowercase alphanumeric or space character.
+ (nullable instancetype)fieldIndicatorWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

/// Determine if this field indicator is equivalent to the given indicator.
/// \param fieldIndicator The field indicator that is being compaired with this instance for equality.
/// \returns Returns \c YES when both indicator have the same character code.
- (BOOL)isEqualToFieldIndicator:(BibMarcRecordFieldIndicator *)fieldIndicator;

/// Determine the ordered relationship between this and the given field indicator.
/// \param fieldIndicator The field indicator that this should be compared with.
/// \returns An \c NSComparisonResult is returned that denotes how these two indicators relate to each other.
/// \c NSOrderedAscending indicates that \c fieldIndicator is ordered after this indicator,
/// \c NSOrderedDescending indicates that \c fieldIndicator is ordered before this indicator,
/// and \c NSOrderedSame indicates that both indicators are equivalent.
- (NSComparisonResult)compare:(BibMarcRecordFieldIndicator *)fieldIndicator;

@end

NS_ASSUME_NONNULL_END
