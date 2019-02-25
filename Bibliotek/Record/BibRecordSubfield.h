//
//  BibRecordSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

NS_ASSUME_NONNULL_BEGIN

/// \brief A portion of data within a record data field.
/// \discussion Data fields hold data within labeled subfields.
/// Each subfield's identifier marks the semantic meaning of its content, which is determined by the record field's tag
/// as defined in the appropriate MARC 21 format specification.
NS_SWIFT_NAME(Record.Subfield)
@interface BibRecordSubfield : NSObject

/// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
///
/// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
@property (nonatomic, copy, readonly) BibRecordSubfieldCode code;

/// A string representation of the information stored in the subfield.
@property (nonatomic, copy, readonly) NSString *content;

- (instancetype)initWithData:(NSData *)data;

/// Create a subfield of data for use within a record's data field.
/// \param code An alphanumeric identifier for semantic purpose of the subfield's content.
/// \param content A string representation of the data stored within the subfield.
/// \returns Returns a subfield value when the given subfield identifier is well-formatted.
- (instancetype)initWithCode:(BibRecordSubfieldCode)code content:(NSString *)content NS_DESIGNATED_INITIALIZER;

/// Determine if this subfield and its data is equivalent to that of the given subfield.
/// \param subfield The subfield that is being compaired with this instance for equality.
/// \returns Returns \c YES when both fields have the same identifier and content.
- (BOOL)isEqualToSubfield:(BibRecordSubfield *)subfield;

@end

NS_ASSUME_NONNULL_END
