//
//  BibSerializationError.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/12/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// An error encountered when encoding or decoding MARC record data.
extern NSErrorDomain const BibSerializationErrorDomain;

/// The error code for an error in the `BibSerializationErrorDomain` error domain.
typedef NS_ERROR_ENUM(BibSerializationErrorDomain, BibSerializationErrorCode) {
    /// The serializer encountered conflicting or invalid data with the MARC 21 record data.
    BibSerializationMalformedDataError NS_SWIFT_NAME(malformedData) = 1,

    /// The serializer reached the end of its data when more should have been available.
    BibSerializationPrematureEndOfDataError NS_SWIFT_NAME(prematureEndOfData) = 2,

    /// The input or output stream is not opened and therefore cannot be used to read or
    /// write record data.
    BibSerializationStreamNotOpenedError NS_SWIFT_NAME(streamNotOpened) = 3,

    /// The input or output stream was at the end of its available data before the record
    /// could be read or written.
    BibSerializationStreamAtEndError NS_SWIFT_NAME(streamAtEnd) = 4,

    /// The input or output stream is buys reading, writing, or opening, and is therefore
    /// blocked from reading or writing data.
    BibSerializationStreamBusyError NS_SWIFT_NAME(streamBusy) = 5
} NS_SWIFT_NAME(SerializationError);

extern NSString *BibSerializationErrorCodeDescription(BibSerializationErrorCode errorCode);

NS_ASSUME_NONNULL_END
