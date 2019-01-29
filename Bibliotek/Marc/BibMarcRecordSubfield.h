//
//  BibMarcRecordSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// \brief A portion of data within a record data field.
/// \discussion Data fields hold data within labeled subfields.
/// Each subfield's code marks the semantic meaning of its content, which is determined by the record field's tag
/// as defined in the appropriate MARC 21 format specification.
NS_SWIFT_NAME(MarcRecord.Subfield)
@interface BibMarcRecordSubfield : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

/// A record subfield's code identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each code is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, copy, readonly) NSString *code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readonly) NSString *content;

/// Create a subfield of data for use within a record's data field.
/// \param code The subfield code identifying the semantic purpose of the data.
/// \param content A string representation of the data stored within the subfield.
/// \returns Returns a subfield value when the given subfield code is well-formatted.
/// \pre The subfield code must contain exactly one ASCII lowercase or numeric character.
- (instancetype)initWithCode:(NSString *)code content:(NSString *)content NS_SWIFT_UNAVAILABLE("Use init(code:content:)");

/// Create a subfield of data for use within a record's data field.
/// \param code The subfield code identifying the semantic purpose of the data.
/// \param content A string representation of the data stored within the subfield.
/// \param error An error pointer which can return a reason explaining why the creation of a subfield failed.
/// \returns Returns a subfield value when the given subfield code is well-formatted.
/// \pre The subfield code must contain exactly one ASCII lowercase or numeric character.
- (instancetype)initWithCode:(NSString *)code
                     content:(NSString *)content
                       error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_DESIGNATED_INITIALIZER;

/// Create a subfield of data for use within a record's data field.
/// \param code The subfield code identifying the semantic purpose of the data.
/// \param content A string representation of the data stored within the subfield.
/// \param error An error pointer which can return a reason explaining why the creation of a subfield failed.
/// \returns Returns a subfield value when the given subfield code is well-formatted.
/// \pre The subfield code must contain exactly one ASCII lowercase or numeric character.
+ (instancetype)subfieldWithCode:(NSString *)code
                         content:(NSString *)content
                           error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_SWIFT_UNAVAILABLE("Use init(code:content:)");

/// Create a subfield of data for use within a record's data field.
/// \param code The subfield code identifying the semantic purpose of the data.
/// \param content A string representation of the data stored within the subfield.
/// \returns Returns a subfield value when the given subfield code is well-formatted.
/// \pre The subfield code must contain exactly one ASCII lowercase or numeric character.
+ (instancetype)subfieldWithCode:(NSString *)code content:(NSString *)content NS_SWIFT_UNAVAILABLE("Use init(code:content:)");

/// Determine if this subfield and its data is equivalent to that of the given subfield.
/// \param subfield The subfield that is being compaired with this instance for equality.
/// \returns Returns \c YES when both fields have the same code and content.
- (BOOL)isEqualToSubfield:(BibMarcRecordSubfield *)subfield;

@end

NS_SWIFT_NAME(MarcRecord.MutableSubfield)
@interface BibMarcRecordMutableSubfield : BibMarcRecordSubfield

/// A record subfield's code identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each code is determined by the record field's tag as defined in the appropriate MARC 21 format.
///
/// \note An exception is thrown if the code does not contain exactly one ASCII lowercase or numeric character.
@property (nonatomic, copy, readwrite) NSString *code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readwrite) NSString *content;

@end

NS_ASSUME_NONNULL_END
