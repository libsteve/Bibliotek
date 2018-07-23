//
//  BibMarcRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/18/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibCallNumber.h"
#import "BibRecord.h"
#import "BibMarcRecord.h"
#import "BibMarcRecord+Private.h"
#import "BibCallNumber.h"
#import "BibMarcRecordField.h"
#import "BibTitleStatement.h"
#import <yaz/zoom.h>

@implementation BibMarcRecord {
    NSString *_database;
    NSString *_isbn10;
    NSString *_isbn13;
    NSArray<BibCallNumber *> *_callNumbers;
    BibTitleStatement *_titleStatement;
    NSArray<NSString *> *_authors;
    NSArray<NSString *> *_editions;
    NSArray<NSString *> *_subjects;
    NSArray<NSString *> *_summaries;
}

+ (BOOL)supportsSecureCoding { return YES; }

@synthesize zoomRecord = _record;

#pragma mark - Initialization

- (instancetype)initWithZoomRecord:(ZOOM_record)zoomRecord {
    if (self = [super init]) {
        _record = ZOOM_record_clone(zoomRecord);
    }
    return self;
}

- (instancetype)initWithFields:(NSArray<BibMarcRecordField *> *)fields {
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

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableRecord allocWithZone:zone] initWithRecordStore:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _fields = [aDecoder decodeObjectForKey:@"fields"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_fields forKey:@"fields"];
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
- (NSArray<BibMarcRecordField *> *)fields {
    if (_fields == nil) {
        int length = 0;
        char const *const type = "json; charset=marc8";
        char const *const bytes = ZOOM_record_get(_record, type, &length);
        NSData *const data = [NSData dataWithBytes:bytes length:length];
        NSDictionary *const json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *const fields = [NSMutableArray new];
        for (NSDictionary *content in [json[@"fields"] objectEnumerator]) {
            BibMarcRecordField *const field = [[BibMarcRecordField alloc] initWithJson:content];
            if (field != nil) { [fields addObject:field]; }
        }
        [fields sortUsingComparator:^NSComparisonResult(BibMarcRecordField *left, BibMarcRecordField *right) {
            return [[left description] compare:[right description]];
        }];
        _fields = [fields copy];
    }
    return _fields;
}

- (NSString *)isbn10 {
    if (_isbn10 == nil) {
        for (BibMarcRecordField *field in [self fields]) {
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

- (NSString *)isbn13 {
    if (_isbn13 == nil) {
        for (BibMarcRecordField *field in [self fields]) {
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

- (NSArray *)callNumbers {
    if (_callNumbers == nil) {
        NSMutableArray *const array = [NSMutableArray array];
        for (BibMarcRecordField *field in [self fields]) {
            
            BibCallNumber *const callNumber = [[BibCallNumber alloc] initWithField:field];
            if (callNumber != nil) { [array addObject:callNumber]; }
        }
        _callNumbers = [array copy];
    }
    return _callNumbers;
}

- (BibTitleStatement *)titleStatement {
    if (_titleStatement == nil) {
        for (BibMarcRecordField *field in [self fields]) {
            BibTitleStatement *const statement = [BibTitleStatement statementWithField:field];
            if (statement != nil) {
                return (_titleStatement = statement);
            }
        }
    }
    return _titleStatement;
}

- (NSString *)title {
    return [[self titleStatement] title];
}

- (NSArray<NSString *> *)subtitles {
    return [[self titleStatement] subtitles];
}

- (NSArray<NSString *> *)contributors {
    return [[self titleStatement] people];
}

- (NSArray<NSString *> *)authors {
    if (_authors == nil) {
        NSMutableArray *const authors = [NSMutableArray new];
        for (BibMarcRecordField *field in [self fields]) {
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

- (NSArray<NSString *> *)editions {
    if (_editions == nil) {
        NSMutableArray *const editions = [NSMutableArray new];
        for (BibMarcRecordField *field in [self fields]) {
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

- (NSArray<NSString *> *)subjects {
    if (_subjects == nil) {
        NSMutableArray *const subjects = [NSMutableArray new];
        for (BibMarcRecordField *field in [self fields]) {
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

- (NSArray<NSString *> *)summaries {
    if (_summaries == nil) {
        NSMutableArray *summaries = [NSMutableArray new];
        for (BibMarcRecordField *field in [self fields]) {
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
    for (BibMarcRecordField *field in [[self fields] objectEnumerator]) {
        if (![string isEqualToString:@""]) { [string appendString:@"\n "]; }
        [string appendString:[NSString stringWithFormat:@"(%@)", [field description]]];
    }
    return [string copy];
}

- (NSString *)debugDescription {
    NSMutableString *const string = [NSMutableString new];
    for (BibMarcRecordField *field in [[self fields] objectEnumerator]) {
        if (![string isEqualToString:@""]) { [string appendString:@"\n"]; }
        [string appendString:[field debugDescription]];
    }
    return string;
}

@end
