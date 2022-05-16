//
//  BibRecordInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/6/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// An abstract class for a read-only stream of MARC records from encoded data.
///
/// \c BibRecordInputStream is the abstract superclass for a class cluster of concrete
/// stream classes that specialize reading different encodings for MARC 21 records. You
/// can instantiate one of those concrete classes directly if you know the encoding, or
/// you can use this class to have the class cluster automatically infer the encoding
/// for you.
///
/// \note Custom subclasses of \c RecordInputStream must provide implementations for
///       \c -streamStatus \c streamError \c -open \c -close \c -initWithInputStream:
///       \c -init and \c -readRecord:error:
NS_SWIFT_NAME(RecordInputStream)
@interface BibRecordInputStream : NSObject

/// The input stream's status.
///
/// No data can be read after \c streamStatus is set to \c NSStreamStatusClosed or \c NSStreamStatusError.
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

/// Initializes and returns a \c BibRecordInputStream for reading from a file at the given URL.
/// \param url The URL to the file.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given URL.
- (instancetype)initWithURL:(NSURL *)url;

/// Initializes and returns a \c BibRecordInputStream for reading from the given data.
/// \param data The data object to read records from. The contents of \c data are copied.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given data.
- (instancetype)initWithData:(NSData *)data;

/// Initializes and returns a \c BibRecordInputStream for reading from a file at the given path.
/// \param path The path to the file.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given path.
- (nullable instancetype)initWithFileAtPath:(NSString *)path;

/// Initializes and returns a \c BibRecordInputStream for reading from the given input stream.
/// \param inputStream The \c NSInputStream object from which record data should be read.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given input stream.
- (instancetype)initWithInputStream:(NSInputStream *)inputStream;

#pragma mark -

/// Creates and returns a \c BibRecordInputStream for reading from a file at the given URL.
/// \param url The URL to the file.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given URL.
+ (instancetype)inputStreamWithURL:(NSURL *)url NS_SWIFT_UNAVAILABLE("Use init(url:)");

/// Creates and returns a \c BibRecordInputStream for reading from the given data.
/// \param data The data object to read records from. The contents of \c data are copied.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given data.
+ (instancetype)inputStreamWithData:(NSData *)data NS_SWIFT_UNAVAILABLE("Use init(data:)");

/// Creates and returns a \c BibRecordInputStream for reading from a file at the given path.
/// \param path The path to the file.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given path.
+ (nullable instancetype)inputStreamWithFileAtPath:(NSString *)path NS_SWIFT_UNAVAILABLE("Use init(fileAtPath:)");

/// Creates and returns a \c BibRecordInputStream for reading from the given input stream.
/// \param inputStream The \c NSInputStream object from which record data should be read.
/// \returns An initialized \c BibRecordInputStream object that reads \c BibRecord objects from the given input stream.
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
- (BOOL)readRecord:(out BibRecord *_Nullable __autoreleasing *_Nullable)record
             error:(out NSError *_Nullable __autoreleasing *_Nullable)error BIB_SWIFT_NONNULL_ERROR;

@end

NS_ASSUME_NONNULL_END
