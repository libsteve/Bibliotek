//
//  BibRecordList.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/27/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibConnection;
@class BibFetchRequest;
@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// A collection of records fetched from a z39.50 server's database.
NS_SWIFT_NAME(RecordList)
@interface BibRecordList : NSObject

/// The connection used to fetch these records.
@property(nonatomic, readonly, strong) BibConnection *connection;

/// The fetch request that these records match.
@property(nonatomic, readonly, copy) BibFetchRequest *request;

/// The amount of records contained within this collection.
@property(nonatomic, readonly, assign) NSUInteger count NS_REFINED_FOR_SWIFT;

/// A list of all records in this collection.
@property(nonatomic, readonly, strong) NSArray<BibRecord *> *allRecords NS_REFINED_FOR_SWIFT;

/// The first record in the collection.
@property(nonatomic, readonly, strong, nullable) BibRecord *firstRecord NS_REFINED_FOR_SWIFT;

/// The last record in the collection.
@property(nonatomic, readonly, strong, nullable) BibRecord *lastRecord NS_REFINED_FOR_SWIFT;

/// Access the record located at a given index.
/// \param index The 0-indexed location within the collection from which to access the record.
/// \returns The record at that location in the collection.
- (BibRecord *)recordAtIndex:(NSUInteger)index NS_REFINED_FOR_SWIFT;

/// Access a subset of records located within the given range.
/// \param range A range of indices within the collection.
/// \returns A list of records which are a subset of the collection at the given indices.
- (NSArray<BibRecord *> *)recordsInRange:(NSRange)range NS_REFINED_FOR_SWIFT;

/// Generate an object to iterate over the records in the collection.
- (NSEnumerator<BibRecord *> *)recordEnumerator NS_REFINED_FOR_SWIFT;

/// Access the record located at a given index.
/// \param index The 0-indexed location within the collection from which to access the record.
/// \returns The record at that location in the collection.
- (BibRecord *)objectAtIndexedSubscript:(NSUInteger)index NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
