//
//  BibControlField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibFieldTag;

NS_ASSUME_NONNULL_BEGIN

/// \brief A control field contains information and metadata about how a record's content should be processed.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/spechome.html
///
/// Information about Bibliographic control fields can be found in the Library of Congress's documentation:
/// http://www.loc.gov/marc/bibliographic/bd00x.html
///
/// Information about Classification control fields can be found in the Library of Congress's documentation:
/// https://www.loc.gov/marc/classification/cd00x.html
@interface BibControlField : NSObject

/// A value indicating the semantic purpose of the control field.
@property (nonatomic, strong, readonly) BibFieldTag *tag;

/// The information contained within the control field.
@property (nonatomic, copy, readonly) NSString *value;

/// Create a control field for some record data.
///
/// \param tag The field tag indicating the semantic purpose of the control field.
/// \param value The information contained within the control field.
/// \returns A control field with the given tag and value.
- (instancetype)initWithTag:(BibFieldTag *)tag value:(NSString *)value NS_DESIGNATED_INITIALIZER;

/// Create a control field for some record data.
///
/// \param tag The field tag indicating the semantic purpose of the control field.
/// \param value The information contained within the control field.
/// \returns A control field with the given tag and value.
+ (instancetype)controlFieldWithTag:(BibFieldTag *)tag value:(NSString *)value NS_SWIFT_UNAVAILABLE("Use init(tag:value:");

@end

#pragma mark - Copying

@interface BibControlField (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibControlField (Equality)

/// Determine whether or not the given control field represents the same data as the receiver.
///
/// \param controlField The control field with which the receiver should be compared.
/// \returns Returns \c YES if the given control field and the receiver have the same tag and value.
- (BOOL)isEqualToControlField:(BibControlField *)controlField;

@end

#pragma mark - Mutable

@interface BibMutableControlField : BibControlField

/// A value indicating the semantic purpose of the control field.
@property (nonatomic, strong, readwrite) BibFieldTag *tag;

/// The information contained within the control field.
@property (nonatomic, copy, readwrite) NSString *value;

@end

NS_ASSUME_NONNULL_END
