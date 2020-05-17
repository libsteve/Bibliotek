//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecord.h"
#import "BibRecordKind.h"
#import "BibControlField.h"
#import "BibContentField.h"
#import "BibFieldTag.h"
#import "BibHasher.h"

#import "Bibliotek+Internal.h"

@implementation BibRecord {
@protected
    BibRecordKind *_kind;
    BibRecordStatus _status;
    BibMetadata *_metadata;
    NSArray<BibControlField *> *_controlFields;
    NSArray<BibContentField *> *_contentFields;
}

@synthesize kind = _kind;
@synthesize status = _status;
@synthesize metadata = _metadata;
@synthesize controlFields = _controlFields;
@synthesize contentFields = _contentFields;

- (instancetype)initWithKind:(BibRecordKind *)kind
                      status:(BibRecordStatus)status
                    metadata:(BibMetadata *)metadata
               controlFields:(NSArray<BibControlField *> *)controlFields
               contentFields:(NSArray<BibContentField *> *)contentFields {
    if (self = [super init]) {
        _kind = kind;
        _status = status;
        _metadata = [metadata copy];
        _controlFields = [controlFields copy];
        _contentFields = [contentFields copy];
    }
    return self;
}

- (instancetype)init {
    return [self initWithKind:nil
                       status:BibRecordStatusNew
                     metadata:[BibMetadata new]
                controlFields:[NSArray array]
                contentFields:[NSArray array]];
}

+ (instancetype)recordWithKind:(BibRecordKind *)kind
                        status:(BibRecordStatus)status
                      metadata:(BibMetadata *)metadata
                 controlFields:(NSArray<BibControlField *> *)controlFields
                 contentFields:(NSArray<BibContentField *> *)contentFields {
    return [[self alloc] initWithKind:kind
                               status:status
                             metadata:metadata
                        controlFields:controlFields
                        contentFields:contentFields];
}

- (NSString *)description {
    NSArray *const fields = [[self controlFields] arrayByAddingObjectsFromArray:(id)[self contentFields]];
    return [[fields valueForKey:BibKey(debugDescription)] componentsJoinedByString:@"\n"];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:BibKey(controlFields), BibKey(contentFields),
                                 BibKeyPath(controlFields, debugDescription),
                                 BibKeyPath(contentFields, debugDescription), nil];
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
                                                 controlFields:[self controlFields]
                                                 contentFields:[self contentFields]];
}

@end

#pragma mark - Equality

@implementation BibRecord (Equality)

- (BOOL)isEqualToRecord:(BibRecord *)record {
    return [[self kind] isEqualToRecordKind:[record kind]]
        && [self status] == [record status]
        && [[self metadata] isEqualToMetadata:[record metadata]]
        && [[self controlFields] isEqualToArray:[record controlFields]]
        && [[self contentFields] isEqualToArray:[record contentFields]];
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
    [hasher combineWithObject:[self controlFields]];
    [hasher combineWithObject:[self contentFields]];
    return [hasher hash];
}

@end

#pragma mark - Field Access

@implementation BibRecord (FieldAccess)

- (BibFieldEnumerator<BibControlField *> *)controlFieldEnumerator {
    return [[BibFieldEnumerator alloc] initWithEnumerator:[[self controlFields] objectEnumerator]];
}

- (BibFieldEnumerator<BibContentField *> *)contentFieldEnumerator {
    return [[BibFieldEnumerator alloc] initWithEnumerator:[[self contentFields] objectEnumerator]];
}

- (BibControlField *)firstControlFieldWithTag:(BibFieldTag *)fieldTag {
    return [[self controlFieldEnumerator] nextFieldWithTag:fieldTag];
}

- (BibContentField *)firstContentFieldWithTag:(BibFieldTag *)fieldTag {
    return [[self contentFieldEnumerator] nextFieldWithTag:fieldTag];
}

- (NSArray<BibControlField *> *)controlFieldsWithTag:(BibFieldTag *)fieldTag {
    NSPredicate *const predicate = [NSPredicate predicateWithFormat:@"%K = %@", BibKey(tag), fieldTag];
    return [[self controlFields] filteredArrayUsingPredicate:predicate];
}

- (NSArray<BibContentField *> *)contentFieldsWithTag:(BibFieldTag *)fieldTag {
    NSPredicate *const predicate = [NSPredicate predicateWithFormat:@"%K = %@", BibKey(tag), fieldTag];
    return [[self contentFields] filteredArrayUsingPredicate:predicate];
}

- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag {
    NSMutableArray *const indexPaths = [NSMutableArray new];
    if ([fieldTag isControlFieldTag]) {
        NSArray *const controlFields = [self controlFields];
        NSUInteger const controlFieldsCount = [controlFields count];
        for (NSUInteger fieldIndex = 0; fieldIndex < controlFieldsCount; fieldIndex += 1) {
            BibControlField *const controlField = [controlFields objectAtIndex:fieldIndex];
            if ([[controlField tag] isEqualToTag:fieldTag]) {
                [indexPaths addObject:[[NSIndexPath alloc] initWithIndex:fieldIndex]];
            }
        }
    } else {
        NSArray *const contentFields = [self contentFields];
        NSUInteger const contnetFiledsCount = [contentFields count];
        NSUInteger const controlFieldsCount = [[self controlFields] count];
        for (NSUInteger fieldIndex = 0; fieldIndex < contnetFiledsCount; fieldIndex += 1) {
            BibContentField *const contentField = [contentFields objectAtIndex:fieldIndex];
            if ([[contentField tag] isEqualToTag:fieldTag]) {
                [indexPaths addObject:[[NSIndexPath alloc] initWithIndex:(fieldIndex + controlFieldsCount)]];
            }
        }
    }
    return [indexPaths copy];
}

- (NSArray<NSIndexPath *> *)indexPathsForFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode {
    NSMutableArray *const indexPaths = [NSMutableArray new];
    for (NSIndexPath *path in [self indexPathsForFieldTag:fieldTag]) {
        BibContentField *const contentField = [self contentFieldAtIndexPath:path];
        NSIndexSet const *indexes = [contentField indexesOfSubfieldsWithCode:subfieldCode] ?: [NSIndexSet new];
        for (NSUInteger index = [indexes firstIndex]; index != NSNotFound; index = [indexes indexGreaterThanIndex:index]) {
            [indexPaths addObject:[path indexPathByAddingIndex:index]];
        }
    }
    return [indexPaths copy];
}

- (NSArray<NSIndexPath *> *)indexPathsForFieldPath:(BibFieldPath *)fieldPath {
    if ([fieldPath isSubfieldPath]) {
        return [self indexPathsForFieldTag:[fieldPath fieldTag] subfieldCode:[fieldPath subfieldCode]];
    }
    if ([fieldPath isControlFieldPath] || [fieldPath isContentFieldPath]) {
        return [self indexPathsForFieldTag:[fieldPath fieldTag]];
    }
    return [NSArray array];
}

- (BibControlField *)controlFieldAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] >= 1) {
        NSUInteger const index = [indexPath indexAtPosition:0];
        NSArray *const controlFields = [self controlFields];
        if (index < [controlFields count]) {
            return [controlFields objectAtIndex:index];
        }
    }
    return nil;
}

- (BibContentField *)contentFieldAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] >= 1) {
        NSUInteger const index = [indexPath indexAtPosition:0];
        NSUInteger const controlFieldsCount = [[self controlFields] count];
        if (index >= controlFieldsCount) {
            return [[self contentFields] objectAtIndex:(index - controlFieldsCount)];
        }
    }
    return nil;
}

- (BibSubfield *)subfieldAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] >= 2) {
        BibContentField *const contentField = [self contentFieldAtIndexPath:indexPath];
        return [contentField subfieldAtIndex:[indexPath indexAtPosition:1]];
    }
    return nil;
}

- (NSString *)contentAtIndexPath:(NSIndexPath *)indexPath {
    BibSubfield *const subfield = [self subfieldAtIndexPath:indexPath];
    if (subfield != nil) {
        return [subfield content];
    }
    BibContentField *const contentField = [self contentFieldAtIndexPath:indexPath];
    if (contentField != nil) {
        return [[[contentField subfields] valueForKey:BibKey(content)] componentsJoinedByString:@" "];
    }
    BibControlField *const controlField = [self controlFieldAtIndexPath:indexPath];
    if (controlField != nil) {
        return [controlField value];
    }
    NSParameterAssert(NO);
    return nil;
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
    return [[BibMutableRecord allocWithZone:zone] initWithKind:[self kind]
                                                        status:[self status]
                                                      metadata:[self metadata]
                                                 controlFields:[self controlFields]
                                                 contentFields:[self contentFields]];
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

@dynamic controlFields;
- (void)setControlFields:(NSArray<BibControlField *> *)fields {
    if (_controlFields != fields) {
        _controlFields = [fields copy];
    }
}

@dynamic contentFields;
- (void)setContentFields:(NSArray<BibContentField *> *)fields {
    if (_contentFields != fields) {
        _contentFields = [fields copy];
    }
}

@end
