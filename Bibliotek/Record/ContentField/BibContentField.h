//
//  BibContentField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibSubfield.h>
#import <Bibliotek/BibField.h>

@class BibSubfield;
@class BibFieldTag;
@class BibContentIndicatorList;

NS_ASSUME_NONNULL_BEGIN

/// A set of information and metadata about the item represented by a MARC record.
///
/// The semantic meaning of a content field is indicated by its \c tag value, and its \c indicators are used as flags
/// that determine how the data in its subfields should be interpreted or displayed.
///
/// Content fields are composed of \c subfields, which are portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/spechome.html
///
/// More information about bibliographic records' content fields can be found in the Library of Congress's documentation
/// on bibliographic records: http://www.loc.gov/marc/bibliographic/
///
/// More information about classification records' content fields can be found in the Library of Congress's
/// documentation on classification records: https://www.loc.gov/marc/classification/
@interface BibContentField : NSObject <BibField>

/// A value indicating the semantic purpose of the content field.
@property (nonatomic, strong, readonly) BibFieldTag *tag;

/// A collection of byte flags which can indicate how the content field should be interpreted or displayed.
@property (nonatomic, copy, readonly) BibContentIndicatorList *indicators;

/// An ordered list of subfields containing portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
@property (nonatomic, copy, readonly) NSArray<BibSubfield *> *subfields;

- (instancetype)initWithTag:(BibFieldTag *)tag
                 indicators:(BibContentIndicatorList *)indicators
                  subfields:(NSArray<BibSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Copying

@interface BibContentField (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibContentField (Equality)

/// Determine whether or not the given content field represents the same data as the receiver.
///
/// \param contentField The content field with which the receiver should be compared.
/// \returns Returns \c YES if the given content field and the receiver have the same tag and subfields.
- (BOOL)isEqualToContentField:(BibContentField *)contentField;

@end

#pragma mark - Subfield Access

@interface BibContentField (SubfieldAccess)

- (BibSubfieldEnumerator *)subfieldEnumerator;

- (nullable BibSubfield *)firstSubfieldWithCode:(BibSubfieldCode)code;

- (nullable NSString *)contentOfFirstSubfieldWithCode:(BibSubfieldCode)code;

- (NSIndexSet *)indexesOfSubfieldsWithCode:(BibSubfieldCode)code;

- (NSArray<BibSubfield *> *)subfieldsWithCode:(BibSubfieldCode)code;

- (BibSubfield *)subfieldAtIndex:(NSUInteger)index;

@end

#pragma mark - Mutable

/// A mutable set of information and metadata about the item represented by a MARC record.
///
/// The semantic meaning of a content field is indicated by its \c tag value, and its \c indicators are used as flags
/// that determine how the data in its subfields should be interpreted or displayed.
///
/// Content fields are composed of \c subfields, which are portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/spechome.html
///
/// More information about bibliographic records' content fields can be found in the Library of Congress's documentation
/// on bibliographic records: http://www.loc.gov/marc/bibliographic/
///
/// More information about classification records' content fields can be found in the Library of Congress's
/// documentation on classification records: https://www.loc.gov/marc/classification/
@interface BibMutableContentField : BibContentField

/// A value indicating the semantic purpose of the content field.
@property (nonatomic, strong, readwrite) BibFieldTag *tag;

/// A collection of byte flags which can indicate how the content field should be interpreted or displayed.
@property (nonatomic, copy, readwrite) BibContentIndicatorList *indicators;

/// An ordered list of subfields containing portions of data semantically identified by their \c code.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag \c 245, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
@property (nonatomic, copy, readwrite) NSArray<BibSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
