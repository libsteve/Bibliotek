//
//  BibMarcRecordFieldTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// \brief A 3-digit code indicating the semantic purpose of a record field.
/// \discussion The five MARC 21 formats for authority, bibliographic, classification, community, and holdings records
/// each define their own semantic meanings for reserved tag values. Documentation on these formats is publically
/// available at https://www.loc.gov/marc/.
NS_SWIFT_NAME(MarcRecord.FieldTag)
@interface BibMarcRecordFieldTag : NSObject <NSSecureCoding>

/// A string representation of the tag's 3-digit code.
@property (nonatomic, strong, readonly) NSString *stringValue;

/// A boolean value determining whether or not the tag is appropriate for a record's control field.
@property (nonatomic, assign, readonly) BOOL isControlFieldTag;

/// Create a record field tag from the given string value.
/// \param stringValue A string containing the 3-digit code representation for a tag.
/// \pre String codes must be exactly 3 digits long.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

/// Create a record field tag from the given string value.
/// \param stringValue A string containing the 3-digit code representation for a tag.
/// \param error An error pointer providing an explanation for why the creation of a tag failed.
/// \pre String codes must be exactly 3 digits long.
- (nullable instancetype)initWithString:(NSString *)stringValue
                                  error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(stringValue:));

/// Create a record field tag from the given string value.
/// \param stringValue A string containing the 3-digit code representation for a tag.
/// \param error An error pointer which can return a reason explaining why the creation of a tag failed.
/// \pre String codes must be exactly 3 digits long.
+ (nullable instancetype)tagWithString:(NSString *)stringValue
                                 error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

/// Create a record field tag from the given string value.
/// \param stringValue A string containing the 3-digit code representation for a tag.
/// \pre String codes must be exactly 3 digits long.
+ (nullable instancetype)tagWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

/// Determine if this field tag is equivalent to the given tag.
/// \param tag The field tag that is being compaired with this instance for equality.
/// \returns Returns \c YES when both tags have the same 3-digit code.
- (BOOL)isEqualToTag:(BibMarcRecordFieldTag *)tag;

/// Determine the ordered relationship between this and the given field tag.
/// \param tag The field tag that this tag should be compared with.
/// \returns An \c NSComparisonResult is returned that denotes how these two tags relate to each other.
/// \c NSOrderedAscending indicates that \c fieldTag is lexically ordered after this tag,
/// \c NSOrderedDescending indicates that \c fieldTag is lexically ordered before this tag,
/// and \c NSOrderedSame indicates that both tags are equivalent.
- (NSComparisonResult)compare:(BibMarcRecordFieldTag *)tag;

@end

@interface BibMarcRecordFieldTag (KnownValidFieldTags)

/// Marks the control field with the record's identifier.
/// \note http://www.loc.gov/marc/bibliographic/bd001.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *controlNumberTag NS_SWIFT_NAME(controlNumber);

/// Marks a field with an item's ISBN.
/// \note http://www.loc.gov/marc/bibliographic/bd020.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *isbnTag NS_SWIFT_NAME(isbn);

/// Marks a field with a Library of Congress classification number.
/// \note http://www.loc.gov/marc/bibliographic/bd050.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *lccTag NS_SWIFT_NAME(lcc);

/// Marks a field with a Dewey Decimal classification number.
/// \note http://www.loc.gov/marc/bibliographic/bd082.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *ddcTag NS_SWIFT_NAME(ddc);

/// Marks a field with an author's name.
/// \note http://www.loc.gov/marc/bibliographic/bd100.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *authorTag NS_SWIFT_NAME(author);

/// Marks a field with the title of the item.
/// \note http://www.loc.gov/marc/bibliographic/bd245.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *titleTag NS_SWIFT_NAME(title);

/// Marks a field with edition information about the item.
/// \note http://www.loc.gov/marc/bibliographic/bd250.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *editionTag NS_SWIFT_NAME(edition);

/// Marks a field with information about the publisher.
/// \note http://www.loc.gov/marc/bibliographic/bd264.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *publicationTag NS_SWIFT_NAME(publication);

/// Marks a field with a description of an item's physical condition.
/// \note http://www.loc.gov/marc/bibliographic/bd300.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *physicalDescriptionTag NS_SWIFT_NAME(physicalDescription);

/// Marks a field with a note within the record.
/// \note http://www.loc.gov/marc/bibliographic/bd500.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *noteTag NS_SWIFT_NAME(note);

/// Marks a field with a summary about the item.
/// \note http://www.loc.gov/marc/bibliographic/bd504.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *bibliographyTag NS_SWIFT_NAME(bibliography);

/// Marks a field with a subject heading.
/// \note http://www.loc.gov/marc/bibliographic/bd520.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *summaryTag NS_SWIFT_NAME(summary);

/// Marks a field with a genre to which an item belongs.
/// \note http://www.loc.gov/marc/bibliographic/bd650.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *subjectTag NS_SWIFT_NAME(subject);

/// Marks a field with the name of the series to which an item belongs.
/// \note http://www.loc.gov/marc/bibliographic/bd655.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *genreTag NS_SWIFT_NAME(genre);

/// Marks a field with a summary about the item.
/// \note http://www.loc.gov/marc/bibliographic/bd830.html
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *seriesTag NS_SWIFT_NAME(series);

@end

NS_ASSUME_NONNULL_END
