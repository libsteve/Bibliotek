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

/// Create serialized data from an instance of ``BibRecord`` encoded as MARC 21 data.
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

/// Create serialized data from an array of `BibRecord` objects, encoded as MARC 21 data.
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

+ (nullable NSArray<BibRecord *> *)recordsFromData:(NSData *)data
                                             error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

+ (nullable BibRecord *)recordFromStream:(NSInputStream *)inputStream
                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
