//
//  BibDirectoryEntry.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibFieldTag;

NS_ASSUME_NONNULL_BEGIN

/// A reference to a segment of data within a record.
///
/// The referenced segment is the full serialized field within the record,
/// with a tag value indicating the field's semantic purpose.
///
/// More information about MARC 21 directory entries can be found in the Library of Congress's documentation on
/// MARC 21 record structure: https://www.loc.gov/marc/specifications/specrecstruc.html#direct
NS_SWIFT_NAME(DirectoryEntry)
@interface BibDirectoryEntry : NSObject

/// A value indicating the semantic purpose of the referenced field.
@property (nonatomic, strong, readonly) BibFieldTag *tag;

/// The location of the field within the record's MARC 21 data representation.
@property (nonatomic, assign, readonly) NSRange range;

/// Create a directory entry for a field in a MARC 21 recrod.
///
/// \param tag The field tag identifying the semantic purpose of the record field.
/// \param range The range of data within the MARC 21 record of the referenced field.
/// \returns Returns a directory entry.
- (instancetype)initWithTag:(BibFieldTag *)tag range:(NSRange)range NS_DESIGNATED_INITIALIZER;

/// Create a directory entry for a field in a MARC 21 recrod.
///
/// \param tag The field tag identifying the semantic purpose of the record field.
/// \param range The range of data within the MARC 21 record of the referenced field.
/// \returns Returns a directory entry.
+ (instancetype)entryWithTag:(BibFieldTag *)tag range:(NSRange)range NS_SWIFT_UNAVAILABLE("Use init(tag:range:)");

@end

#pragma mark - Equality

@interface BibDirectoryEntry (Equality)

/// Determine whether or not the given directory entry references the same record field as the receiver.
///
/// \param entry The directory entry with which the receiver should be compared.
/// \returns Returns \c YES if the given entry and the receiver reference the same record field.
- (BOOL)isEqualToEntry:(BibDirectoryEntry *)entry;

@end

NS_ASSUME_NONNULL_END
