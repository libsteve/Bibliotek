//
//  BibQuery.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/14/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibQuery.h"
#import "BibQuery.Private.h"
#import <yaz/zoom.h>

@implementation BibQuery {
    ZOOM_query _zoom_query;
}

@synthesize zoomQuery = _zoom_query;

#pragma mark - Initialization

- (instancetype)initWithQuery:(NSString *)query notation:(BibQueryNotation)notation {
    if (self = [super init]) {
        _query = [query copy];
        _notation = notation;
        _zoom_query = ZOOM_query_create();
        char const *const rawQuery = [_query cStringUsingEncoding:NSUTF8StringEncoding];
        switch (notation) {
        case BibQueryNotationPqf:
            ZOOM_query_prefix(_zoom_query, rawQuery);
            break;
        case BibQueryNotationCql:
            ZOOM_query_cql(_zoom_query, rawQuery);
            break;
        }
    }
    return self;
}

- (void)dealloc {
    ZOOM_query_destroy(_zoom_query);
}

#pragma mark - Sorting

- (void)setCriteria:(NSString *)criteria {
    NSString *const key = NSStringFromSelector(@selector(criteria));
    [self willChangeValueForKey:key];
    _criteria = [criteria copy];
    char const *const rawCriteria = [_criteria cStringUsingEncoding:NSUTF8StringEncoding];
    char const *const strategy = [_strategy cStringUsingEncoding:NSUTF8StringEncoding];
    ZOOM_query_sortby2(_zoom_query, strategy, rawCriteria);
    [self didChangeValueForKey:key];
}

- (void)setStrategy:(BibSortStrategy)strategy {
    NSString *const key = NSStringFromSelector(@selector(strategy));
    [self willChangeValueForKey:key];
    _strategy = [strategy copy];
    char const *const rawStrategy = [_strategy cStringUsingEncoding:NSUTF8StringEncoding];
    char const *const criteria = [_criteria cStringUsingEncoding:NSUTF8StringEncoding];
    ZOOM_query_sortby2(_zoom_query, rawStrategy, criteria);
    [self didChangeValueForKey:key];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    BibQuery *query = [[BibQuery alloc] initWithQuery:_query notation:_notation];
    query.criteria = _criteria;
    query.strategy = _strategy;
    return query;
}

@end

BibSortStrategy const BibSortStrategyZ3950 = @"z39.50";
BibSortStrategy const BibSortStrategyType7 = @"type7";
BibSortStrategy const BibSortStrategyCql = @"cql";
BibSortStrategy const BibSortStrategySrull = @"srull";
BibSortStrategy const BibSortStrategySolr = @"solr";
BibSortStrategy const BibSortStrategyEmbed = @"embed";
