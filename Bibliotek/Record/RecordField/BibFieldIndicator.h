//
//  BibFieldIndicator.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/7/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A metadata value assigning some semantic meaning to a data field.
///
/// Indicators are backed by an ASCII space character, an ASCII lowercase letter, or an ASCII number.
/// Indicators are genally considered "blank" or "empty" when backed by an ASCII space character, but that value
/// may also have some meaning depending on the semantic definition of the field.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
///
/// \note It is \b not safe to subclass \c BibFieldIndicator
NS_SWIFT_NAME(FieldIndicator)
__attribute__((objc_subclassing_restricted))
@interface BibFieldIndicator : NSObject <NSCopying, NSSecureCoding>

/// The ASCII value backing this indicator object.
@property (nonatomic, readonly, assign) char rawValue;

/// An indicator backed by an ASCII space character.
///
/// "Blank" indicators generally represent the absence of an assigned value, but may also be considered ameaningful
/// meaningful depending on the semantic definition of the field.
@property (class, nonatomic, readonly) BibFieldIndicator *blank;

/// Create an indicator with the given raw value.
/// \param rawValue An ASCII space, lowercase letter, or number.
/// \returns An indicator object with some semantic metadata meaning about a data field.
/// \note This method will throw an out-of-bounds exception for invalid indicator characters.
- (instancetype)initWithRawValue:(char)rawValue;

/// Create an indicator with the given raw value.
/// \param value An ASCII space, lowercase letter, or number.
/// \returns An indicator object with some semantic metadata meaning about a data field.
/// \note This method will throw an out-of-bounds exception for invalid indicator characters.
- (instancetype)initWithValue:(char)value NS_SWIFT_NAME(init(_:));

/// Create an indicator with the given raw value.
/// \param value An ASCII space, lowercase letter, or number.
/// \returns An indicator object with some semantic metadata meaning about a data field.
/// \note This method will throw an out-of-bounds exception for invalid indicator characters.
+ (instancetype)indicatorWithValue:(char)value NS_SWIFT_UNAVAILABLE("Use init(_:)");

/// Create an indicator with the given raw value.
/// \param rawValue An ASCII space, lowercase letter, or number.
/// \returns An indicator object with some semantic metadata meaning about a data field.
/// \note This method will throw an out-of-bounds exception for invalid indicator characters.
+ (instancetype)indicatorWithRawValue:(char)rawValue NS_SWIFT_UNAVAILABLE("Use init(rawValue:)");

/// Use Objective-C subscript syntax to make an indicator value.
///
/// \code
/// BibIndicator *ind = [BibIndicator self]['a'];
/// \endcode
///
/// \param rawValue The ASCII space, lowercase letter, or number.
/// \returns An indicator object with some semantic metadata meaning about a data field.
+ (instancetype)objectAtIndexedSubscript:(char)rawValue NS_SWIFT_UNAVAILABLE("Use literal syntax");

/// Determine whether or not the given indicator has the same raw value as the receiver.
///
/// \param indicator The record field with which the receiver should be compared.
/// \returns Returns \c YES if the given indicator and the receiver have the same raw value.
- (BOOL)isEqualToIndicator:(BibFieldIndicator *)indicator;

@end

NS_ASSUME_NONNULL_END
