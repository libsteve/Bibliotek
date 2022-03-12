//
//  BibMARCInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>
#import <Bibliotek/BibRecordInputStream.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// A read-only stream of records parsed from MARC 21 encoded data.
NS_SWIFT_NAME(MARCInputStream)
@interface BibMARCInputStream : BibRecordInputStream

/// Initializes and returns a \c BibMARCInputStream for reading from the given input stream.
/// \param inputStream The \c NSInputStream object from which record data should be read.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given input stream.
- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

/// Read an instance of \c BibRecord from the MARC 21 data in the input stream.
/// \param error A pointer to an \c NSError variable that can be used to return an error value when \c nil is returned.
/// \returns A \c BibRecord object is returned when a record could be successfully read from the input stream.
///          Otherwise, \c nil is returned and, if \c error is not \c NULL, its pointee is set to an \c NSError object
///          to indicate the reason for the failure. If there are no more records to be read from the input stream,
///          \c nil is returned without setting the \c error pointee to an \c NSError instance.
/// \pre If the input stream must be opened.
/// \post If the input stream is opened and \c nil is returned, \c streamStatus is set to \c NSStreamStatusError, and
///       \c streamError is set to an \c NSError object that indicates the reason for the failure.
/// \note If the input stream has not yet been opened, \c nil is returned with an error, but \c streamStatus and
///       \c streamError will not be set to reflect that failure. Attempting to read from the input stream after it is
///       opened will continue to read data as though it did not previously encounter an error.
/// \note If \c streamStatus is set to \c NSStreamStatusAtEnd when this method is called, \c nil is returned, but no
///       \c NSError is provided through the \c error pointer.
- (nullable BibRecord *)readRecord:(out NSError *_Nullable __autoreleasing *_Nullable)error BIB_SWIFT_NONNULL_ERROR;

@end

NS_ASSUME_NONNULL_END
