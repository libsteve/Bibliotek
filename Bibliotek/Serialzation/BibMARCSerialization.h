//
//  BibMARCSerialization.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/26/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// An object that encodes ``BibRecord`` instances as MARC 21 data, and visa-versa.
///
/// MARC 21 is a data format designed to facilitate the exchange of bibliographic,
/// classification, and other information between libraries through electronic means,
/// using a standardized compact digital representation.
///
/// More information about the MARC 21 format can be found in the Library of Congress's
/// documentation on [MARC 21 Record Structure][specification].
///
/// [specification]: https://www.loc.gov/marc/specifications/spechome.html
NS_SWIFT_NAME(MARCSerialization)
@interface BibMARCSerialization : NSObject

/// Create serialized data from an instance of `BibRecord` encoded as MARC 21 data.
///
/// - parameter record: The record to encode as MARC 21 data.
/// - parameter error: A pointer to an `NSError` variable that can be used to return an
///                    error value when `nil` is returned.
/// - returns: An `NSData` object is returned when the record is successfully encoded as
///            MARC 21 data. Otherwise, `nil` is returned and, if `error` is not a `NULL`
///            pointer, its pointee is set to an `NSError` object to indicate the reason
///            for the failure.
/// - postcondition: If `nil` is returned and `error` is not a `NULL` pointer, its pointee
///                  is set to an `NSError` object to indicate the reason for the failure.
+ (nullable NSData *)dataWithRecord:(BibRecord *)record error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// Create serialized data from an array of ``BibRecord`` objects, encoded as MARC 21 data.
///
/// - parameter records: The array of records to encode as MARC 21 data.
/// - parameter error: A pointer to an `NSError` variable that can be used to return an
///                    error value when `nil` is returned.
/// - returns: An `NSData` object is returned when the records are successfully encoded as
///            MARC 21 data. Otherwise, `nil` is returned and, if `error` is not a `NULL`
///            pointer, its pointee is set to an `NSError` object to indicate the reason
///            for the failure.
/// - postcondition: If `nil` is returned and `error` is not a `NULL` pointer, its pointee
///                  is set to an `NSError` object to indicate the reason for the failure.
+ (nullable NSData *)dataWithRecordsInArray:(NSArray<BibRecord *> *)records
                                      error:(out NSError *_Nullable __autoreleasing *_Nullable)error
    NS_SWIFT_NAME(data(with:));

/// Create an array of `BibRecord` objects from MARC 21 encoded data.
///
/// - parameter data: The MARC 21 encoded data containing serialized representations of
///                   records.
/// - parameter error: A pointer to an `NSError` variable that can be used to return an
///                    error value when `nil` is returned.
/// - returns: An array of `BibRecord` objects is returned when records could be
///            successfully deserialized from the data. Otherwise, `nil` is returned and,
///            if `error` is not a `NULL` pointer, its pointee is set to an `NSError`
///            object to indicate the reason for the failure.
/// - postcondition: If `nil` is returned and `error` is not a `NULL` pointer, its pointee
///                  is set to an `NSError` object to indicate the reason for the failure.
+ (nullable NSArray<BibRecord *> *)recordsFromData:(NSData *)data
                                             error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// Write an instance of `BibRecord` as MARC 21 data to the given output stream.
///
/// - parameter record: The record to write to the output stream.
/// - parameter outputStream: The output stream to write the MARC 21 encoded data to.
/// - parameter error: A pointer to an `NSError` variable that can be used to return an
///                    error value when `nil` is returned.
/// - returns: `YES` is returned when the record is successfully written to the output
///            stream. Otherwise, `NO` is returned and, if `error` is not a `NULL`
///            pointer, its pointee is set to an `NSError` object to indicate the reason
///            for the failure.
/// - precondition: If the output stream must be opened.
/// - postcondition: If `nil` is returned and `error` is not a `NULL` pointer, its pointee
///                  is set to an `NSError` object
///       to indicate the reason for the failure.
+ (BOOL)writeRecord:(BibRecord *)record
           toStream:(NSOutputStream *)outputStream
              error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// Read an instance of `BibRecord` from the MARC 21 data in the given input stream.
/// - parameter inputStream: The input stream to read the MARC 21 encoded data from.
/// - parameter error: A pointer to an `NSError` variable that can be used to return an
///                    error value when `nil` is returned.
/// - returns: A `BibRecord` object is returned when a record is successfully read from
///            the input stream. Otherwise, `nil` is returned and, if `error` is not
///            `NULL`,its pointee is set to an `NSError` object to indicate the reason for
///            the failure.
/// - precondition: If the input stream must be opened.
/// - postcondition: If `nil` is returned and `error` is not a `NULL` pointer, its pointee
///                  is set to an `NSError` object
///       to indicate the reason for the failure.
+ (nullable BibRecord *)recordFromStream:(NSInputStream *)inputStream
                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

/// An error encountered when using \c BibMARCSerialization to encode or decode a record.
extern NSErrorDomain const BibMARCSerializationErrorDomain;

/// The error code for an error in the \c BibMARCSerializationErrorDomain error domain.
typedef NS_ERROR_ENUM(BibMARCSerializationErrorDomain, BibMARCSerializationErrorCode) {
    /// The serializer encountered conflicting or invalid data with the MARC 21 record data.
    BibMARCSerializationMalformedDataError NS_SWIFT_NAME(malformedData),

    /// The serializer reached the end of its given data when more was expected.
    BibMARCSerializationMissingDataError NS_SWIFT_NAME(missingData),

    /// The input or output stream is not opened and therefore cannot be used to read or write record data.
    BibMARCSerializationStreamNotOpenedError NS_SWIFT_NAME(streamNotOpened),

    /// The input or output stream was at the end of its available data before the record could be read or written.
    BibMARCSerializationStreamAtEndError NS_SWIFT_NAME(streamAtEnd),

    /// The input or output stream is buys reading, writing, or opening,
    /// and is therefore blocked from reading or writing data.
    BibMARCSerializationStreamBusyError NS_SWIFT_NAME(streamBusy)
} NS_SWIFT_NAME(MARCSerializationError);


NS_ASSUME_NONNULL_END
