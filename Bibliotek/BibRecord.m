//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassification.h"
#import "BibRecord.h"
#import "BibClassification.h"
#import "BibMarcRecordField.h"
#import "BibTitleStatement.h"

@implementation BibRecord {
@protected
    NSString *_database;
    NSString *_isbn10;
    NSString *_isbn13;
    NSArray<BibClassification *> *_classifications;
    NSString *_title;
    NSArray<NSString *> *_subtitles;
    NSArray<NSString *> *_contributors;
    NSArray<NSString *> *_authors;
    NSArray<NSString *> *_editions;
    NSArray<NSString *> *_subjects;
    NSArray<NSString *> *_summaries;
}

+ (BOOL)supportsSecureCoding { return YES; }

@synthesize database = _database;
@synthesize isbn10 = _isbn10;
@synthesize isbn13 = _isbn13;
@synthesize classifications = _classifications;
@synthesize title = _title;
@synthesize subtitles = _subtitles;
@synthesize contributors = _contributors;
@synthesize authors = _authors;
@synthesize editions = _editions;
@synthesize subjects = _subjects;
@synthesize summaries = _summaries;

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        _database = [NSString new];
        _isbn10 = nil;
        _isbn13 = nil;
        _classifications = [NSArray new];
        _title = [NSString new];
        _subtitles = [NSArray new];
        _contributors = [NSArray new];
        _authors = [NSArray new];
        _editions = [NSArray new];
        _subjects = [NSArray new];
        _summaries = [NSArray new];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [self init]) {
        _title = title;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title fromDatabase:(NSString *)database {
    if (self = [self init]) {
        _title = title;
        _database = database;
    }
    return self;
}

- (instancetype)initWithRecordStore:(id<BibRecord>)recordStore {
    if (self = [super init]) {
        _database = [recordStore.database copy];
        _isbn10 = [recordStore.isbn10 copy];
        _isbn13 = [recordStore.isbn13 copy];
        _classifications = [recordStore.classifications copy];
        _title = [recordStore.title copy];
        _subtitles = [recordStore.subtitles copy];
        _contributors = [recordStore.contributors copy];
        _authors = [recordStore.authors copy];
        _editions = [recordStore.editions copy];
        _subjects = [recordStore.subjects copy];
        _summaries = [recordStore.summaries copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _database = [aDecoder decodeObjectForKey:@"database"];
        _isbn10 = [aDecoder decodeObjectForKey:@"isbn10"];
        _isbn13 = [aDecoder decodeObjectForKey:@"isbn13"];
        _classifications = [aDecoder decodeObjectForKey:@"classifications"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _subtitles = [aDecoder decodeObjectForKey:@"subtitles"];
        _contributors = [aDecoder decodeObjectForKey:@"contributors"];
        _authors = [aDecoder decodeObjectForKey:@"authors"];
        _editions = [aDecoder decodeObjectForKey:@"editions"];
        _subjects = [aDecoder decodeObjectForKey:@"subjects"];
        _summaries = [aDecoder decodeObjectForKey:@"summaries"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_database forKey:@"database"];
    [aCoder encodeObject:_isbn10 forKey:@"isbn10"];
    [aCoder encodeObject:_isbn13 forKey:@"isbn13"];
    [aCoder encodeObject:_classifications forKey:@"classifications"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_subtitles forKey:@"subtitles"];
    [aCoder encodeObject:_contributors forKey:@"contributors"];
    [aCoder encodeObject:_authors forKey:@"authors"];
    [aCoder encodeObject:_editions forKey:@"editions"];
    [aCoder encodeObject:_subjects forKey:@"subjects"];
    [aCoder encodeObject:_summaries forKey:@"summaries"];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibRecord allocWithZone:zone] initWithRecordStore:self];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableRecord allocWithZone:zone] initWithRecordStore:self];
}

#pragma mark - Properties

- (NSString *)description {
    NSMutableString *const string = [NSMutableString new];
    [string appendString:[NSString stringWithFormat:@"(database: %@)", _database]];
    if (_isbn10.length != 0) {
        [string appendString:[NSString stringWithFormat:@"\n(isbn10: %@)", _isbn10]];
    }
    if (_isbn13.length != 0) {
        [string appendString:[NSString stringWithFormat:@"\n(isbn13: %@)", _isbn13]];
    }
    for (BibClassification *classification in _classifications) {
        [string appendString:[NSString stringWithFormat:@"\n(%@)", classification]];
    }
    [string appendString:[NSString stringWithFormat:@"\n(title: %@)", _title]];
    for (NSString *subtitle in _subtitles) {
        [string appendString:[NSString stringWithFormat:@"\n(subtitle: %@)", subtitle]];
    }
    for (NSString *author in _authors) {
        [string appendString:[NSString stringWithFormat:@"\n(author: %@)", author]];
    }
    for (NSString *contributor in _contributors) {
        [string appendString:[NSString stringWithFormat:@"\n(contributor: %@)", contributor]];
    }
    for (NSString *edition in _editions) {
        [string appendString:[NSString stringWithFormat:@"\n(edition: %@)", edition]];
    }
    for (NSString *subject in _subjects) {
        [string appendString:[NSString stringWithFormat:@"\n(subject: %@)", subject]];
    }
    for (NSString *summary in _summaries) {
        [string appendString:[NSString stringWithFormat:@"\n(summary: %@)", summary]];
    }
    return [string copy];
}

- (NSString *)debugDescription {
    return [self description];
}

@end

@implementation BibMutableRecord

+ (BOOL)supportsSecureCoding { return YES; }

@dynamic database;
- (void)setDatabase:(NSString *)database {
    _database = [database copy];
}

@dynamic isbn10;
- (void)setIsbn10:(NSString *)isbn10 {
    _isbn10 = [isbn10 copy];
}

@dynamic isbn13;
- (void)setIsbn13:(NSString *)isbn13 {
    _isbn13 = [isbn13 copy];
}

@dynamic classifications;
- (void)setClassifications:(NSArray<BibClassification *> *)classifications {
    _classifications = [classifications copy];
}

@dynamic title;
- (void)setTitle:(NSString *)title {
    _title = [title copy];
}

@dynamic subtitles;
- (void)setSubtitles:(NSArray<NSString *> *)subtitles {
    _subtitles = [subtitles copy];
}

@dynamic contributors;
- (void)setContributors:(NSArray<NSString *> *)contributors {
    _contributors = [contributors copy];
}

@dynamic authors;
- (void)setAuthors:(NSArray<NSString *> *)authors {
    _authors = [authors copy];
}

@dynamic editions;
- (void)setEditions:(NSArray<NSString *> *)editions {
    _editions = [editions copy];
}

@dynamic subjects;
- (void)setSubjects:(NSArray<NSString *> *)subjects {
    _subjects = [subjects copy];
}

@dynamic summaries;
- (void)setSummaries:(NSArray<NSString *> *)summaries {
    _summaries = [summaries copy];
}

@end
