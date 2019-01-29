//
//  BibMarcRecordError.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// An error pertaining to the creation of a MARC 21 record.
extern NSErrorDomain const BibMarcRecordErrorDomain NS_REFINED_FOR_SWIFT;

/// An error type explaining why a \c BibMarcRecord or dependent type could not be created.
typedef NS_ERROR_ENUM(BibMarcRecordErrorDomain, BibMarcRecordError) {

    /// The length of the string used to create some property in a record or field is invalid.
    BibMarcRecordErrorInvalidCharacterCount = 1,

    /// The string used to create some property in a record or field contains invalid characters.
    BibMarcRecordErrorInvalidCharacterSet = 2


} NS_SWIFT_NAME(MarcRecord.FieldIndicatorError);

NS_ASSUME_NONNULL_END
