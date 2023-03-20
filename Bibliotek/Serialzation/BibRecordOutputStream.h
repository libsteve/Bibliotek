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
/// ``BibRecordOutputStream`` is the abstract superclass for a class cluster of concrete
/// stream classes that specialize writing different encodings for MARC 21 records. You
/// can instantiate one of those concrete classes directly if you know the encoding, or
/// you can use this class to have the class cluster automatically infer the encoding
/// for you.
///
/// Custom subclasses of ``BibRecordOutputStream`` must provide implementations for
/// ``BibRecordOutputStream/streamStatus``, ``BibRecordOutputStream/streamError``,
/// ``BibRecordOutputStream/open``, ``BibRecordOutputStream/close``,
/// ``BibRecordOutputStream/hasSpaceAvailable``, ``BibRecordOutputStream/data``,
/// ``BibRecordOutputStream/initWithOutputStream:``, `-init`, and
/// ``BibRecordOutputStream/writeRecord:error:``.
NS_SWIFT_NAME(RecordOutputStream)
@interface BibRecordOutputStream : NSObject

/// The output stream's status.
///
/// No data can be written after ``streamStatus`` is set to `NSStreamStatusClosed` or
/// `NSStreamStatusError`.
@property (nonatomic, assign, readonly) NSStreamStatus streamStatus;

/// The output stream's error when its ``streamStatus`` is `NSStreamStatusError`.
///
/// No data can be written after ``streamError`` is set to a non-nil value.
@property (nonatomic, copy, readonly, nullable) NSError *streamError;

/// Is there space available to write more records to the stream?
///
/// `YES` is returned when there is more space available in the stream to write records,
/// or when the availability of space can't determined without attempting a write.
@property (nonatomic, assign, readonly) BOOL hasSpaceAvailable;

/// The data in memory where serialized `BibRecord` objects are written by the output
/// stream.
@property (nonatomic, readonly, nullable) NSData *data;

#pragma mark -

/// Initializes and returns a ``BibRecordOutputStream`` for writing to data in memory.
///
/// - returns: An initialized ``BibRecordOutputStream`` object that writes ``BibRecord``
///            objects to memory.
- (instancetype)initToMemory;

/// Initializes and returns a ``BibRecordOutputStream`` for writing to a file at the given
/// URL.
///
/// - parameter url: The URL to the file.
/// - parameter shouldAppend: Set to `YES` if new records should be appended to the file
///                           instead of overwriting its contents.
/// - returns: An initialized `BibRecordOutputStream` object that writes `BibRecord`
///            objects to the given URL.
- (instancetype)initWithURL:(NSURL *)url append:(BOOL)shouldAppend;

/// Initializes and returns a `BibRecordOutputStream` for writing to a file at the given
/// path.
///
/// - parameter path: The path to the file.
/// - parameter shouldAppend: Set to `YES` if new records should be appended to the file
///                      instead of overwriting its contents.
/// - returns: An initialized ``BibRecordOutputStream`` object that writes ``BibRecord``
///            objects to the given path.
- (nullable instancetype)initWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend;

/// Initializes and returns a `BibRecordOutputStream` for writing to the given input
/// stream.
///
/// - parameter outputStream: The `NSOutputStream` object to which record data should be
///                           written.
/// - returns: An initialized ``BibRecordOutputStream`` object that writes ``BibRecord``
///            objects to the given input stream.
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream;

#pragma mark -

/// Creates and returns a ``BibRecordOutputStream`` for writing to data in memory.
///
/// - returns: An initialized ``BibRecordOutputStream`` object that writes ``BibRecord``
///            objects to memory.
+ (instancetype)outputStreamToMemory NS_SWIFT_UNAVAILABLE("Use init(toMemory:)");

/// Creates and returns a ``BibMARCOutputStream`` for writing to a file at the given URL.
///
/// - parameter url: The URL to the file.
/// - parameter shouldAppend: Set to `YES` if new records should be appended to the file
///                           instead of overwriting its contents.
/// - returns: An initialized ``BibMARCOutputStream`` object that writes ``BibRecord``
///            objects to the given URL.
+ (instancetype)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend
    NS_SWIFT_UNAVAILABLE("Use init(url:append:)");

/// Creates and returns a ``BibMARCOutputStream`` for writing to a file at the given path.
///
/// - parameter path: The path to the file.
/// - parameter shouldAppend: Set to `YES` if new records should be appended to the file
///                           instead of overwriting its contents.
/// - returns: An initialized ``BibMARCOutputStream`` object that writes ``BibRecord``
///            objects to the given path.
+ (nullable instancetype)outputStreamWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend
    NS_SWIFT_UNAVAILABLE("Use init(fileAtPath:append:)");

/// Creates and returns a ``BibMARCOutputStream`` for writing to the given input stream.
/// 
/// - parameter outputStream: The `NSOutputStream` object to which record data should be
///                           written.
/// - returns: An initialized ``BibMARCOutputStream`` object that writes ``BibRecord``
///            objects to the given input stream.
+ (instancetype)outputStreamWithOutputStream:(NSOutputStream *)outputStream
    NS_SWIFT_UNAVAILABLE("Use init(outputStream:)");


#pragma mark -

/// Open the output stream's resources to begin writing data.
///
/// Attempts to write data to an un-opened stream will fail, but will not set
/// ``streamStatus`` or ``streamError`` to reflect that error.
///
/// Once an output stream has been opened and closed, it cannot be opened again.
- (instancetype)open;

/// Close and release the output stream's resources to stop writing data.
///
/// Once an output stream has been opened and then closed, it cannot be opened again.
- (instancetype)close;

/// Write an instance of ``BibRecord`` as MARC 21 data to the output stream.
///
/// - parameter record: The record to write to the output stream.
/// - parameter error: A pointer to an `NSError` variable that can be used to return an
///                    error value when `nil` is returned.
/// - returns: `YES` successfully written to the output stream. Otherwise, `NO` is
///            returned and, iif `error` is not `NULL`,its pointee is set to an `NSError`
///            object to indicate the reason for the failure. If there is no more space in
///            the output stream to write more records, `NO` is returned without setting
///            the `error` pointee to an `NSError` instance.
/// - precondition: If the output stream must be opened.
/// - postcondition: If the output stream is opened and `nil` is returned,
///                  ``streamStatus`` is set to `NSStreamStatusError`, and
///                  ``streamError`` is set to an `NSError` object that indicates the
///                  reason for the failure.
/// - note: If the output stream has not yet been opened, `nil` is returned with an error,
///         but ``streamStatus`` and ``streamError`` will not be set to reflect that
///         failure. Attempting to write to the output stream after it is opened will
///         continue to write data as though it did not previously encounter an error.
/// - note: If ``streamStatus`` is set to `NSStreamStatusAtEnd` when this method is
///         called, `nil` is returned, but no `NSError` is provided through the `error`
///         pointer.
- (BOOL)writeRecord:(BibRecord *)record error:(out NSError *_Nullable __autoreleasing *_Nullable)error
    NS_SWIFT_NAME(write(record:)) BIB_SWIFT_NONNULL_ERROR;

@end

NS_ASSUME_NONNULL_END
