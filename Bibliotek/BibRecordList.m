//
//  BibRecordList.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/27/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnection.h"
#import "BibConnection+Private.h"
#import "BibFetchRequest.h"
#import "BibFetchRequest+Private.h"
#import "BibMarcRecord.h"
#import "BibMarcRecord+Private.h"
#import "BibRecordList.h"
#import "BibRecordList+Private.h"
#import <yaz/zoom.h>

#define BibAssert(condition, exception, message, ...) ({ \
    if (!(condition)) { \
        [NSException raise:exception format:message, ## __VA_ARGS__]; \
    } \
})

@implementation BibRecordList {
    ZOOM_resultset _resultset;
    BibConnection *_connection;
    BibFetchRequest *_request;
}

@synthesize connection = _connection;
@synthesize request = _request;

- (NSUInteger)count {
    return (NSUInteger)ZOOM_resultset_size(_resultset);
}

- (instancetype)initWithZoomResultSet:(ZOOM_resultset)resultset
                           connection:(BibConnection *)connection
                              request:(BibFetchRequest *)request {
    if (self = [super init]) {
        _connection = connection;
        _request = [request copy];
        _resultset = resultset;
    }
    return self;
}

- (void)dealloc {
    ZOOM_resultset_destroy(_resultset);
}

- (BibFetchRequest *)request {
    return [_request copy];
}

- (id<BibRecord>)firstRecord {
    return ([self count] == 0) ? nil : [self recordAtIndex:0];
}

- (id<BibRecord>)lastRecord {
    NSUInteger const count = [self count];
    return (count == 0) ? nil : [self recordAtIndex:count - 1];
}

- (NSArray<id<BibRecord>> *)allRecords {
    return [[self recordEnumerator] allObjects];
}

- (NSEnumerator<id<BibRecord>> *)recordEnumerator {
    return [[BibRecordListEnumerator alloc] initWithRecordList:self];
}

- (id<BibRecord>)recordAtIndex:(NSUInteger)index {
    BibAssert(index < [self count], NSRangeException, @"-[%@ %s]: index %lu beyond bounds (0 ..< %lu)", [self className], sel_getName(_cmd), (unsigned long)index, (unsigned long)[self count]);
    ZOOM_record record = ZOOM_resultset_record(_resultset, (size_t)index);
    return [[BibMarcRecord alloc] initWithZoomRecord:record];
}

- (NSArray<id<BibRecord>> *)recordsAtIndexes:(NSIndexSet *)indexes {
    NSMutableArray *array = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *_Nonnull stop) {
        [array addObject:[self recordAtIndex:index]];
    }];
    return [array copy];
}

- (NSArray<id<BibRecord>> *)recordsInRange:(NSRange)range {
    BibAssert(range.location + range.length <= [self count], NSRangeException, @"-[%@ %s]: NSRange(location: %lu, length: %lu) beyond bounds (0 ..< %lu)", [self className], sel_getName(_cmd), (unsigned long)range.location, (unsigned long)range.length, (long)[self count]);
    NSMutableArray *array = [NSMutableArray array];
    ZOOM_record *buffer = calloc(sizeof(ZOOM_record), range.length);
    ZOOM_resultset_records(_resultset, buffer, (size_t)range.location, (size_t)range.location);
    for (NSUInteger index = 0; index < range.location; index += 1) {
        ZOOM_record record = buffer[index];
        if (record == NULL) { break; }
        [array addObject:[[BibMarcRecord alloc] initWithZoomRecord:record]];
    }
    free(buffer);
    return [array copy];
}

- (id<BibRecord>)objectAtIndexedSubscript:(NSUInteger)index {
    return [self recordAtIndex:index];
}

- (NSString *)description {
    return [[self allRecords] description];
}

- (NSString *)debugDescription {
    return [[self allRecords] debugDescription];
}

@end

#pragma mark - Record Enumerator

@implementation BibRecordListEnumerator {
    BibRecordList *_records;
    NSInteger _index;
}

- (instancetype)initWithRecordList:(BibRecordList *)recordList {
    if (self = [super init]) {
        _records = recordList;
    }
    return self;
}

- (id<BibRecord>)nextObject {
    if (_index >= _records.count) { return nil; }
    id<BibRecord> record = [_records recordAtIndex:_index];
    _index += 1;
    return record;
}

@end
