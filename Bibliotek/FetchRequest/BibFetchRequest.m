//
//  BibFetchRequest.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibFetchRequest+Private.h"

@implementation BibFetchRequest {
@protected
    BibFetchRequestScope _scope;
    BibFetchRequestStructure _structure;
    BibFetchRequestSearchStrategy _strategy;
    NSArray *_keywords;
    NSString *_query;
    ZOOM_query _zoom_query;
}

@synthesize zoomQuery = _zoom_query;

- (instancetype)init {
    return [self initWithKeywords:@[] scope:BibFetchRequestScopeAny];
}

- (instancetype)initWithKeywords:(NSArray<NSString *> *)keywords scope:(BibFetchRequestScope)scope {
    return [self initWithKeywords:keywords scope:scope structure:BibFetchRequestStructurePhrase strategy:BibFetchRequestSearchStrategyStrict];
}

- (instancetype)initWithKeywords:(NSArray<NSString *> *)keywords scope:(BibFetchRequestScope)scope structure:(BibFetchRequestStructure)structure strategy:(BibFetchRequestSearchStrategy)strategy {
    if (self = [super init]) {
        _scope = scope;
        _structure = structure;
        _strategy = strategy;
        _keywords = [keywords copy];
        _query = [self query];
        _zoom_query = ZOOM_query_create();
        ZOOM_query_prefix(_zoom_query, [_query UTF8String]);
    }
    return self;
}

- (instancetype)initWithRequest:(BibFetchRequest *)request {
    return [self initWithKeywords:[request keywords] scope:[request scope] structure:[request structure] strategy:[request strategy]];
}

- (void)dealloc {
    ZOOM_query_destroy(_zoom_query);
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibFetchRequest allocWithZone:zone] initWithRequest:self];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableFetchRequest allocWithZone:zone] initWithRequest:self];
}

- (NSString *)query {
    if (_query) { return _query; }
    NSString *searchString = nil;
    switch (_keywords.count) {
        case 0:
            searchString = @"";
            break;
        case 1:
            searchString = _keywords.firstObject;
            break;
        default: {
            NSMutableString *phrase = [NSMutableString string];
            for (NSString *word in _keywords.objectEnumerator) {
                if (phrase.length > 0) {
                    [phrase appendString:@" "];
                }
                [phrase appendString:word];
            }
            searchString = [phrase copy];
        }
    }
    return [NSString stringWithFormat:@"%@ %@ %@ %@", _scope, _structure, _strategy, searchString];
}

@end

@implementation BibMutableFetchRequest

@dynamic scope;
- (void)setScope:(BibFetchRequestScope)scope {
    _query = nil;
    _scope = scope;
    ZOOM_query_prefix(_zoom_query, [[self query] UTF8String]);
}

@dynamic structure;
- (void)setStructure:(BibFetchRequestStructure)structure {
    _query = nil;
    _structure = structure;
    ZOOM_query_prefix(_zoom_query, [[self query] UTF8String]);
}

@dynamic strategy;
- (void)setStrategy:(BibFetchRequestSearchStrategy)strategy {
    _query = nil;
    _strategy = strategy;
    ZOOM_query_prefix(_zoom_query, [[self query] UTF8String]);
}

@dynamic keywords;
- (void)setKeywords:(NSArray<NSString *> *)keywords {
    _query = nil;
    _keywords = [keywords copy];
    ZOOM_query_prefix(_zoom_query, [[self query] UTF8String]);
}

@end
