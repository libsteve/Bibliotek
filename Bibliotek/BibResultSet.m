//
//  BibResultSet.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibResultSet.h"
#import "BibResultSet.Private.h"
#import "BibConnection.h"
#import "BibConnection.Private.h"
#import "BibQuery.h"
#import "BibQuery.Private.h"
#import "BibRecord.h"
#import "BibRecord.Private.h"
#import <yaz/zoom.h>

@implementation BibResultSet {
    ZOOM_resultset _resultSet;
    BibConnection *_connection;
    BibQuery *_query;
}

#pragma mark - Initialization

- (instancetype)initWithConnection:(BibConnection *)connection query:(BibQuery *)query {
    if (self = [super init]) {
        _connection = connection;
        _query = query;
        _resultSet = ZOOM_connection_search(_connection.zoomConnection, _query.zoomQuery);
    }
    return self;
}

- (void)dealloc {
    ZOOM_resultset_destroy(_resultSet);
}

#pragma mark - Records

- (NSArray<BibRecord *> *)records {
    NSMutableArray *array = [NSMutableArray new];
    size_t const count = ZOOM_resultset_size(_resultSet);
    ZOOM_record *buffer = calloc(count, sizeof(ZOOM_record));
    ZOOM_resultset_records(_resultSet, buffer, 0, count);
    for (int i = 0; i < count; i += 1) {
        ZOOM_record const record = buffer[i];
        if (record == nil) { break; }
        [array addObject:[[BibRecord alloc] initWithZoomRecord:record]];
    }
    free(buffer);
    return [array copy];
}

- (BibRecord *)objectAtIndexedSubscript:(int)index {
    ZOOM_record record = ZOOM_resultset_record(_resultSet, (size_t)index);
    return [[BibRecord alloc] initWithZoomRecord:record];
}

@end
