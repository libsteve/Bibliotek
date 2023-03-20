//
//  BibFieldTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>

NS_ASSUME_NONNULL_BEGIN

/// A 3-character value identifying the semantic purpose of a record field.
///
/// More information about the tags used with MARC 21 records can be found in the Library of Congress's
/// documentation on [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/spechome.html).
///
/// - note: MARC 21 tags are always 3 digit codes.
BIB_SWIFT_BRIDGE(FieldTag)
@interface BibFieldTag : NSObject <NSCopying, NSSecureCoding>

/// A string containing the 3-character value of the tag.
@property (nonatomic, copy, readonly) NSString *stringValue;

/// Does the tag identify a control field?
///
/// MARC 21 control field tags always begin with two zeros.
/// For example, a record's control number field has the tag `001`.
@property (nonatomic, assign, readonly, getter=isControlFieldTag) BOOL controlFieldTag
    DEPRECATED_MSG_ATTRIBUTE("Use -isControlTag");

/// Does the tag identify a control field?
///
/// MARC 21 control-field tags always begin with two zeros.
/// For example, a record's control number control-field has the tag `001`.
///
/// - note: The tag `000` is neither a control-field tag nor a data-field tag.
@property (nonatomic, assign, readonly) BOOL isControlTag;

/// Does the tag identify a data field?
///
/// MARC 21 data-field tags never begin with two zeros.
/// For example, a bibliographic record's Library of Congress call number data-field has the tag `050`.
@property (nonatomic, assign, readonly) BOOL isDataTag;

/// Create a tag with the given string value.
///
/// - parameter stringValue: A string containing the 3-character tag value.
/// - returns: Returns a valid field tag only if the given string is exactly 3 characters long.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_DESIGNATED_INITIALIZER;

/// Create a tag with the given string value.
///
/// - parameter stringValue: A string containing the 3-character tag value.
/// - returns: Returns a valid field tag only if the given string is exactly 3 characters long.
+ (nullable instancetype)fieldTagWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(string:)");

@end

#pragma mark - Equality

@interface BibFieldTag (Equality)

/// Determine whether or not the given tag describes the same MARC 21 field as the receiver.
///
/// - parameter fieldTag: The tag with which the receiver should be compared.
/// - returns: Returns `YES` if the given tag and the receiver describe the same MARC 21 field.
- (BOOL)isEqualToTag:(BibFieldTag *)fieldTag;

- (BOOL)isEqualToString:(NSString *)stringValue;

@end

NS_ASSUME_NONNULL_END
