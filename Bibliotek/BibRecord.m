//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassification.h"
#import "BibClassification.Private.h"
#import "BibRecord.h"
#import "BibRecord.Private.h"
#import <yaz/zoom.h>

@implementation BibRecord {
    ZOOM_record _record;
    NSDictionary *_json;
}

@synthesize zoomRecord = _record;

#pragma mark - Initialization

- (instancetype)initWithZoomRecord:(ZOOM_record)zoomRecord {
    if (self = [super init]) {
        _record = ZOOM_record_clone(zoomRecord);
    }
    return self;
}

- (void)dealloc {
    ZOOM_record_destroy(_record);
}

#pragma mark - Properties

@synthesize syntax = _syntax;

- (NSString *)syntax {
    if (_syntax == nil) {
        char const *const type = "syntax";
        int length = 0;
        char const *const value = ZOOM_record_get(_record, type, &length);
        if (value == NULL) { return nil; }
        _syntax = [NSString stringWithUTF8String:value];
    }
    return _syntax;
}

@synthesize schema = _schema;

- (NSString *)schema {
    if (_schema == nil) {
        char const *const type = "schema";
        int length = 0;
        char const *const value = ZOOM_record_get(_record, type, &length);
        if (value == NULL) { return nil; }
        _schema = [NSString stringWithUTF8String:value];
    }
    return _schema;
}

@synthesize database = _database;

- (NSString *)database {
    if (_database == nil) {
        char const *const type = "database";
        int length = 0;
        char const *const value = ZOOM_record_get(_record, type, &length);
        if (value == NULL) { return nil; }
        _database = [NSString stringWithUTF8String:value];
    }
    return _database;
}

- (NSDictionary *)json {
    if (_json == nil) {
        int length = 0;
        char const *const type = "json; charset=marc8";
        char const *const bytes = ZOOM_record_get(_record, type, &length);
        NSData *data = [NSData dataWithBytes:bytes length:length];
        _json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    return _json;
}

- (NSString *)isbn {
    for (NSDictionary *field in (NSArray *)self.json[@"fields"]) {
        if ([field.allKeys containsObject:@"020"]) {
            for (NSDictionary *subfield in (NSDictionary *)field[@"020"][@"subfields"]) {
                if ([subfield.allKeys containsObject:@"a"]) {
                    return subfield[@"a"];
                }
            }
        }
    }
    return nil;
}

@synthesize classifications = _classifications;

- (NSArray *)classifications {
    if (_classifications == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *field in (NSArray *)self.json[@"fields"]) {
            BibClassification *classification = [[BibClassification alloc] initFromField:field];
            if (classification) {
                [array addObject:classification];
            }
        }
        _classifications = [array copy];
    }
    return _classifications;
}

@end
