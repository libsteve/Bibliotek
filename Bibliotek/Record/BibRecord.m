//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecord.h"
#import "BibLeader.h"
#import "BibRecordField.h"
#import "BibRecordKind.h"
#import "BibFieldTag.h"
#import "BibHasher.h"
#import "BibFieldIndicator.h"

#import "Bibliotek+Internal.h"

@implementation BibRecord {
@protected
    BibLeader *_leader;
    NSArray<BibRecordField *> *_fields;
}

@synthesize leader = _leader;
@synthesize fields = _fields;

- (instancetype)init {
    BibMutableLeader *leader = [BibMutableLeader new];
    [leader setRecordStatus:BibRecordStatusNew];
    return [self initWithLeader:leader fields:[NSArray new]];
}

- (instancetype)initWithLeader:(BibLeader *)leader fields:(NSArray<BibRecordField *> *)fields {
    if (self = [super init]) {
        _leader = [leader copy];
        _fields = [fields copy];
    }
    return self;
}

+ (instancetype)recordWithLeader:(BibLeader *)leader fields:(NSArray<BibRecordField *> *)fields {
    return [[self alloc] initWithLeader:leader fields:fields];
}

- (NSString *)description {
    return [[[self fields] valueForKey:BibKey(debugDescription)] componentsJoinedByString:@"\n"];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:BibKey(fields), BibKeyPath(fields, debugDescription), nil];
}

#pragma mark - Properties

@dynamic kind;
- (BibRecordKind)kind {
    return [[self leader] recordKind];
}

@dynamic status;
- (BibRecordStatus)status {
    return [[self leader] recordStatus];
}

@end

#pragma mark - Copying

@implementation BibRecord (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableRecord allocWithZone:zone] initWithLeader:[self leader] fields:[self fields]];
}

@end

#pragma mark - Equality

@implementation BibRecord (Equality)

- (BOOL)isEqualToRecord:(BibRecord *)record {
    return [[self leader] isEqualToLeader:[record leader]]
        && [[self fields] isEqualToArray:[record fields]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibRecord class]] && [self isEqualToRecord:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self leader]];
    [hasher combineWithObject:[self fields]];
    return [hasher hash];
}

@end

#pragma mark - Field Access

@implementation BibRecord (FieldAccess)

- (NSUInteger)countOfFields {
    return [[self fields] count];
}

- (BOOL)containsFieldWithTag:(BibFieldTag *)fieldTag {
    return [self indexOfFieldWithTag:fieldTag] != NSNotFound;
}

- (NSUInteger)indexOfFieldWithTag:(BibFieldTag *)fieldTag {
    NSArray<BibRecordField *> *const recordFields = [self fields];
    NSUInteger const count = recordFields.count;
    for (NSUInteger index = 0; index < count; index += 1) {
        if ([[[recordFields objectAtIndex:index] fieldTag] isEqualToTag:fieldTag]) {
            return index;
        }
    }
    return NSNotFound;
}

- (NSUInteger)indexOfFieldWithTag:(BibFieldTag *)fieldTag inRange:(NSRange)range {
    NSArray<BibRecordField *> *const fields = [[self fields] subarrayWithRange:range];
    NSUInteger const count = [fields count];
    for (NSUInteger index = 0; index < count; index += 1) {
        if ([[[fields objectAtIndex:index] fieldTag] isEqualToTag:fieldTag]) {
            return index;
        }
    }
    return NSNotFound;
}

- (NSIndexSet *)indexesOfFieldsWithTag:(BibFieldTag *)fieldTag {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    NSArray<BibRecordField *> *const recordFields = [self fields];
    NSUInteger const count = [recordFields count];
    for (NSUInteger index = 0; index < count; index += 1) {
        if ([[[recordFields objectAtIndex:index] fieldTag] isEqualToTag:fieldTag]) {
            [indexSet addIndex:index];
        }
    }
    return [indexSet copy];
}

- (BibRecordField *)fieldAtIndex:(NSUInteger)index {
    return [[self fields] objectAtIndex:index];
}

- (NSArray<BibRecordField *> *)fieldsAtIndexes:(NSIndexSet *)indexes {
    return [[self fields] objectsAtIndexes:indexes];
}

- (BibRecordField *)fieldWithTag:(BibFieldTag *)fieldTag {
    for (BibRecordField *field in [self fields]) {
        if ([[field fieldTag] isEqualToTag:fieldTag]) {
            return field;
        }
    }
    return nil;
}

- (nullable BibRecordField *)fieldWithTag:(BibFieldTag *)fieldTag inRange:(NSRange)range {
    for (BibRecordField *field in [[self fields] subarrayWithRange:range]) {
        if ([[field fieldTag] isEqualToTag:fieldTag]) {
            return field;
        }
    }
    return nil;
}

- (NSArray<BibRecordField *> *)fieldsWithTag:(BibFieldTag *)fieldTag {
    NSPredicate *const predicate = [NSPredicate predicateWithFormat:@"%K = %@", BibKey(fieldTag), fieldTag];
    return [[self fields] filteredArrayUsingPredicate:predicate];
}

- (BibRecordField *)fieldAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] > 2) {
        [NSException raise:NSRangeException format:@"Too many indexes in path for record field access"];
        return nil;
    }
    NSUInteger const index = [indexPath indexAtPosition:0];
    NSArray *const fields = [self fields];
    return [fields objectAtIndex:index];
}

- (BibSubfield *)subfieldAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] > 2) {
        [NSException raise:NSRangeException format:@"Too many indexes in path for record field access"];
        return nil;
    }
    BibRecordField *const recordField = [[self fields] objectAtIndex:[indexPath indexAtPosition:0]];
    if ([recordField isDataField]) {
        return [recordField subfieldAtIndex:[indexPath indexAtPosition:1]];
    } else {
        [NSException raise:NSRangeException format:@"Cannot access subfields in a control field"];
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

#pragma mark - Lazy Mutable Field Array

@interface _BibLazyMutableRecordFieldArray : NSMutableArray<BibMutableRecordField *>
@end

#pragma mark - Mutable Record

@implementation BibMutableRecord

- (instancetype)initWithLeader:(BibLeader *)leader fields:(NSArray<BibRecordField *> *)fields {
    if (self = [super initWithLeader:leader fields:fields]) {
        _leader = [leader mutableCopy];
        _fields = [[_BibLazyMutableRecordFieldArray alloc] initWithArray:(NSArray *)fields];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibRecord allocWithZone:zone] initWithLeader:[self leader] fields:[self fields]];
}

- (BibLeader *)leader {
    return [_leader copy];
}

- (void)setLeader:(BibLeader *)leader {
    if (_leader != leader) {
        _leader = [leader mutableCopy];
    }
}

@dynamic kind;
- (void)setKind:(BibRecordKind)kind {
    [(BibMutableLeader *)(_leader) setRecordKind:kind];
}

@dynamic status;
- (void)setStatus:(BibRecordStatus)status {
    [(BibMutableLeader *)(_leader) setRecordStatus:status];
}

- (NSArray<BibMutableRecordField *> *)fields {
    return [_fields copy];
}

- (void)setFields:(NSArray<BibMutableRecordField *> *)fields {
    if (_fields != fields) {
        _fields = [[_BibLazyMutableRecordFieldArray alloc] initWithArray:fields];
    }
}

@end

#pragma mark -

@implementation BibMutableRecord (FieldModification)

- (void)addField:(BibMutableRecordField *)field {
    [self insertField:field atIndex:[_fields count]];
}

- (void)insertField:(BibMutableRecordField *)field atIndex:(NSUInteger)index {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[[NSIndexSet alloc] initWithIndex:index]
              forKey:BibKey(fields)];
    [(NSMutableArray *)_fields insertObject:field atIndex:index];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[[NSIndexSet alloc] initWithIndex:index]
             forKey:BibKey(fields)];
}

- (void)insertFields:(NSArray<BibMutableRecordField *> *)fields atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:BibKey(fields)];
    [(NSMutableArray *)_fields insertObjects:fields atIndexes:indexes];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:BibKey(fields)];
}

- (void)replaceFieldAtIndex:(NSUInteger)index withField:(BibMutableRecordField *)field {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:[[NSIndexSet alloc] initWithIndex:index]
              forKey:BibKey(fields)];
    [(NSMutableArray *)_fields replaceObjectAtIndex:index withObject:field];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:[[NSIndexSet alloc] initWithIndex:index]
             forKey:BibKey(fields)];
}

- (void)replaceFieldsAtIndexes:(NSIndexSet *)indexes withFields:(NSArray<BibMutableRecordField *> *)fields {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:BibKey(fields)];
    [(NSMutableArray *)_fields replaceObjectsAtIndexes:indexes withObjects:fields];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:BibKey(fields)];
}

- (void)removeFieldAtIndex:(NSUInteger)index {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[[NSIndexSet alloc] initWithIndex:index]
              forKey:BibKey(fields)];
    [(NSMutableArray *)_fields removeObjectAtIndex:index];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[[NSIndexSet alloc] initWithIndex:index]
             forKey:BibKey(fields)];
}

- (void)removeFieldsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:BibKey(fields)];
    [(NSMutableArray *)_fields removeObjectsAtIndexes:indexes];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:BibKey(fields)];
}

- (NSMutableArray<BibMutableRecordField *> *)mutableFields {
    return [self mutableArrayValueForKey:BibKey(fields)];
}

@end

#pragma mark - Lazy Mutable Field Array

@implementation _BibLazyMutableRecordFieldArray {
    NSMutableArray<BibRecordField *> *_fields;
}

- (instancetype)initWithArray:(NSArray<BibRecordField *> *)array {
    if (self = [super init]) {
        _fields = [array mutableCopy];
    }
    return self;
}

- (NSUInteger)count {
    return [_fields count];
}

- (BibMutableRecordField *)objectAtIndex:(NSUInteger)index {
    BibRecordField *field = [_fields objectAtIndex:index];
    if ([field isKindOfClass:[BibMutableRecordField class]]) {
        return (BibMutableRecordField *)field;
    } else {
        BibMutableRecordField *mutableField = [field mutableCopy];
        [_fields replaceObjectAtIndex:index withObject:mutableField];
        return mutableField;
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_fields insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_fields removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    [_fields addObject:anObject];
}

- (void)removeLastObject {
    [_fields removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_fields replaceObjectAtIndex:index withObject:anObject];
}

@end
