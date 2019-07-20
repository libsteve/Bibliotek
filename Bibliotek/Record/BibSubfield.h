//
//  BibSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *BibSubfieldCode NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(Subfield.Code);

/// \brief A portion of data within a record data field.
/// \discussion Data fields hold data within labeled subfields.
/// Each subfield's identifier marks the semantic meaning of its content, which is determined by the record field's tag
/// as defined in the appropriate MARC 21 format specification.
NS_SWIFT_NAME(Subfield)
@interface BibSubfield : NSObject

/// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, copy, readonly) BibSubfieldCode code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readonly) NSString *content;

/// Create a subfield of data for use within a record's data field.
/// \param code An alphanumeric identifier for semantic purpose of the subfield's content.
/// \param content A string representation of the data stored within the subfield.
/// \returns Returns a subfield value when the given subfield identifier is well-formatted.
- (instancetype)initWithCode:(BibSubfieldCode)code content:(NSString *)content NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Copying

@interface BibSubfield (Copying) <NSCopying>
@end

#pragma mark - Equality

@interface BibSubfield (Equality)

/// Determine if this subfield and its data is equivalent to that of the given subfield.
/// \param subfield The subfield that is being compaired with this instance for equality.
/// \returns Returns \c YES when both fields have the same code and content.
- (BOOL)isEqualToSubfield:(BibSubfield *)subfield;

@end

#pragma mark - Mutable

/// \brief A portion of data within a record data field.
/// \discussion Data fields hold data within labeled subfields.
/// Each subfield's identifier marks the semantic meaning of its content, which is determined by the record field's tag
/// as defined in the appropriate MARC 21 format specification.
NS_SWIFT_NAME(MutableSubfield)
@interface BibMutableSubfield : BibSubfield

/// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, copy, readwrite) BibSubfieldCode code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readwrite) NSString *content;

@end

NS_ASSUME_NONNULL_END
