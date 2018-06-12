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
#import "BibTitleStatement.h"
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
        _syntax = @"Usmarc";
        _schema = @"Usmarc";
        _database = @"Default";
        _fields = [fields copy];
    }
    return self;
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
        NSMutableArray *const fields = [NSMutableArray new];
        for (NSDictionary *content in [json[@"fields"] objectEnumerator]) {
            BibRecordField *const field = [[BibRecordField alloc] initWithJson:content];
            if (field != nil) { [fields addObject:field]; }
        }
        [fields sortUsingComparator:^NSComparisonResult(BibRecordField *left, BibRecordField *right) {
            return [[left description] compare:[right description]];
        }];
        _fields = [fields copy];
    }
    return _fields;
}

@synthesize isbn10 = _isbn10;
- (NSString *)isbn10 {
    if (_isbn10 == nil) {
        for (BibRecordField *field in [self fields]) {
            if ([field.fieldTag isEqualToString:BibRecordFieldTagIsbn]) {
                NSString *const isbn = field['a'];
                if ([isbn length] == 10) {
                    return (_isbn10 = isbn);
                }
            }
        }
    }
    return _isbn10;
}

@synthesize isbn13 = _isbn13;
- (NSString *)isbn13 {
    if (_isbn13 == nil) {
        for (BibRecordField *field in [self fields]) {
            if ([field.fieldTag isEqualToString:BibRecordFieldTagIsbn]) {
                NSString *const isbn = field['a'];
                if ([isbn length] == 13) {
                    return (_isbn13 = isbn);
                }
            }
        }
    }
    return _isbn13;
}

@synthesize classifications = _classifications;
- (NSArray *)classifications {
    if (_classifications == nil) {
        NSMutableArray *const array = [NSMutableArray array];
        for (BibRecordField *field in [self fields]) {
            BibClassification *const classification = [BibClassification classificationWithField:field];
            if (classification != nil) { [array addObject:classification]; }
        }
        _classifications = [array copy];
    }
    return _classifications;
}

@synthesize titleStatement = _titleStatement;
- (BibTitleStatement *)titleStatement {
    if (_titleStatement == nil) {
        for (BibRecordField *field in [self fields]) {
            BibTitleStatement *const statement = [BibTitleStatement statementWithField:field];
            if (statement != nil) {
                return (_titleStatement = statement);
            }
        }
    }
    return _titleStatement;
}

@synthesize authors = _authors;
- (NSArray<NSString *> *)authors {
    if (_authors == nil) {
        NSMutableArray *const authors = [NSMutableArray new];
        for (BibRecordField *field in [self fields]) {
            if (![field.fieldTag isEqualToString:BibRecordFieldTagAuthor]) { continue; }
            NSString *const name = field['a'];
            NSString *const numerics = field['b'] ?: @"";
            NSString *const title = field['c'] ?: @"";
            NSMutableString *const author = [NSMutableString stringWithFormat:@"%@%@%@", name, numerics, title];
            if ([author hasSuffix:@","]) {
                [author replaceCharactersInRange:NSMakeRange(author.length - 1, 1) withString:@""];
            }
            [authors addObject:[author copy]];
        }
        _authors = [authors copy];
    }
    return _authors;
}

@synthesize editions = _editions;
- (NSArray<NSString *> *)editions {
    if (_editions == nil) {
        NSMutableArray *const editions = [NSMutableArray new];
        for (BibRecordField *field in [self fields]) {
            if (![field.fieldTag isEqualToString:BibRecordFieldTagEdition]) { continue; }
            NSString *edition = field['a'];
            NSString *const remainder = field['b'] ?: @"";
            if ([edition hasSuffix:@" /"] || [edition hasSuffix:@" ="]) {
                edition = [edition stringByReplacingCharactersInRange:NSMakeRange(edition.length - 2, 2) withString:@""];
            }
            [editions addObject:[NSString stringWithFormat:@"%@%@", edition, remainder]];
        }
        _editions = [editions copy];
    }
    return _editions;
}

@synthesize subjects = _subjects;
- (NSArray<NSString *> *)subjects {
    if (_subjects == nil) {
        NSMutableArray *const subjects = [NSMutableArray new];
        for (BibRecordField *field in [self fields]) {
            if (![field.fieldTag isEqualToString:BibRecordFieldTagSubject]) { continue; }
            char const *const subfields = (char[]){'a', 'b', 'v', 'x', 'y', 'z'};
            for (int index = 0; index < 6; index += 1) {
                NSString *const entry = field[subfields[index]];
                if (entry != nil) { [subjects addObject:entry]; }
            }
        }
        _subjects = [subjects copy];
    }
    return _subjects;
}

@synthesize summaries = _summaries;
- (NSArray<NSString *> *)summaries {
    if (_summaries == nil) {
        NSMutableArray *summaries = [NSMutableArray new];
        for (BibRecordField *field in [self fields]) {
            if (![field.fieldTag isEqualToString:BibRecordFieldTagSummary]) { continue; }
            NSMutableString *const summary = [field['a'] mutableCopy];
            NSString *const expansion = field['b'];
            if (expansion != nil && ![expansion isEqualToString:@""]) {
                [summary appendString:@" "];
                [summary appendString:expansion];
            }
            [summaries addObject:[summary copy]];
        }
        _summaries = [summaries copy];
    }
    return _summaries;
}

- (NSString *)description {
    NSMutableString *const string = [NSMutableString new];
    for (BibRecordField *field in [[self fields] objectEnumerator]) {
        if (![string isEqualToString:@""]) { [string appendString:@"\n "]; }
        [string appendString:[field description]];
    }
    return [NSString stringWithFormat:@"[%@]", string];
}

- (NSString *)debugDescription {
    NSMutableString *const string = [NSMutableString new];
    for (BibRecordField *field in [[self fields] objectEnumerator]) {
        if (![string isEqualToString:@""]) { [string appendString:@"\n"]; }
        [string appendString:[field debugDescription]];
    }
    return string;
}

@end
