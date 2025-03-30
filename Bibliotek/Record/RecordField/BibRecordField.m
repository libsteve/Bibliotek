//
//  BibRecordField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/31/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibRecordField.h"
#import "BibFieldTag.h"
#import "BibFieldIndicator.h"
#import "Bibliotek+Internal.h"
#import "BibHasher.h"
#import "BibSubfield.h"

/// Overrides `copyWithZone:` to return `self` as an optimization.
@interface _BibIRecordField : BibRecordField
@end

@interface BibRecordField () {
@protected
    BibFieldTag *_fieldTag;
    NSString *_controlValue;
    BibFieldIndicator *_firstIndicator;
    BibFieldIndicator *_secondIndicator;
    NSArray<BibSubfield *> *_subfields;
}
@end

@implementation BibRecordField

@synthesize fieldTag = _fieldTag;
@synthesize controlValue = _controlValue;
@synthesize firstIndicator = _firstIndicator;
@synthesize secondIndicator = _secondIndicator;
@synthesize subfields = _subfields;

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibRecordField class]) {
        return [_BibIRecordField allocWithZone:zone];
    }
    return [super allocWithZone:zone];
}

- (instancetype)init {
    return [self initWithFieldTag:[[BibFieldTag alloc] initWithString:@"000"]];
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag {
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        if ([fieldTag isDataTag]) {
            _firstIndicator = [BibFieldIndicator blank];
            _secondIndicator = [BibFieldIndicator blank];
            _subfields = [NSArray new];
        } else if ([fieldTag isControlTag]) {
            _controlValue = @"";
        }
    }
    return self;
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag controlValue:(NSString *)controlValue {
    if (![fieldTag isControlTag]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"*** Cannot create a data field with the tag %@.", fieldTag];
    }
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        _controlValue = [controlValue copy];
    }
    return self;
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag
                  firstIndicator:(BibFieldIndicator *)firstIndicator
                 secondIndicator:(BibFieldIndicator *)secondIndicator
                       subfields:(NSArray<BibSubfield *> *)subfields {
    if (![fieldTag isDataTag]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"*** Cannot create a data field with the tag %@.", fieldTag];
    }
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        _firstIndicator = [firstIndicator copy];
        _secondIndicator = [secondIndicator copy];
        _subfields = [subfields copy];
    }
    return self;
}

- (BOOL)isControlField {
    return [[self fieldTag] isControlTag];
}

- (BOOL)isDataField {
    return [[self fieldTag] isDataTag];
}

- (id)copyWithZone:(NSZone *)zone {
    BibRecordField *field = [BibRecordField allocWithZone:zone];
    if ([self isDataField]) {
        return [field initWithFieldTag:[self fieldTag]
                        firstIndicator:[self firstIndicator]
                       secondIndicator:[self secondIndicator]
                             subfields:[self subfields]];
    } else if ([self isControlField]) {
        return [field initWithFieldTag:[self fieldTag] controlValue:[self controlValue]];
    } else {
        return [field initWithFieldTag:[self fieldTag]];
    }
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    BibMutableRecordField *field = [BibMutableRecordField allocWithZone:zone];
    if ([self isDataField]) {
        return [field initWithFieldTag:[self fieldTag]
                        firstIndicator:[self firstIndicator]
                       secondIndicator:[self secondIndicator]
                             subfields:[self subfields]];
    } else if ([self isControlField]) {
        return [field initWithFieldTag:[self fieldTag] controlValue:[self controlValue]];
    } else {
        return [field initWithFieldTag:[self fieldTag]];
    }
}

- (NSString *)description {
    if (self.isDataField) {
        return [[self.subfields valueForKey:BibKey(description)] componentsJoinedByString:@" "];

    } else if (self.isControlField) {
        return self.controlValue;

    } else {
        return @"";
    }
}

- (NSString *)debugDescription {
    if (self.isDataField) {
        NSString *const content = [[self.subfields valueForKey:BibKey(debugDescription)] componentsJoinedByString:@""];
        return [NSString stringWithFormat:@"%@ %@%@ %@",
                                          self.fieldTag, self.firstIndicator, self.secondIndicator, content];
    } else if (self.isControlField) {
        return [NSString stringWithFormat:@"%@ %@", self.fieldTag, self.controlValue];

    } else {
        return [NSString stringWithFormat:@"%@", self.fieldTag];
    }
}

@end

#pragma mark - Equality

@implementation BibRecordField (Equality)

- (BOOL)isEqualToRecordField:(BibRecordField *)recordField {
    return (self == recordField)
        || ((recordField != nil)
            && [[self fieldTag] isEqualToTag:[recordField fieldTag]]
            && (![self isControlField] || [[self controlValue] isEqualToString:[recordField controlValue]])
            && (![self isDataField] || ([[self firstIndicator] isEqualToIndicator:[recordField firstIndicator]]
                                        && [[self secondIndicator] isEqualToIndicator:[recordField secondIndicator]]
                                        && [[self subfields] isEqualToArray:[recordField subfields]])));
}

- (BOOL)isEqual:(id)object {
    return (self == object)
        || ((object != nil)
            && ([object isKindOfClass:[BibRecordField self]] && [self isEqualToRecordField:object]));
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self fieldTag]];
    if ([self isDataField]) {
        [hasher combineWithObject:[self firstIndicator]];
        [hasher combineWithObject:[self secondIndicator]];
        [hasher combineWithObject:[self subfields]];
    } else if ([self isControlField]) {
        [hasher combineWithObject:[self controlValue]];
    }
    return [hasher hash];
}

@end

#pragma mark - Serialization

@implementation BibRecordField (Serialization)

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)coder {
    BibFieldTag *const fieldTag = [coder decodeObjectOfClass:[BibFieldTag self] forKey:BibKey(fieldTag)];
    if (self = [self initWithFieldTag:fieldTag]) {
        if ([_fieldTag isControlTag]) {
            _controlValue = [coder decodeObjectOfClass:[NSString self] forKey:BibKey(controlValue)];
        } else if ([_fieldTag isDataTag]) {
            _firstIndicator = [coder decodeObjectOfClass:[BibFieldIndicator self] forKey:BibKey(firstIndicator)];
            _secondIndicator = [coder decodeObjectOfClass:[BibFieldIndicator self] forKey:BibKey(secondIndicator)];
            _subfields = [coder decodeObjectOfClass:[NSArray self] forKey:BibKey(subfields)];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self fieldTag] forKey:BibKey(fieldTag)];
    BibFieldTag *const fieldTag = [self fieldTag];
    if ([fieldTag isControlTag]) {
        [coder encodeObject:[self controlValue] forKey:BibKey(controlValue)];
    } else if ([fieldTag isDataTag]) {
        [coder encodeObject:[self firstIndicator] forKey:BibKey(firstIndicator)];
        [coder encodeObject:[self secondIndicator] forKey:BibKey(secondIndicator)];
        [coder encodeObject:[self subfields] forKey:BibKey(subfields)];
    }
}

@end

#pragma mark - Immutable Optimizations

@implementation _BibIRecordField

- (id)copyWithZone:(NSZone *)zone {
    NSZone *current = NSZoneFromPointer((__bridge void *)self);
    if ((zone == nil && current == NSDefaultMallocZone()) || current == zone) {
        return self;
    }
    return [super copyWithZone:zone];
}

@end

#pragma mark - Lazy Copying Arrays

@interface _BibLazyMutableSubfieldArray : NSMutableArray<BibMutableSubfield *>
- (instancetype)initWithSubfields:(NSArray<BibSubfield *> *)subfields;
@end

#pragma mark - Mutable Record Field

@implementation BibMutableRecordField

@dynamic fieldTag;
@dynamic controlValue;
@dynamic firstIndicator;
@dynamic secondIndicator;
@dynamic subfields;

- (void)setFieldTag:(BibFieldTag *)fieldTag {
    if (_fieldTag != fieldTag) {
        if (![self isControlField] && [fieldTag isControlTag]) {
            _fieldTag = [fieldTag copy];
            [self setControlValue:@""];
            [self setFirstIndicator:nil];
            [self setSecondIndicator:nil];
            [self setSubfields:nil];
        } else if (![self isDataField] && [fieldTag isDataTag]) {
            _fieldTag = [fieldTag copy];
            [self setControlValue:nil];
            [self setFirstIndicator:[BibFieldIndicator blank]];
            [self setSecondIndicator:[BibFieldIndicator blank]];
            [self setSubfields:[NSArray new]];
        } else if (![fieldTag isDataTag] && ![fieldTag isDataTag]) {
            _fieldTag = [fieldTag copy];
            [self setControlValue:nil];
            [self setFirstIndicator:nil];
            [self setSecondIndicator:nil];
            [self setSubfields:nil];
        }
    }
}

- (void)setControlValue:(NSString *)controlValue {
    if ([self isControlField]) {
        if (_controlValue != controlValue) {
            _controlValue = [controlValue copy] ?: @"";
        }
    } else {
        _controlValue = nil;
    }
}

- (void)setFirstIndicator:(BibFieldIndicator *)firstIndicator {
    if ([self isDataField]) {
        if (_firstIndicator != firstIndicator) {
            _firstIndicator = [firstIndicator copy] ?: [BibFieldIndicator blank];
        }
    } else {
        _firstIndicator = nil;
    }
}

- (void)setSecondIndicator:(BibFieldIndicator *)secondIndicator {
    if ([self isDataField]) {
        if (_secondIndicator != secondIndicator) {
            _secondIndicator = [secondIndicator copy] ?: [BibFieldIndicator blank];
        }
    } else {
        _secondIndicator = nil;
    }
}

- (NSArray<BibMutableSubfield *> *)subfields {
    return [_subfields copy];
}

- (void)setSubfields:(NSArray<BibMutableSubfield *> *)subfields {
    if ([self isDataField]) {
        if (_subfields != subfields) {
            _subfields = [subfields mutableCopy] ?: [NSMutableArray new];
        }
    } else {
        _subfields = nil;
    }
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag
                  firstIndicator:(BibFieldIndicator *)firstIndicator
                 secondIndicator:(BibFieldIndicator *)secondIndicator
                       subfields:(NSArray<BibSubfield *> *)subfields {
    if (self = [super initWithFieldTag:fieldTag
                        firstIndicator:firstIndicator
                       secondIndicator:secondIndicator
                             subfields:[NSArray new]]) {
        _subfields = [[_BibLazyMutableSubfieldArray alloc] initWithSubfields:subfields];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    BibRecordField *field = [BibRecordField allocWithZone:zone];
    if ([self isDataField]) {
        NSMutableArray *subfields = [[NSMutableArray allocWithZone:zone] initWithCapacity:[[self subfields] count]];
        for (BibSubfield *subfield in [self subfields]) {
            [subfields addObject:[subfield copy]];
        }
        return [field initWithFieldTag:[self fieldTag]
                        firstIndicator:[self firstIndicator]
                       secondIndicator:[self secondIndicator]
                             subfields:subfields];
    } else if ([self isControlField]) {
        return [field initWithFieldTag:[self fieldTag] controlValue:[self controlValue]];
    } else {
        return [field initWithFieldTag:[self fieldTag]];
    }
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    BibMutableRecordField *field = [BibMutableRecordField allocWithZone:zone];
    if ([self isDataField]) {
        return [field initWithFieldTag:[self fieldTag]
                        firstIndicator:[self firstIndicator]
                       secondIndicator:[self secondIndicator]
                             subfields:[self subfields]];
    } else if ([self isControlField]) {
        return [field initWithFieldTag:[self fieldTag] controlValue:[self controlValue]];
    } else {
        return [field initWithFieldTag:[self fieldTag]];
    }
}

@end

#pragma mark - Subfield Access

@implementation BibRecordField (SubfieldAccess)

- (NSUInteger)subfieldCount {
    return [[self subfields] count];
}

- (BibSubfield *)subfieldAtIndex:(NSUInteger)index {
    return [[self subfields] objectAtIndex:index];
}

- (BibSubfield *)objectAtIndexedSubscript:(NSUInteger)index {
    return [self subfieldAtIndex:index];
}

- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode {
    for (BibSubfield *subfield in [self subfields]) {
        if ([[subfield subfieldCode] isEqual:subfieldCode]) {
            return subfield;
        }
    }
    return nil;
}

- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode inRange:(NSRange)range {
    for (BibSubfield *subfield in [[self subfields] subarrayWithRange:range]) {
        if ([[subfield subfieldCode] isEqual:subfieldCode]) {
            return subfield;
        }
    }
    return nil;
}

- (NSArray<BibSubfield *> *)subfieldsWithCode:(BibSubfieldCode)subfieldCode {
    NSMutableArray *subfields = [NSMutableArray new];
    if ([self subfields] == nil) {
        return [subfields copy];
    }
    for (BibSubfield *subfield in [self subfields]) {
        if ([[subfield subfieldCode] isEqual:subfieldCode]) {
            [subfields addObject:subfield];
        }
    }
    return [subfields copy];
}

- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode {
    NSArray *subfields = [self subfields];
    if (subfields == nil) {
        return NSNotFound;
    }
    return [subfields indexOfObjectPassingTest:^BOOL(BibSubfield *subfield, NSUInteger idx, BOOL *stop) {
        return [[subfield subfieldCode] isEqualToString:subfieldCode];
    }];
}

- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode inRange:(NSRange)range {
    NSArray *subarray = [[self subfields] subarrayWithRange:range];
    if (subarray == nil) {
        return NSNotFound;
    }
    NSUInteger index = [subarray indexOfObjectPassingTest:^BOOL(BibSubfield *subfield, NSUInteger idx, BOOL *stop) {
        return [[subfield subfieldCode] isEqualToString:subfieldCode];
    }];
    return (index != NSNotFound) ? (index + range.location) : NSNotFound;
}

- (NSIndexSet *)indexesOfSubfieldsWithCode:(BibSubfieldCode)subfieldCode {
    return [[self subfields] indexesOfObjectsPassingTest:^BOOL(BibSubfield *subfield, NSUInteger idx, BOOL *stop) {
        return [[subfield subfieldCode] isEqualToString:subfieldCode];
    }] ?: [NSIndexSet new];
}

- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode {
    NSArray *subfields = [self subfields];
    if (subfields == nil) {
        return NO;
    }
    for (BibSubfield *subfield in subfields) {
        if ([[subfield subfieldCode] isEqual:subfieldCode]) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark - Subfield Modifications

@implementation BibMutableRecordField (SubfieldModification)

- (void)addSubfield:(BibMutableSubfield *)subfield {
    [(NSMutableArray *)_subfields addObject:subfield];
}

- (void)removeSubfield:(BibMutableSubfield *)subfield {
    [(NSMutableArray *)_subfields removeObject:subfield];
}

- (void)removeSubfieldAtIndex:(NSUInteger)index {
    [(NSMutableArray *)_subfields removeObjectAtIndex:index];
}

- (void)insertSubfield:(BibMutableSubfield *)subfield atIndex:(NSUInteger)index {
    [(NSMutableArray *)_subfields insertObject:subfield atIndex:index];
}

- (void)replaceSubfieldAtIndex:(NSUInteger)index withSubfield:(BibMutableSubfield *)subfield {
    [(NSMutableArray *)_subfields replaceObjectAtIndex:index withObject:subfield];
}

- (void)setObject:(BibMutableSubfield *)subfield atIndexedSubscript:(NSUInteger)index {
    [(NSMutableArray *)_subfields setObject:subfield atIndexedSubscript:index];
}

@end

#pragma mark - Lazy Copying Arrays

@implementation _BibLazyMutableSubfieldArray {
    NSMutableArray<BibSubfield *> *_subfields;
}

- (instancetype)initWithSubfields:(NSArray<BibSubfield *> *)subfields {
    if (self = [super init]) {
        _subfields = [subfields mutableCopy];
    }
    return self;
}

- (NSUInteger)count {
    return [_subfields count];
}

- (BibMutableSubfield *)objectAtIndex:(NSUInteger)index {
    BibSubfield *subfield = [_subfields objectAtIndex:index];
    if ([subfield isKindOfClass:[BibMutableSubfield class]]) {
        return (BibMutableSubfield *)subfield;
    } else {
        BibMutableSubfield *mutableSubfield = [subfield mutableCopy];
        [_subfields replaceObjectAtIndex:index withObject:mutableSubfield];
        return mutableSubfield;
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_subfields insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_subfields removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    [_subfields addObject:anObject];
}

- (void)removeLastObject {
    [_subfields removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_subfields replaceObjectAtIndex:index withObject:anObject];
}

@end
