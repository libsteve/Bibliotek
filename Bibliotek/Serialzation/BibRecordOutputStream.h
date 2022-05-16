//
//  BibRecordOutputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/8/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// An abstract class for a write-only stream of MARC records as encoded data.
///
/// \c BibRecordOutputStream is the abstract superclass for a class cluster of concrete
/// stream classes that specialize writing different encodings for MARC 21 records. You
/// can instantiate one of those concrete classes directly if you know the encoding, or
/// you can use this class to have the class cluster automatically infer the encoding
/// for you.
///
/// \note Custom subclasses of \c RecordInputStream must provide implementations for
///       \c -streamStatus \c streamError \c -open \c -close \c -hasSpaceAvailable
///       \c -data\c -initWithOutputStream: \c -init and \c -writeRecord:error:
NS_SWIFT_NAME(RecordOutputStream)
@interface BibRecordOutputStream : NSObject

/// The output stream's status.
///
/// No data can be written after \c streamStatus is set to \c NSStreamStatusClosed or \c NSStreamStatusError.
@property (nonatomic, assign, readonly) NSStreamStatus streamStatus;

/// The output stream's error when its \c status is \c NSStreamStatusError.
///
/// No data can be written after \c streamError is set to a non-nil value.
@property (nonatomic, copy, readonly, nullable) NSError *streamError;

/// Is there space available to write more records to the stream?
///
/// \c YES is returned when there is more space available in the stream to write records,
/// or when the availability of space can't determined without attempting a write.
@property (nonatomic, assign, readonly) BOOL hasSpaceAvailable;

/// The data in memory where serialized \c BibRecord objects are written by the output stream.
@property (nonatomic, readonly, nullable) NSData *data;

#pragma mark -

/// Initializes and returns a \c BibRecordOutputStream for writing to data in memory.
/// \returns An initialized \c BibRecordOutputStream object that writes \c BibRecord objects to memory.
- (instancetype)initToMemory;

/// Initializes and returns a \c BibRecordOutputStream for writing to a file at the given URL.
/// \param url The URL to the file.
/// \param shouldAppend Set to \c YES if new records should be appended to the file instead of overwriting its contents.
/// \returns An initialized \c BibRecordOutputStream object that writes \c BibRecord objects to the given URL.
- (instancetype)initWithURL:(NSURL *)url append:(BOOL)shouldAppend;

/// Initializes and returns a \c BibRecordOutputStream for writing to a file at the given path.
/// \param path The path to the file.
/// \param shouldAppend Set to \c YES if new records should be appended to the file instead of overwriting its contents.
/// \returns An initialized \c BibRecordOutputStream object that writes \c BibRecord objects to the given path.
- (nullable instancetype)initWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend;

/// Initializes and returns a \c BibRecordOutputStream for writing to the given input stream.
/// \param outputStream The \c NSOutputStream object to which record data should be written.
/// \returns An initialized \c BibRecordOutputStream object that writes \c BibRecord objects to the given input stream.
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream;

#pragma mark -

/// Creates and returns a \c BibRecordOutputStream for writing to data in memory.
/// \returns An initialized \c BibRecordOutputStream object that writes \c BibRecord objects to memory.
+ (instancetype)outputStreamToMemory NS_SWIFT_UNAVAILABLE("Use init(toMemory:)");

/// Creates and returns a \c BibMARCOutputStream for writing to a file at the given URL.
/// \param url The URL to the file.
/// \param shouldAppend Set to \c YES if new records should be appended to the file instead of overwriting its contents.
/// \returns An initialized \c BibMARCOutputStream object that writes \c BibRecord objects to the given URL.
+ (instancetype)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend
    NS_SWIFT_UNAVAILABLE("Use init(url:append:)");

/// Creates and returns a \c BibMARCOutputStream for writing to a file at the given path.
/// \param path The path to the file.
/// \param shouldAppend Set to \c YES if new records should be appended to the file instead of overwriting its contents.
/// \returns An initialized \c BibMARCOutputStream object that writes \c BibRecord objects to the given path.
+ (nullable instancetype)outputStreamWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend
    NS_SWIFT_UNAVAILABLE("Use init(fileAtPath:append:)");

/// Creates and returns a \c BibMARCOutputStream for writing to the given input stream.
/// \param outputStream The \c NSOutputStream object to which record data should be written.
/// \returns An initialized \c BibMARCOutputStream object that writes \c BibRecord objects to the given input stream.
+ (instancetype)outputStreamWithOutputStream:(NSOutputStream *)outputStream
    NS_SWIFT_UNAVAILABLE("Use init(outputStream:)");


#pragma mark -

/// Open the output stream's resources to begin writing data.
///
/// Attempts to write data to an un-opened stream will fail, but will not set \c streamStatus or \c streamError to
/// reflect that error.
///
/// Once an output stream has been opened and closed, it cannot be opened again.
- (instancetype)open;

/// Close and release the output stream's resources to stop writing data.
///
/// Once an output stream has been opened and then closed, it cannot be opened again.
- (instancetype)close;

/// Write an instance of \c BibRecord as MARC 21 data to the output stream.
/// \param record The record to write to the output stream.
/// \param error A pointer to an \c NSError variable that can be used to return an error value when \c nil is returned.
/// \returns \c YES successfully written to the output stream. Otherwise, \c NO is returned and, iif \c error is not
///          \c NULL, its pointee is set to an \c NSError object to indicate the reason for the failure.
///          If there is no more space in the output stream to write more records, \c NO is returned without setting
///          the \c error pointee to an \c NSError instance.
/// \pre If the output stream must be opened.
/// \post If the output stream is opened and \c nil is returned, \c streamStatus is set to \c NSStreamStatusError, and
///       \c streamError is set to an \c NSError object that indicates the reason for the failure.
/// \note If the output stream has not yet been opened, \c nil is returned with an error, but \c streamStatus and
///       \c streamError will not be set to reflect that failure. Attempting to write to the output stream after it is
///       opened will continue to write data as though it did not previously encounter an error.
/// \note If \c streamStatus is set to \c NSStreamStatusAtEnd when this method is called, \c nil is returned, but no
///       \c NSError is provided through the \c error pointer.
- (BOOL)writeRecord:(BibRecord *)record error:(out NSError *_Nullable __autoreleasing *_Nullable)error
    NS_SWIFT_NAME(write(record:)) BIB_SWIFT_NONNULL_ERROR;

@end

NS_ASSUME_NONNULL_END
