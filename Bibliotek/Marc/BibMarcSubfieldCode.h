//
//  BibMarcSubfieldCode.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcSubfield.Code)
@interface BibMarcSubfieldCode : NSObject <NSSecureCoding>

/// A string representation of the subfield code.
@property (nonatomic, strong, readonly) NSString *stringValue NS_SWIFT_NAME(rawValue);

/// Create a subfield code given string value.
/// \param stringValue A string containing a single-character code.
/// \pre String codes must be exactly one lowercase alphanumeric or space character.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_SWIFT_NAME(init(rawValue:));

/// Create a subfield code from the given string value.
/// \param stringValue A string containing a single-character code.
/// \pre String codes must be exactly one lowercase alphanumeric or space character.
+ (nullable instancetype)subfieldCodeWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

/// Determine if this subfield code is equivalent to the given code.
/// \param subfieldCode The field indicator that is being compaired with this instance for equality.
/// \returns Returns \c YES when both subfield codes have the same character value.
- (BOOL)isEqualToSubfieldCode:(BibMarcSubfieldCode *)subfieldCode;

/// Determine the ordered relationship between this and the given subfield code.
/// \param subfieldCode The subfield code that this should be compared with.
/// \returns An \c NSComparisonResult is returned that denotes how these two subfield codes relate to each other.
/// \c NSOrderedAscending indicates that \c subfieldCode is ordered after this subfield code,
/// \c NSOrderedDescending indicates that \c subfieldCode is ordered before this subfield code,
/// and \c NSOrderedSame indicates that both subfield codes are equivalent.
- (NSComparisonResult)compare:(BibMarcSubfieldCode *)subfieldCode;
@end

NS_ASSUME_NONNULL_END
