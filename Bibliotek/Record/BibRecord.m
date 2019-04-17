//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibConstants.h"
#import "BibRecord.h"
#import "BibRecordLeader.h"
#import "BibRecordDirectoryEntry.h"
#import "BibRecordField.h"
#import "BibGenericRecordControlField.h"
#import "BibGenericRecordDataField.h"
#import "BibRecordSubfield.h"

#import "BibClassificationRecord.h"
#import "BibBibliographicRecord.h"

static NSRange const kLeaderRange = {0, 24};
static NSUInteger const kDirectoryEntryLength = 12;

@implementation BibRecord

+ (NSDictionary<BibRecordFieldTag,Class> *)recordSchema {
    return @{};
}

- (instancetype)init {
    return [self initWithLeader:[BibRecordLeader new] directory:@[] fields:@[]];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data range:NULL];
}

- (instancetype)initWithData:(NSData *)data range:(NSRange *)range {
    NSRange const dataRange = range ? *range : NSMakeRange(0, [data length]);
    NSData *const recordData = (range) ? data : [data subdataWithRange:dataRange];
    BibRecordLeader *const leader = [[BibRecordLeader alloc] initWithData:[recordData subdataWithRange:kLeaderRange]];
    NSUInteger const recordLength = [leader recordLength];
    NSUInteger const recordBodyLocation = [leader recordBodyLocation];
    NSMutableArray *const directory = [NSMutableArray array];
    NSUInteger const directoryBodyLength = recordBodyLocation - NSMaxRange(kLeaderRange) - 1;
    NSUInteger const directoryEntryCount = directoryBodyLength / kDirectoryEntryLength;
    for (NSUInteger index = 0; index < directoryEntryCount; index += 1) {
        NSUInteger const location = index * kDirectoryEntryLength + NSMaxRange(kLeaderRange);
        NSData *const entryData = [recordData subdataWithRange:NSMakeRange(location, kDirectoryEntryLength)];
        [directory addObject:[[BibRecordDirectoryEntry alloc] initWithData:entryData]];
    }
    self = [self initWithLeader:leader directory:directory data:recordData];
    if (self && range) {
        (*range).location += recordLength;
        (*range).length -= recordLength;
    }
    return self;
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                        fields:(NSArray<id<BibRecordField>> *)fields {
    if ([[self class] isEqual:[BibRecord class]]) {
        BibRecordKind const recordKind = [leader recordType];
        if (BibRecordKindIsClassification(recordKind)) {
            return [[BibClassificationRecord alloc] initWithLeader:leader directory:directory fields:fields];
        }
        if (BibRecordKindIsBibliographic(recordKind)) {
            return [[BibBibliographicRecord alloc] initWithLeader:leader directory:directory fields:fields];
        }
    }
    if (self = [super init]) {
        _leader = leader;
        _directory = [directory copy];
        _fields = [fields copy];
    }
    return self;
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                          data:(NSData *)data {
    if ([[self class] isEqual:[BibRecord class]]) {
        BibRecordKind const recordKind = [leader recordType];
        if (BibRecordKindIsClassification(recordKind)) {
            return [[BibClassificationRecord alloc] initWithLeader:leader directory:directory data:data];
        }
        if (BibRecordKindIsBibliographic(recordKind)) {
            return [[BibBibliographicRecord alloc] initWithLeader:leader directory:directory data:data];
        }
    }
    NSDictionary *const recordSchema = [[self class] recordSchema];
    NSUInteger const recordBodyLocation = [leader recordBodyLocation];
    NSMutableArray *const fields = [NSMutableArray array];
    for (BibRecordDirectoryEntry *entry in directory) {
        BibRecordFieldTag const fieldTag = [entry fieldTag];
        NSRange fieldRange = [entry fieldRange];
        fieldRange.location += recordBodyLocation;
        NSData *const fieldData = [data subdataWithRange:fieldRange];
        Class const fieldClass = [recordSchema objectForKey:fieldTag];
        if (fieldClass) {
            [fields addObject:[[fieldClass alloc] initWithData:fieldData]];
        } else {
            id<BibRecordField> const field = ([entry fieldKind] == BibRecordFieldKindControlField)
                                           ? [[BibGenericRecordControlField alloc] initWithTag:fieldTag data:fieldData]
                                           : [[BibGenericRecordDataField alloc] initWithTag:fieldTag data:fieldData];
            [fields addObject:field];
        }
    }
    return [self initWithLeader:leader directory:directory fields:fields];
}

- (NSString *)description {
    return [@[ _leader, [_fields componentsJoinedByString:@"\n"] ] componentsJoinedByString:@"\n"];
}

- (NSString *)debugDescription {
    return [@[ _leader, [_fields componentsJoinedByString:@"\n"] ] componentsJoinedByString:@"\n"];
}

#pragma mark - Equality

- (BOOL)isEqualToRecord:(BibRecord *)record {
    return [_leader isEqualToLeader:[record leader]]
        && [_directory isEqualToArray:[record directory]]
        && [_fields isEqualToArray:[record fields]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecord class]] && [self isEqualToRecord:other]);
}

- (NSUInteger)hash {
    return [_leader hash] ^ [_directory hash] ^ [_fields hash];
}

#pragma mark -

+ (NSArray<BibRecord *> *)recordsWithData:(NSData *)data {
    NSRange range = NSMakeRange(0, [data length]);
    NSMutableArray *records = [NSMutableArray array];
    while (range.location < NSMaxRange(range)) {
        BibRecord *record = [[BibRecord alloc] initWithData:data range:&range];
        if (record == nil) { break; }
        [records addObject:record];
    }
    return [records copy];
}

+ (NSArray<BibRecord *> *)recordsWithContentsOfFile:(NSString *)filePath {
    return [self recordsWithData:[NSData dataWithContentsOfFile:filePath]];
}

+ (NSArray<BibRecord *> *)recordsWithContentsOfURL:(NSURL *)url {
    return [self recordsWithData:[NSData dataWithContentsOfURL:url]];
}

@end
