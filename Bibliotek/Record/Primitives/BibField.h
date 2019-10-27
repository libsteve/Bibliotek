//
//  BibField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/12/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibFieldTag;

NS_ASSUME_NONNULL_BEGIN

/// A set of information and/or metadata about the item represented by a MARC record.
///
/// The semantic meaning of a content field is indicated by its \c tag value.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/spechome.html
@protocol BibField

/// A value indicating the semantic purpose of the record field.
@property (nonatomic, readonly) BibFieldTag *tag;

@end

#pragma mark - Enumerator

@interface BibFieldEnumerator<__covariant FieldType> : NSEnumerator<FieldType>

- (instancetype)initWithEnumerator:(NSEnumerator<FieldType> *)enumerator NS_DESIGNATED_INITIALIZER;

- (nullable FieldType)nextField;

- (nullable FieldType)nextFieldWithTag:(BibFieldTag *)fieldTag;

@end

NS_ASSUME_NONNULL_END
