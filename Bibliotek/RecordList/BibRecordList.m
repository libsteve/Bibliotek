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
#import "BibRecord.h"
#import "BibRecordList.h"
#import "BibRecordList+Private.h"
#import "BibMARCInputStream.h"
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
    NSArray *_allRecords;
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

- (BibRecord *)firstRecord {
    return ([self count] == 0) ? nil : [self recordAtIndex:0];
}

- (BibRecord *)lastRecord {
    NSUInteger const count = [self count];
    return (count == 0) ? nil : [self recordAtIndex:count - 1];
}

- (NSArray<BibRecord *> *)allRecords {
    return [self valueForKey:@"allRecordsProxy"];
}

- (NSUInteger)countOfAllRecordsProxy {
    return [self count];
}

- (NSArray *)allRecordsProxyAtIndexes:(NSIndexSet *)indexes {
    return [self recordsAtIndexes:indexes];
}

- (BibRecord *)objectInAllRecordsProxyAtIndex:(NSUInteger)index {
    return [self recordAtIndex:index];
}

- (void)getAllRecordsProxy:(BibRecord **)buffer range:(NSRange)inRange {
    for (NSUInteger offset = 0; offset < inRange.length; offset += 1) {
        buffer[offset] = [self recordAtIndex:(inRange.location + offset)];
    }
}

- (NSEnumerator<BibRecord *> *)recordEnumerator {
    return [[BibRecordListEnumerator alloc] initWithRecordList:self];
}

- (BibRecord *)marcRecordFromZoomRecord:(ZOOM_record)zoomRecord {
    int length = 0;
    char const *const type = "raw; charset=utf8";
    char const *const bytes = ZOOM_record_get(zoomRecord, type, &length);
    NSData *const data = [NSData dataWithBytes:bytes length:length];
    BibMARCInputStream *const inputStream = [[BibMARCInputStream alloc] initWithData:data];
    BibRecord *const record = [[inputStream open] readRecord:NULL];
    return record;
}

- (BibRecord *)recordAtIndex:(NSUInteger)index {
    BibAssert(index < [self count], NSRangeException, @"-[%@ %s]: index %lu beyond bounds (0 ..< %lu)", [self className], sel_getName(_cmd), (unsigned long)index, (unsigned long)[self count]);
    ZOOM_record const zoomRecord = ZOOM_resultset_record(_resultset, (size_t)index);
    return [self marcRecordFromZoomRecord:zoomRecord];
}

- (NSArray<BibRecord *> *)recordsAtIndexes:(NSIndexSet *)indexes {
    NSMutableArray *array = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *_Nonnull stop) {
        [array addObject:[self recordAtIndex:index]];
    }];
    return [array copy];
}

- (NSArray<BibRecord *> *)recordsInRange:(NSRange)range {
    BibAssert(range.location + range.length <= [self count], NSRangeException, @"-[%@ %s]: NSRange(location: %lu, length: %lu) beyond bounds (0 ..< %lu)", [self className], sel_getName(_cmd), (unsigned long)range.location, (unsigned long)range.length, (long)[self count]);
    NSMutableArray *const array = [NSMutableArray array];
    ZOOM_record *const buffer = calloc(sizeof(ZOOM_record), range.length);
    ZOOM_resultset_records(_resultset, buffer, (size_t)range.location, (size_t)range.location);
    for (NSUInteger index = 0; index < range.location; index += 1) {
        ZOOM_record const zoomRecord = buffer[index];
        if (zoomRecord == NULL) { break; }
        BibRecord *const record = [self marcRecordFromZoomRecord:zoomRecord];
        [array addObject:record];
    }
    free(buffer);
    return [array copy];
}

- (BibRecord *)objectAtIndexedSubscript:(NSUInteger)index {
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

- (BibRecord *)nextObject {
    if (_index >= _records.count) { return nil; }
    BibRecord * record = [_records recordAtIndex:_index];
    _index += 1;
    return record;
}

- (id)copyWithZone:(NSZone *)zone {
    BibRecordListEnumerator *const enumerator = [[BibRecordListEnumerator alloc] initWithRecordList:_records];
    enumerator->_index = _index;
    return enumerator;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}

@end
