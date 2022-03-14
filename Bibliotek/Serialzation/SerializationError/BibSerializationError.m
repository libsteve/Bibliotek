//
//  BibCodingError.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/12/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import <Bibliotek/Bibliotek+Internal.h>
#import "BibSerializationError.h"
#import "BibSerializationError+Internal.h"

static NSBundle *BibBundle(void) {
    return [NSBundle bundleForClass:[BibRecord self]];
}

#pragma mark -

NSErrorDomain const BibSerializationErrorDomain = @"BibSerializationErrorDomain";

NSString *BibSerializationErrorCodeDescription(BibSerializationErrorCode errorCode) {
    switch (errorCode) {
        case BibSerializationMalformedDataError: return @"MalformedDataError";
        case BibSerializationPrematureEndOfDataError: return @"PrematureEndOfDataError";
        case BibSerializationStreamNotOpenedError: return @"StreamNotOpenedError";
        case BibSerializationStreamAtEndError: return @"StreamAtEndError";
        case BibSerializationStreamBusyError: return @"StreamBusyError";
    }
    return [NSString stringWithFormat:@"%ld", (long)errorCode];
}

#pragma mark -

NSError *BibSerializationMakeMalformedDataError(NSDictionary *userInfo) {
    NSString *const message =
    NSLocalizedStringWithDefaultValue(@"serialization-error.malformed-data", @"Localized", BibBundle(),
                                      @"Cannot read corrupt or malformed data.",
                                      @"Error message for failures to read records from invalid data.");
    return [NSError errorWithDomain:BibSerializationErrorDomain
                               code:BibSerializationMalformedDataError
                           userInfo:userInfo ?: @{ NSLocalizedDescriptionKey : message }];
}

NSError *BibSerializationMakePrematureEndOfDataError(NSDictionary *userInfo) {
    NSString *const message =
    NSLocalizedStringWithDefaultValue(@"serialization-error.premature-end-of-data", @"Localized", BibBundle(),
                                      @"Reached the end of available data when more was expected.",
                                      @"Error message for failures to read records from incomplete data.");
    return  [NSError errorWithDomain:BibSerializationErrorDomain
                                code:BibSerializationPrematureEndOfDataError
                            userInfo:userInfo ?: @{ NSLocalizedDescriptionKey : message }];
}

NSError *BibSerializationMakeInputStreamNotOpenedError(NSStream *const stream) {
    switch ([stream streamStatus]) {
        case NSStreamStatusOpen:
            return nil;

        case NSStreamStatusAtEnd:
            // It's valid to try to read past the end of a stream. It just returns nothing.
            return nil;

        case NSStreamStatusError:
            return [stream streamError];

        case NSStreamStatusNotOpen:{
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.input-stream.not-open",
                                              @"Localized", BibBundle(),
                                              @"A stream must be opened before it can read data.",
                                              @"Error message for attempts to read data before opening its source.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamNotOpenedError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusClosed: {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.input-stream.closed",
                                              @"Localized", BibBundle(),
                                              @"A closed stream cannot read data.",
                                              @"Error message for attempts to read data after it's source is closed.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamNotOpenedError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusOpening: {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.input-stream.opening",
                                              @"Localized", BibBundle(),
                                              @"Cannot read data from a stream while it's opening.",
                                              @"Error message for attempts to read data while opening its source.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamBusyError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusReading: {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.input-stream.reading",
                                              @"Localized", BibBundle(),
                                              @"Cannot read data from a stream while it's already reading data.",
                                              @"Error message for attempts to read data while its source is"
                                              @" already reading data.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamBusyError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusWriting: {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.input-stream.writing",
                                              @"Localized", BibBundle(),
                                              @"Cannot read data from a stream while it's writing data.",
                                              @"Error message for attempts to read data while its source is"
                                              @" writing data.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamBusyError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
    }
}

NSError *BibSerializationMakeOutputStreamNotOpenedError(NSStream *const stream) {
    switch ([stream streamStatus]) {
        case NSStreamStatusOpen:
            return nil;

        case NSStreamStatusError:
            return [stream streamError];

        case NSStreamStatusAtEnd:  {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.output-stream.at-end",
                                              @"Localized", BibBundle(),
                                              @"A stream cannot write past the end of it's available space.",
                                              [@"Error message for attempts to write data past the available in"
                                               @" allocated memory or a file."]);
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamAtEndError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusNotOpen:  {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.output-stream.not-open",
                                              @"Localized", BibBundle(),
                                              @"A stream must be opened before it can write data.",
                                              @"Error message for attempts to write data before opening its source.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamNotOpenedError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusClosed: {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.output-stream.closed",
                                              @"Localized", BibBundle(),
                                              @"A closed stream cannot write data.",
                                              @"Error message for attempts to write data after its source is closed.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamNotOpenedError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusOpening: {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.output-stream.opening",
                                              @"Localized", BibBundle(),
                                              @"Cannot write data to a stream while it's opening.",
                                              @"Error message for attempts to write data while opening its source.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamBusyError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusReading:  {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.output-stream.reading",
                                              @"Localized", BibBundle(),
                                              @"Cannot write data to a stream while it's reading data.",
                                              @"Error message for attempts to read data while its source is"
                                              @" already writing data.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamBusyError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
        case NSStreamStatusWriting:  {
            NSString *const message =
            NSLocalizedStringWithDefaultValue(@"serialization-error.output-stream.writing",
                                              @"Localized", BibBundle(),
                                              @"Cannot write data to a stream while it's already writing data.",
                                              @"Error message for attempts to write data before opening its source.");
            return [NSError errorWithDomain:BibSerializationErrorDomain
                                       code:BibSerializationStreamBusyError
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : message }];
        }
    }
}
