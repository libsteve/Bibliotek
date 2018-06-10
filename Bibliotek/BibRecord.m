//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassification.h"
#import "BibRecord.h"
#import "BibRecord.Private.h"
#import "BibClassification.h"
#import "BibRecordField.h"
#import <yaz/zoom.h>

@implementation BibRecord {
    ZOOM_record _record;
}

@synthesize zoomRecord = _record;

#pragma mark - Initialization

- (instancetype)initWithZoomRecord:(ZOOM_record)zoomRecord {
    if (self = [super init]) {
        _record = ZOOM_record_clone(zoomRecord);
    }
    return self;
}

- (instancetype)initWithFields:(NSArray<BibRecordField *> *)fields {
    if (self = [super init]) {
        _syntax = @"USMARC";
        _schema = @"USMARC";
        _database = @"Default";
        _fields = [fields copy];
    }
    return self
}

- (void)dealloc {
    if (_record != nil) { ZOOM_record_destroy(_record); }
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

@synthesize fields = _fields;

- (NSArray<BibRecordField *> *)fields {
    if (_fields == nil) {
        int length = 0;
        char const *const type = "json; charset=marc8";
        char const *const bytes = ZOOM_record_get(_record, type, &length);
        NSData *const data = [NSData dataWithBytes:bytes length:length];
        NSDictionary *const json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *fields = [NSMutableArray new];
        for (NSDictionary *content in [json[@"fields"] objectEnumerator]) {
            BibRecordField *field = [[BibRecordField alloc] initWithJson:content];
            if (field != nil) { [fields addObject:field]; }
        }
        _fields = [fields copy];
    }
    return _fields;
}

- (NSString *)isbn {
    for (BibRecordField *field in [self fields]) {
        if ([field.fieldTag isEqualToString:BibRecordFieldTagIsbn]) {
            return field['a'];
        }
    }
    return nil;
}

@synthesize classifications = _classifications;

- (NSArray *)classifications {
    if (_classifications == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (BibRecordField *field in [self fields]) {
            BibClassification *classification = [BibClassification classificationWithField:field];
            if (classification != nil) { [array addObject:classification]; }
        }
        _classifications = [array copy];
    }
    return _classifications;
}

@end
