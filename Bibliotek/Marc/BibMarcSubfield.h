//
//  BibMarcSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcSubfieldCode;

NS_ASSUME_NONNULL_BEGIN

/// \brief A portion of data within a record data field.
/// \discussion Data fields hold data within labeled subfields.
/// Each subfield's code marks the semantic meaning of its content, which is determined by the record field's tag
/// as defined in the appropriate MARC 21 format specification.
NS_SWIFT_NAME(MarcSubfield)
@interface BibMarcSubfield : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

/// A record subfield's code identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each code is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, strong, readonly) BibMarcSubfieldCode *code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readonly) NSString *content;

/// Create a subfield of data for use within a record's data field.
/// \param code The subfield code identifying the semantic purpose of the data.
/// \param content A string representation of the data stored within the subfield.
/// \returns Returns a subfield value when the given subfield code is well-formatted.
/// \pre The subfield code must contain exactly one ASCII lowercase or numeric character.
- (instancetype)initWithCode:(BibMarcSubfieldCode *)code content:(NSString *)content NS_DESIGNATED_INITIALIZER;

/// Create a subfield of data for use within a record's data field.
/// \param code The subfield code identifying the semantic purpose of the data.
/// \param content A string representation of the data stored within the subfield.
/// \returns Returns a subfield value when the given subfield code is well-formatted.
/// \pre The subfield code must contain exactly one ASCII lowercase or numeric character.
+ (instancetype)subfieldWithCode:(BibMarcSubfieldCode *)code content:(NSString *)content NS_SWIFT_UNAVAILABLE("Use init(code:content:)");

/// Determine if this subfield and its data is equivalent to that of the given subfield.
/// \param subfield The subfield that is being compaired with this instance for equality.
/// \returns Returns \c YES when both fields have the same code and content.
- (BOOL)isEqualToSubfield:(BibMarcSubfield *)subfield;

@end

NS_SWIFT_NAME(MarcMutableSubfield)
@interface BibMarcMutableSubfield : BibMarcSubfield

/// A record subfield's code identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each code is determined by the record field's tag as defined in the appropriate MARC 21 format.
@property (nonatomic, strong, readwrite) BibMarcSubfieldCode *code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readwrite) NSString *content;

@end

NS_ASSUME_NONNULL_END
