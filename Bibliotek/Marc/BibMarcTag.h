//
//  BibMarcTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BibCoding/BibCoding.h>

NS_ASSUME_NONNULL_BEGIN

/// \brief A 3-digit code indicating the semantic purpose of a record's field.
/// \discussion
/// MARC tags are always 3 alphanumeric characters. Tags beginning with \c 00 are reserved for control fields.
/// All other tag values indicate record fields.
///
/// The five MARC 21 formats for authority, bibliographic, classification, community, and holdings records
/// each define their own semantic meanings for reserved tag values. Documentation on these formats is publically
/// available at https://www.loc.gov/marc/.
NS_SWIFT_NAME(MarcTag)
@interface BibMarcTag : NSObject <NSSecureCoding, BibDecodable>

/// A string representation of the tag's 3-digit code.
@property (nonatomic, strong, readonly) NSString *stringValue NS_SWIFT_NAME(rawValue);

/// A boolean value determining whether or not the tag is appropriate for a record's control field.
@property (nonatomic, assign, readonly) BOOL isControlFieldTag;

/// Create a record field tag from the given string value.
/// \param stringValue A string containing the 3-digit code representation for a tag.
/// \pre String codes must be exactly 3 alphanumeric characters.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_SWIFT_Name(init(rawValue:)) NS_DESIGNATED_INITIALIZER;

/// Create a record field tag from the given string value.
/// \param stringValue A string containing the 3-digit code representation for a tag.
/// \pre String codes must be exactly 3 alphanumeric.
+ (nullable instancetype)tagWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

/// Determine if this field tag is equivalent to the given tag.
/// \param tag The field tag that is being compaired with this instance for equality.
/// \returns Returns \c YES when both tags have the same 3-digit code.
- (BOOL)isEqualToTag:(BibMarcTag *)tag;

/// Determine the ordered relationship between this and the given tag.
/// \param tag The tag that this tag should be compared with.
/// \returns An \c NSComparisonResult is returned that denotes how these two tags relate to each other.
/// \c NSOrderedAscending indicates that \c tag is lexically ordered after the receiver,
/// \c NSOrderedDescending indicates that \c tag is lexically ordered before the receiver,
/// and \c NSOrderedSame indicates that both tags are equivalent.
- (NSComparisonResult)compare:(BibMarcTag *)tag;

@end

@interface BibMarcTag (KnownValidFieldTags)

/// Marks the control field with the record's identifier.
/// \note http://www.loc.gov/marc/bibliographic/bd001.html
@property (class, nonatomic, strong, readonly) BibMarcTag *controlNumberTag NS_SWIFT_NAME(controlNumber);

/// Marks a field with an item's ISBN.
/// \note http://www.loc.gov/marc/bibliographic/bd020.html
@property (class, nonatomic, strong, readonly) BibMarcTag *isbnTag NS_SWIFT_NAME(isbn);

/// Marks a field with a Library of Congress classification number.
/// \note http://www.loc.gov/marc/bibliographic/bd050.html
@property (class, nonatomic, strong, readonly) BibMarcTag *lccTag NS_SWIFT_NAME(lcc);

/// Marks a field with a Dewey Decimal classification number.
/// \note http://www.loc.gov/marc/bibliographic/bd082.html
@property (class, nonatomic, strong, readonly) BibMarcTag *ddcTag NS_SWIFT_NAME(ddc);

/// Marks a field with an author's name.
/// \note http://www.loc.gov/marc/bibliographic/bd100.html
@property (class, nonatomic, strong, readonly) BibMarcTag *authorTag NS_SWIFT_NAME(author);

/// Marks a field with the title of the item.
/// \note http://www.loc.gov/marc/bibliographic/bd245.html
@property (class, nonatomic, strong, readonly) BibMarcTag *titleTag NS_SWIFT_NAME(title);

/// Marks a field with edition information about the item.
/// \note http://www.loc.gov/marc/bibliographic/bd250.html
@property (class, nonatomic, strong, readonly) BibMarcTag *editionTag NS_SWIFT_NAME(edition);

/// Marks a field with information about the publisher.
/// \note http://www.loc.gov/marc/bibliographic/bd264.html
@property (class, nonatomic, strong, readonly) BibMarcTag *publicationTag NS_SWIFT_NAME(publication);

/// Marks a field with a description of an item's physical condition.
/// \note http://www.loc.gov/marc/bibliographic/bd300.html
@property (class, nonatomic, strong, readonly) BibMarcTag *physicalDescriptionTag NS_SWIFT_NAME(physicalDescription);

/// Marks a field with a note within the record.
/// \note http://www.loc.gov/marc/bibliographic/bd500.html
@property (class, nonatomic, strong, readonly) BibMarcTag *noteTag NS_SWIFT_NAME(note);

/// Marks a field with a summary about the item.
/// \note http://www.loc.gov/marc/bibliographic/bd504.html
@property (class, nonatomic, strong, readonly) BibMarcTag *bibliographyTag NS_SWIFT_NAME(bibliography);

/// Marks a field with a subject heading.
/// \note http://www.loc.gov/marc/bibliographic/bd520.html
@property (class, nonatomic, strong, readonly) BibMarcTag *summaryTag NS_SWIFT_NAME(summary);

/// Marks a field with a genre to which an item belongs.
/// \note http://www.loc.gov/marc/bibliographic/bd650.html
@property (class, nonatomic, strong, readonly) BibMarcTag *subjectTag NS_SWIFT_NAME(subject);

/// Marks a field with the name of the series to which an item belongs.
/// \note http://www.loc.gov/marc/bibliographic/bd655.html
@property (class, nonatomic, strong, readonly) BibMarcTag *genreTag NS_SWIFT_NAME(genre);

/// Marks a field with a summary about the item.
/// \note http://www.loc.gov/marc/bibliographic/bd830.html
@property (class, nonatomic, strong, readonly) BibMarcTag *seriesTag NS_SWIFT_NAME(series);

@end

NS_ASSUME_NONNULL_END
