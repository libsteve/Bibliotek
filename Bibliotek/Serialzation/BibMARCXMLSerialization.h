//
//  BibMARCXMLSerialization.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/6/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

@interface BibMARCXMLSerialization : NSObject

/// Create serialized data from an instance of \c BibRecord encoded as MARC 21 data.
/// \param record The record to encode as MARC 21 data.
/// \param error A pointer to an \c NSError variable that can be used to return an error value when \c nil is returned.
/// \returns An \c NSData object is returned when the record is successfully encoded as MARC 21 data. Otherwise, \c nil
///          is returned and, if \c error is not a \c NULL pointer, its pointee is set to an \c NSError object to
///          indicate the reason for the failure.
/// \post If \c nil is returned and \c error is not a \c NULL pointer, its pointee is set to an \c NSError object
///       to indicate the reason for the failure.
+ (nullable NSData *)dataWithRecord:(BibRecord *)record error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// Create serialized data from an array of \c BibRecord objects, encoded as MARC 21 data.
/// \param records The array of records to encode as MARC 21 data.
/// \param error A pointer to an \c NSError variable that can be used to return an error value when \c nil is returned.
/// \returns An \c NSData object is returned when the records are successfully encoded as MARC 21 data. Otherwise,
///          \c nil is returned and, if \c error is not a \c NULL pointer, its pointee is set to an \c NSError object
///          to indicate the reason for the failure.
/// \post If \c nil is returned and \c error is not a \c NULL pointer, its pointee is set to an \c NSError object
///       to indicate the reason for the failure.
+ (nullable NSData *)dataWithRecordsInArray:(NSArray<BibRecord *> *)records
                                      error:(out NSError *_Nullable __autoreleasing *_Nullable)error
    NS_SWIFT_NAME(data(with:));

+ (nullable NSArray<BibRecord *> *)recordsFromData:(NSData *)data
                                             error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

+ (nullable BibRecord *)recordFromStream:(NSInputStream *)inputStream
                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
