//
//  BibFieldTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A value identifying the semantic purpose of a record field.
///
/// \note MARC 21 tags are always 3 digit codes.
NS_SWIFT_NAME(FieldTag)
@interface BibFieldTag : NSObject

/// A string contianing the 3-character value of the tag.
@property (nonatomic, copy, readonly) NSString *stringValue NS_SWIFT_NAME(rawValue);

/// Does the tag identify a control field?
///
/// MARC 21 control field tags always begin with two zeros.
/// For example, a record's control number field has the tag \c 001.
@property (nonatomic, assign, readonly, getter=isControlFieldTag) BOOL controlFieldTag;

/// Create a tag with the given string value.
///
/// \param stringValue A string containing the 3-character tag value.
/// \returns Returns a valid field tag only if the given string is exactly 3 characters long.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(rawValue:));

@end

@interface BibFieldTag (Equality)

/// Determine whether or not the given tag describes the same MARC 21 field as the receiver.
///
/// \param fieldTag The tag with which the receiver should be compared.
/// \returns Returns \c YES if the given tag and the receiver describe the same MARC 21 field.
- (BOOL)isEqualToTag:(BibFieldTag *)fieldTag;

@end

NS_ASSUME_NONNULL_END