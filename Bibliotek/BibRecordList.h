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

NS_SWIFT_NAME(RecordList)
@interface BibRecordList : NSObject

@property(nonatomic, readonly, strong) BibConnection *connection;
@property(nonatomic, readonly, copy) BibFetchRequest *request;

@property(nonatomic, readonly, assign) NSUInteger count;
@property(nonatomic, readonly, strong) NSArray<BibRecordList *> *allRecords;

@property(nonatomic, readonly, strong, nullable) BibRecord *firstRecord NS_SWIFT_NAME(first);
@property(nonatomic, readonly, strong, nullable) BibRecord *lastRecord NS_SWIFT_NAME(last);

- (BibRecord *)recordAtIndex:(NSUInteger)index;
- (NSArray<BibRecord *> *)recordsInRange:(NSRange)range;
- (NSEnumerator<BibRecord *> *)recordEnumerator NS_SWIFT_NAME(makeIterator());

- (BibRecord *)objectAtIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
