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
@protocol BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// A collection of records fetched from a z39.50 server's database.
NS_SWIFT_NAME(RecordList)
@interface BibRecordList : NSObject

/// The connection used to fetch these records.
@property(nonatomic, readonly, strong) BibConnection *connection;

/// The fetch request that these records match.
@property(nonatomic, readonly, copy) BibFetchRequest *request;

/// The amount of records contained within this collection.
@property(nonatomic, readonly, assign) NSUInteger count;

/// A list of all records in this collection.
@property(nonatomic, readonly, strong) NSArray<id<BibRecord>> *allRecords;

/// The first record in the collection.
@property(nonatomic, readonly, strong, nullable) id<BibRecord> firstRecord NS_SWIFT_NAME(first);

/// The last record in the collection.
@property(nonatomic, readonly, strong, nullable) id<BibRecord> lastRecord NS_SWIFT_NAME(last);

/// Access the record located at a given index.
/// \param index The 0-indexed location within the collection from which to access the record.
/// \returns The record at that location in the collection.
- (id<BibRecord>)recordAtIndex:(NSUInteger)index NS_SWIFT_NAME(record(at:));

/// Access a subset of records located within the given range.
/// \param range A range of indices within the collection.
/// \returns A list of records which are a subset of the collection at the given indices.
- (NSArray<id<BibRecord>> *)recordsInRange:(NSRange)range NS_SWIFT_NAME(records(in:));

/// Generate an object to iterate over the records in the collection.
- (NSEnumerator<id<BibRecord>> *)recordEnumerator NS_REFINED_FOR_SWIFT;

/// Access the record located at a given index.
/// \param index The 0-indexed location within the collection from which to access the record.
/// \returns The record at that location in the collection.
- (id<BibRecord>)objectAtIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
