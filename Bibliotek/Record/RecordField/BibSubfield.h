//
//  BibSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>

NS_ASSUME_NONNULL_BEGIN

/// A string identifier used by a subfield to semantically label its contents.
///
/// MARC 21 subfield codes are always a single ASCII graphic character.
///
/// More information about subfield codes can be found in the Variable Fields section of the Library of Congress's
/// documentation on [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/specrecstruc.html#varifields).
typedef NSString *BibSubfieldCode NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(SubfieldCode);

/// A portion of data in a content field semantically identified by its `subfieldCode`.
///
/// Content fields hold data within labeled subfields. Each subfield's identifier marks the semantic meaning of its
/// content, which is determined by the record field's tag as defined in the appropriate MARC 21 format specification.
BIB_SWIFT_BRIDGE(Subfield)
@interface BibSubfield : NSObject

/// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, copy, readonly) BibSubfieldCode subfieldCode;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readonly) NSString *content;

/// Create a subfield of data for use within a record's data field.
/// - parameter subfieldCode: An alphanumeric identifier for semantic purpose of the subfield's content.
/// - parameter content: A string representation of the data stored within the subfield.
/// - returns: Returns a subfield value when the given subfield identifier is well-formatted.
- (instancetype)initWithCode:(BibSubfieldCode)subfieldCode content:(NSString *)content NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Copying

@interface BibSubfield (Copying) <NSCopying, NSSecureCoding>
@end

#pragma mark - Equality

@interface BibSubfield (Equality)

/// Determine if this subfield and its data is equivalent to that of the given subfield.
/// - parameter subfield: The subfield that is being compared with this instance for equality.
/// - returns: Returns `YES` when both fields have the same subfieldCode and content.
- (BOOL)isEqualToSubfield:(BibSubfield *)subfield;

@end

#pragma mark - Mutable

/// A mutable portion of data in a content field semantically identified by its ``BibSubfield/subfieldCode``.
///
/// Content fields hold data within labeled subfields. Each subfield's identifier marks the semantic meaning of its
/// content, which is determined by the record field's tag as defined in the appropriate MARC 21 format specification.
@interface BibMutableSubfield : BibSubfield

/// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, copy, readwrite) BibSubfieldCode subfieldCode;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readwrite) NSString *content;

@end

#pragma mark - Enumerator

@interface BibSubfieldEnumerator : NSEnumerator<BibSubfield *>

- (instancetype)initWithEnumerator:(NSEnumerator<BibSubfield *> *)enumerator;

- (nullable BibSubfield *)nextSubfield;

- (nullable BibSubfield *)nextSubfieldWithCode:(BibSubfieldCode)subfieldCode;

@end

NS_ASSUME_NONNULL_END
