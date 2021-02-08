//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecord.h"
#import "BibRecordField.h"
#import "BibRecordKind.h"
#import "BibFieldTag.h"
#import "BibHasher.h"
#import "BibFieldIndicator.h"

#import "Bibliotek+Internal.h"

@implementation BibRecord {
@protected
    BibRecordKind *_kind;
    BibRecordStatus _status;
    BibMetadata *_metadata;
    NSArray<BibRecordField *> *_fields;
}

@synthesize kind = _kind;
@synthesize status = _status;
@synthesize metadata = _metadata;
@synthesize fields = _fields;

- (instancetype)init {
    return [self initWithKind:nil
                       status:BibRecordStatusNew
                     metadata:[BibMetadata new]
                       fields:[NSArray new]];
}

- (instancetype)initWithKind:(BibRecordKind *)kind
                      status:(BibRecordStatus)status
                    metadata:(BibMetadata *)metadata
                      fields:(NSArray<BibRecordField *> *)fields {
    if (self = [super init]) {
        _kind = kind;
        _status = status;
        _metadata = [metadata copy];
        _fields = [fields copy];
    }
    return self;
}

+ (instancetype)recordWithKind:(BibRecordKind *)kind
                        status:(BibRecordStatus)status
                      metadata:(BibMetadata *)metadata
                        fields:(NSArray<BibRecordField *> *)fields {
    return [[self alloc] initWithKind:kind status:status metadata:metadata fields:fields];
}

- (NSString *)description {
    return [[[self fields] valueForKey:BibKey(debugDescription)] componentsJoinedByString:@"\n"];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:BibKey(fields), BibKeyPath(fields, debugDescription), nil];
}

@end

#pragma mark - Copying

@implementation BibRecord (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableRecord allocWithZone:zone] initWithKind:[self kind]
                                                        status:[self status]
                                                      metadata:[self metadata]
                                                        fields:[self fields]];
}

@end

#pragma mark - Equality

@implementation BibRecord (Equality)

- (BOOL)isEqualToRecord:(BibRecord *)record {
    return [[self kind] isEqualToRecordKind:[record kind]]
        && [self status] == [record status]
        && [[self metadata] isEqualToMetadata:[record metadata]]
        && [[self fields] isEqualToArray:[record fields]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibRecord class]] && [self isEqualToRecord:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self kind]];
    [hasher combineWithHash:[self status]];
    [hasher combineWithObject:[self metadata]];
    [hasher combineWithObject:[self fields]];
    return [hasher hash];
}

@end

#pragma mark - Field Access

@implementation BibRecord (FieldAccess)

- (BibRecordField *)fieldAtIndex:(NSUInteger)index {
    return [self.fields objectAtIndex:index];
}

- (BOOL)containsFieldWithTag:(BibFieldTag *)fieldTag {
    return [self indexOfFieldWithTag:fieldTag] != NSNotFound;
}

- (NSUInteger)indexOfFieldWithTag:(BibFieldTag *)fieldTag {
    NSArray *const recordFields = self.fields;
    NSUInteger const count = recordFields.count;
    for (NSUInteger index = 0; index < count; index += 1) {
        if ([[[recordFields objectAtIndex:index] fieldTag] isEqualToTag:fieldTag]) {
            return index;
        }
    }
    return NSNotFound;
}

- (BibRecordField *)fieldWithTag:(BibFieldTag *)fieldTag {
    NSUInteger const index = [self indexOfFieldWithTag:fieldTag];
    return (index == NSNotFound) ? nil : [self fieldAtIndex:index];
}

- (BibRecordField *)fieldAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger const index = [indexPath indexAtPosition:0];
    if (indexPath.length != 1) {
        [NSException raise:NSRangeException format:@"Too many indexes in path for record field access"];
        return nil;
    }
    NSArray *const fields = [self fields];
    return [fields objectAtIndex:index];
}

- (BibSubfield *)subfieldAtIndexPath:(NSIndexPath *)indexPath {
    BibRecordField *const recordField = [[self fields] objectAtIndex:[indexPath indexAtPosition:0]];
    if ([recordField isDataField]) {
        return [recordField subfieldAtIndex:[indexPath indexAtPosition:1]];
    } else {
        [NSException raise:NSRangeException format:@"Cannot access subfileds in a control field"];
        return nil;
    }
}

- (NSString *)contentAtIndexPath:(NSIndexPath *)indexPath {
    BibRecordField *const recordField = [[self fields] objectAtIndex:[indexPath indexAtPosition:0]];
    switch (indexPath.length) {
        case 1:
            if (recordField.isControlField) {
                return [recordField controlValue];
            } else if (recordField.isDataField) {
                return [[recordField.subfields valueForKey:BibKey(content)] componentsJoinedByString:@" "];
            } else {
                return @"";
            }
        case 2:
            return [[recordField subfieldAtIndex:[indexPath indexAtPosition:1]] content];
        default:
            [NSException raise:NSRangeException format:@"To many indexes in path for content access"];
            return nil;
    }
}

@end

@implementation BibRecord (MultipleFieldAccess)

- (NSArray<BibRecordField *> *)allFieldsWithTag:(BibFieldTag *)fieldTag {
    NSPredicate *const predicate = [NSPredicate predicateWithFormat:@"%K = %@", BibKey(fieldTag), fieldTag];
    return [[self fields] filteredArrayUsingPredicate:predicate];
}

- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag {
    NSMutableArray *const indexPaths = [NSMutableArray new];
    NSArray *const fields = [self fields];
    NSUInteger const count = [fields count];
    for (NSUInteger index = 0; index < count; index += 1) {
        BibRecordField *const field = [fields objectAtIndex:index];
        if ([[field fieldTag] isEqualToTag:fieldTag]) {
            [indexPaths addObject:[NSIndexPath indexPathWithIndex:index]];
        }
    }
    return [indexPaths copy];
}

- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode {
    NSParameterAssert([fieldTag isDataTag]);
    NSMutableArray *const indexPaths = [NSMutableArray new];
    NSArray *const fields = [self fields];
    NSUInteger const count = [fields count];
    for (NSUInteger index = 0; index < count; index += 1) {
        BibRecordField *const field = [fields objectAtIndex:index];
        if ([[field fieldTag] isEqualToTag:fieldTag]) {
            NSArray *const subfields = [field subfields];
            NSUInteger const subfieldCount = [subfields count];
            for (NSUInteger subfieldIndex = 0; subfieldIndex < subfieldCount; subfieldIndex += 1) {
                if ([[[subfields objectAtIndex:subfieldIndex] subfieldCode] isEqualToString:subfieldCode]) {
                    NSUInteger indexes[2] = { index, subfieldIndex };
                    [indexPaths addObject:[NSIndexPath indexPathWithIndexes:indexes length:2]];
                }
            }
        }
    }
    return [indexPaths copy];
}

- (NSArray<NSIndexPath *> *)indexPathsForFieldPath:(BibFieldPath *)fieldPath {
    if ([fieldPath isSubfieldPath]) {
        return [self indexPathsForFieldTag:[fieldPath fieldTag] subfieldCode:[fieldPath subfieldCode]];
    }
    if ([fieldPath isControlFieldPath] || [fieldPath isDataFieldPath]) {
        return [self indexPathsForFieldTag:[fieldPath fieldTag]];
    }
    return [NSArray array];
}

- (NSArray<NSString *> *)contentWithFieldTag:(BibFieldTag *)fieldTag {
    NSMutableArray *const contents = [NSMutableArray new];
    for (NSIndexPath *indexPath in [self indexPathsForFieldTag:fieldTag]) {
        [contents addObject:[self contentAtIndexPath:indexPath]];
    }
    return [contents copy];
}

- (NSArray<NSString *> *)contentWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode {
    NSMutableArray *const contents = [NSMutableArray new];
    for (NSIndexPath *indexPath in [self indexPathsForFieldTag:fieldTag subfieldCode:subfieldCode]) {
        [contents addObject:[self contentAtIndexPath:indexPath]];
    }
    return [contents copy];
}

- (NSArray<NSString *> *)contentWithFieldPath:(BibFieldPath *)fieldPath {
    NSMutableArray *const contents = [NSMutableArray new];
    for (NSIndexPath *indexPath in [self indexPathsForFieldPath:fieldPath]) {
        [contents addObject:[self contentAtIndexPath:indexPath]];
    }
    return [contents copy];
}

@end

#pragma mark - Mutable

@implementation BibMutableRecord

- (id)copyWithZone:(NSZone *)zone {
    return [[BibRecord allocWithZone:zone] initWithKind:[self kind]
                                                 status:[self status]
                                               metadata:[self metadata]
                                                 fields:[self fields]];
}

@dynamic kind;
- (void)setKind:(BibRecordKind *)kind {
    if (_kind != kind) {
        _kind = kind;
    }
}

@dynamic status;
- (void)setStatus:(BibRecordStatus)status {
    if (_status != status) {
        _status = status;
    }
}

@dynamic metadata;
- (void)setMetadata:(BibMetadata *)metadata {
    if (_metadata != metadata) {
        _metadata = [metadata copy];
    }
}

@dynamic fields;
- (void)setFields:(NSArray<BibRecordField *> *)fields {
    if (_fields != fields) {
        _fields = [fields copy];
    }
}

@end
