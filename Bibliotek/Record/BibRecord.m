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
#import "BibRecordControlField.h"
#import "BibRecordDataField.h"
#import "BibRecordSubfield.h"

#import "BibClassificationRecord.h"
#import "BibBibliographicRecord.h"

static NSRange const kLeaderRange = {0, 24};
static NSUInteger const kDirectoryEntryLength = 12;

@implementation BibRecord

+ (NSDictionary<BibRecordFieldTag,Class> *)recordFieldTypes {
    return @{};
}

- (instancetype)init {
    return [self initWithLeader:[BibRecordLeader new] directory:@[] controlFields:@[] dataFields:@[]];
}

- (instancetype)initWithData:(NSData *)data {
    BibRecordLeader *const leader = [[BibRecordLeader alloc] initWithData:[data subdataWithRange:kLeaderRange]];
    NSUInteger const recordBodyLocation = [leader recordBodyLocation];
    NSMutableArray *const directory = [NSMutableArray array];
    NSUInteger const directoryBodyLength = recordBodyLocation - NSMaxRange(kLeaderRange) - 1;
    NSUInteger const directoryEntryCount = directoryBodyLength / kDirectoryEntryLength;
    for (NSUInteger index = 0; index < directoryEntryCount; index += 1) {
        NSUInteger const location = index * kDirectoryEntryLength + NSMaxRange(kLeaderRange);
        NSData *const entryData = [data subdataWithRange:NSMakeRange(location, kDirectoryEntryLength)];
        [directory addObject:[[BibRecordDirectoryEntry alloc] initWithData:entryData]];
    }
    return [self initWithLeader:leader directory:directory data:data];
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                 controlFields:(NSArray<BibRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibRecordDataField *> *)dataFields {
    if (![[self class] isEqual:[BibRecord class]]) {
        BibRecordKind const recordKind = [leader recordType];
        if (BibRecordKindIsClassification(recordKind)) {
            return [[BibClassificationRecord alloc] initWithLeader:leader
                                                         directory:directory
                                                     controlFields:controlFields
                                                        dataFields:dataFields];
        }
        if (BibRecordKindIsBibliographic(recordKind)) {
            return [[BibBibliographicRecord alloc] initWithLeader:leader
                                                        directory:directory
                                                    controlFields:controlFields
                                                       dataFields:dataFields];
        }
    }
    if (self = [super init]) {
        _leader = leader;
        _directory = [directory copy];
        _controlFields = [controlFields copy];
        _dataFields = [dataFields copy];
    }
    return self;
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                          data:(NSData *)data {
    NSUInteger const recordBodyLocation = [leader recordBodyLocation];
    NSMutableArray *const controlFields = [NSMutableArray array];
    NSMutableArray *const dataFields = [NSMutableArray array];
    for (BibRecordDirectoryEntry *entry in directory) {
        BibRecordFieldTag const fieldTag = [entry fieldTag];
        NSRange fieldRange = [entry fieldRange];
        fieldRange.location += recordBodyLocation;
        NSData *const fieldData = [data subdataWithRange:fieldRange];
        Class const suggestedFieldClass = [[[self class] recordFieldTypes] objectForKey:fieldTag];
        if ([fieldTag hasPrefix:@"00"]) {
            Class const finalFieldClass = suggestedFieldClass ?: [BibRecordControlField class];
            [controlFields addObject:[[finalFieldClass alloc] initWithTag:fieldTag data:fieldData]];
        } else {
            Class const finalFieldClass = suggestedFieldClass ?: [BibRecordDataField class];
            [dataFields addObject:[[finalFieldClass alloc] initWithTag:fieldTag data:fieldData]];
        }
    }
    return [self initWithLeader:leader directory:directory controlFields:controlFields dataFields:dataFields];
}

- (NSString *)description {
    return [@[ _leader,
               [_controlFields componentsJoinedByString:@"\n"],
               [_dataFields componentsJoinedByString:@"\n"] ] componentsJoinedByString:@"\n"];
}

#pragma mark - Equality

- (BOOL)isEqualToRecord:(BibRecord *)record {
    return [_leader isEqualToLeader:[record leader]]
        && [_directory isEqualToArray:[record directory]]
        && [_controlFields isEqualToArray:[record controlFields]]
        && [_dataFields isEqualToArray:[record dataFields]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecord class]] && [self isEqualToRecord:other]);
}

- (NSUInteger)hash {
    return [_leader hash] ^ [_directory hash] ^ [_controlFields hash] ^ [_dataFields hash];
}

@end
