//
//  BibMARCInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// A read-only stream of records parsed from MARC 21 encoded data.
NS_SWIFT_NAME(MARCInputStream)
@interface BibMARCInputStream : NSObject

/// The input stream's status.
///
/// No data can be read after \c streamStatus is set to \c NSStreamStatusClosed or \c NSSttreamStatusError.
@property (nonatomic, assign, readonly) NSStreamStatus streamStatus;

/// The input stream's error when its \c status is \c NSStreamStatusError.
///
/// No data can be read after \c streamError is set to a non-nil value.
@property (nonatomic, copy, readonly, nullable) NSError *streamError;

/// Are there more records available to read from the stream?
///
/// \returns \c YES when there is more data available in the stream to read as records,
///          or when the availability of data can't determined without attempting a read.
@property (nonatomic, assign, readonly) BOOL hasRecordsAvailable;

#pragma mark -

/// Initializes and returns a \c BibMARCInputStream for reading from a file at the given URL.
/// \param url The URL to the file.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given URL.
- (instancetype)initWithURL:(NSURL *)url;

/// Initializes and returns a \c BibMARCInputStream for reading from the given data.
/// \param data The data object to read records from. The contents of \c data are copied.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given data.
- (instancetype)initWithData:(NSData *)data;

/// Initializes and returns a \c BibMARCInputStream for reading from a file at the given path.
/// \param path The path to the file.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given path.
- (nullable instancetype)initWithFileAtPath:(NSString *)path;

/// Initializes and returns a \c BibMARCInputStream for reading from the given input stream.
/// \param inputStream The \c NSInputStream object from which record data should be read.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given input stream.
- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

#pragma mark -

/// Creates and returns a \c BibMARCInputStream for reading from a file at the given URL.
/// \param url The URL to the file.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given URL.
+ (instancetype)inputStreamWithURL:(NSURL *)url NS_SWIFT_UNAVAILABLE("Use init(url:)");

/// Creates and returns a \c BibMARCInputStream for reading from the given data.
/// \param data The data object to read records from. The contents of \c data are copied.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given data.
+ (instancetype)inputStreamWithData:(NSData *)data NS_SWIFT_UNAVAILABLE("Use init(data:)");

/// Creates and returns a \c BibMARCInputStream for reading from a file at the given path.
/// \param path The path to the file.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given path.
+ (nullable instancetype)inputStreamWithFileAtPath:(NSString *)path NS_SWIFT_UNAVAILABLE("Use init(fileAtPath:)");

/// Creates and returns a \c BibMARCInputStream for reading from the given input stream.
/// \param inputStream The \c NSInputStream object from which record data should be read.
/// \returns An initialized \c BibMARCInputStream object that reads \c BibRecord objects from the given input stream.
+ (instancetype)inputStreamWithInputStream:(NSInputStream *)inputStream NS_SWIFT_UNAVAILABLE("Use init(inputStream:)");

#pragma mark -

/// Open the input stream's resources to begin reading data.
///
/// Attempts to read data from an un-opened stream will fail, but will not set \c streamStatus or \c streamError to
/// reflect that error.
///
/// Once an input stream has been opened and closed, it cannot be opened again.
- (instancetype)open;

/// Close and release the input stream's resources to stop reading data.
///
/// Once an input stream has been opened and then closed, it cannot be opened again.
- (instancetype)close;

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
- (nullable BibRecord *)readRecord:(out NSError *_Nullable __autoreleasing *_Nullable)error NS_REFINED_FOR_SWIFT
    __attribute__((swift_error(nonnull_error)));

@end

/// An error encountered when reading a record from a \c BibMARCInputStream instance.
extern NSErrorDomain const BibMARCInputStreamErrorDomain;

/// The error code for an error in the \c BibMARCInputStreamErrorDomain error domain.
typedef NS_ERROR_ENUM(BibMARCInputStreamErrorDomain, BibMARCInputStreamErrorCode) {
    /// The input stream encountered conflicting or invalid data while reading MARC 21 record data.
    BibMARCInputStreamMalformedDataError NS_SWIFT_NAME(malformedData),

    /// The input stream reached the end of its data when more should have been available.
    BibMARCInputStreamPrematureEndOfDataError NS_SWIFT_NAME(prematureEndOfData),

    /// The input stream is not opened and therefore cannot read record data.
    BibMARCInputStreamNotOpenedError NS_SWIFT_NAME(notOpened)
} NS_SWIFT_NAME(MARC21ReaderError);

NS_ASSUME_NONNULL_END
