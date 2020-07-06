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
#import <objc/runtime.h>

@interface _BibRecordNofield : BibRecordField
@end

@interface _BibRecordDatafield : BibRecordField
@end

@interface _BibRecordControlfield : BibRecordField
@end

@interface _BibMutableRecordNofield : BibMutableRecordField
@end

@interface _BibMutableRecordDatafield : BibMutableRecordField
@end

@interface _BibMutableRecordControlfield : BibMutableRecordField
@end

#pragma mark - Field

@implementation BibRecordField {
@public
    BibFieldTag *_fieldTag;
    NSString *_controlValue;
    BibFieldIndicator *_firstIndicator;
    BibFieldIndicator *_secondIndicator;
    NSMutableArray<BibSubfield *> *_subfields;
}

@synthesize fieldTag = _fieldTag;
@synthesize controlValue = _controlValue;
@synthesize firstIndicator = _firstIndicator;
@synthesize secondIndicator = _secondIndicator;
@synthesize subfields = _subfields;

- (instancetype)init {
    return [self initWithFieldTag:[BibFieldTag new]];
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag {
    if (fieldTag == nil) {
        return nil;
    }
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        if ([self class] == [BibRecordField self]) {
            if ([_fieldTag isControlTag]) {
                _controlValue = @"";
                object_setClass(self, [_BibRecordControlfield self]);
            } else if ([_fieldTag isDataTag]) {
                _subfields = [NSMutableArray new];
                object_setClass(self, [_BibRecordDatafield self]);
            } else {
                object_setClass(self, [_BibRecordNofield self]);
            }
        } else if ([self class] == [BibMutableRecordField self]) {
            if ([_fieldTag isControlTag]) {
                object_setClass(self, [_BibMutableRecordControlfield self]);
            } else if ([_fieldTag isDataTag]) {
                object_setClass(self, [_BibMutableRecordDatafield self]);
            } else {
                object_setClass(self, [_BibMutableRecordNofield self]);
            }
        }
    }
    return self;
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag controlValue:(NSString *)controlValue {
    NSParameterAssert(fieldTag.isControlTag);
    if (self = [self initWithFieldTag:fieldTag]) {
        _controlValue = [controlValue copy];
    }
    return self;
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag
                  firstIndicator:(BibFieldIndicator *)firstIndicator
                 secondIndicator:(BibFieldIndicator *)secondIndicator
                       subfields:(NSArray<BibSubfield *> *)subfields {
    NSParameterAssert(fieldTag.isDataTag);
    if (self = [self initWithFieldTag:fieldTag]) {
        _firstIndicator = [firstIndicator copy];
        _secondIndicator = [secondIndicator copy];
        _subfields = [subfields mutableCopy];
    }
    return self;
}

- (NSString *)controlValue { return [self isControlField] ? (_controlValue ?: @"") : nil; }

- (BibFieldIndicator *)firstIndicator { return [self isDataField] ? (_firstIndicator ?: [BibFieldIndicator new]) : nil; }
- (BibFieldIndicator *)secondIndicator { return [self isDataField] ? (_secondIndicator ?: [BibFieldIndicator new]) : nil; }
- (NSArray<BibSubfield *> *)subfields { return [self isDataField] ? ([_subfields copy] ?: [NSArray new]) : nil; }

- (BOOL)isControlField { return [[self fieldTag] isControlTag]; }
- (BOOL)isDataField { return [[self fieldTag] isDataTag]; }

+ (NSSet *)keyPathsForValuesAffectingControlValue { return [NSSet setWithObject:BibKeyPath(fieldTag)]; }
+ (NSSet *)keyPathsForValuesAffectingFirstIndicator { return [NSSet setWithObject:BibKeyPath(fieldTag)]; }
+ (NSSet *)keyPathsForValuesAffectingSecondIndicator { return [NSSet setWithObject:BibKeyPath(fieldTag)]; }
+ (NSSet *)keyPathsForValuesAffectingSubfields { return [NSSet setWithObject:BibKeyPath(fieldTag)]; }
+ (NSSet *)keyPathsForValuesAffectingIsControlfield { return [NSSet setWithObject:BibKeyPath(fieldTag)]; }
+ (NSSet *)keyPathsForValuesAffectingIsDatafield { return [NSSet setWithObject:BibKeyPath(fieldTag)]; }

- (id)copyWithZone:(NSZone *)zone {
    if ([self isDataField]) {
        _BibRecordDatafield *const copy = [_BibRecordDatafield new];
        copy->_fieldTag = [[self fieldTag] copy];
        copy->_firstIndicator = [[self firstIndicator] copy];
        copy->_secondIndicator = [[self secondIndicator] copy];
        copy->_subfields = [[self subfields] mutableCopy] ?: [NSMutableArray new];
        return copy;
    } else if ([self isControlField]) {
        _BibRecordControlfield *const copy = [_BibRecordControlfield new];
        copy->_fieldTag = [[self fieldTag] copy];
        copy->_controlValue = [[self controlValue] copy];
        return copy;
    } else {
        return [_BibRecordNofield new];
    }
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    if ([self isDataField]) {
        _BibMutableRecordDatafield *const mutableCopy = [_BibMutableRecordDatafield new];
        mutableCopy->_fieldTag = [[self fieldTag] copy];
        mutableCopy->_firstIndicator = [[self firstIndicator] copy];
        mutableCopy->_secondIndicator = [[self secondIndicator] copy];
        mutableCopy->_subfields = [[self subfields] mutableCopy] ?: [NSMutableArray new];
        return mutableCopy;
    } else if ([self isControlField]) {
        _BibMutableRecordControlfield *const mutableCopy = [_BibMutableRecordControlfield new];
        mutableCopy->_fieldTag = [[self fieldTag] copy];
        mutableCopy->_controlValue = [[self controlValue] copy];
        return mutableCopy;
    } else {
        return [_BibMutableRecordNofield new];
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
        return self.firstIndicator.description;
    }
}

@end

@implementation BibRecordField (SubfieldAccess)

- (NSUInteger)subfieldCount { return self.subfields.count; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [self.subfields objectAtIndex:index]; }
- (BibSubfield *)objectAtIndexedSubscript:(NSUInteger)index { return [self subfieldAtIndex:index]; }

- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode {
    NSArray *const subfields = self.subfields;
    NSUInteger const count = subfields.count;
    for (NSUInteger index = 0; index < count; index += 1) {
        if ([[[subfields objectAtIndex:index] subfieldCode] isEqualToString:subfieldCode]) {
            return index;
        }
    }
    return NSNotFound;
}

- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode {
    NSUInteger const index = [self indexOfSubfieldWithCode:subfieldCode];
    return (index == NSNotFound) ? nil : [self subfieldAtIndex:index];
}

- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode {
    return [self indexOfSubfieldWithCode:subfieldCode] != NSNotFound;
}

@end

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

#pragma mark - Field Specialization

@implementation _BibRecordNofield

- (BOOL)isControlField { return NO; }
- (BOOL)isDataField { return NO; }
- (NSString *)controlValue { return nil; }
- (BibFieldIndicator *)firstIndicator { return nil; }
- (BibFieldIndicator *)secondIndicator { return nil; }
- (NSArray<BibSubfield *> *)subfields { return nil; }

- (NSUInteger)subfieldCount { return 0; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [[NSArray new] objectAtIndex:index]; }
- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NSNotFound; }
- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode { return nil; }
- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NO; }

- (Class)classForCoder { return [BibRecordField self]; }

@end

@implementation _BibRecordDatafield

- (BOOL)isControlField { return NO; }
- (BOOL)isDataField { return YES; }
- (NSString *)controlValue { return nil; }
- (BibFieldIndicator *)firstIndicator { return _firstIndicator; }
- (BibFieldIndicator *)secondIndicator { return _secondIndicator; }
- (NSArray<BibSubfield *> *)subfields { return [_subfields copy] ?: [NSArray array]; }

- (NSUInteger)subfieldCount { return _subfields.count; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [_subfields objectAtIndex:index]; }

- (Class)classForCoder { return [BibRecordField self]; }

@end

@implementation _BibRecordControlfield

- (BOOL)isControlField { return YES; }
- (BOOL)isDataField { return NO; }
- (NSString *)controlValue { return (_controlValue ?: @""); }
- (BibFieldIndicator *)firstIndicator { return nil; }
- (BibFieldIndicator *)secondIndicator { return nil; }
- (NSArray<BibSubfield *> *)subfields { return nil; }

- (NSUInteger)subfieldCount { return 0; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [[NSArray new] objectAtIndex:index]; }
- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NSNotFound; }
- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode { return nil; }
- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NO; }

- (Class)classForCoder { return [BibRecordField self]; }

@end

#pragma mark - Mutable Field

@implementation BibMutableRecordField

@dynamic fieldTag;
@dynamic controlValue;
@dynamic firstIndicator;
@dynamic secondIndicator;
@dynamic subfields;

- (Class)classForCoder { return [BibRecordField self]; }

+ (BOOL)automaticallyNotifiesObserversOfFieldTag { return NO; }
+ (BOOL)automaticallyNotifiesObserversOfControlValue { return NO; }
+ (BOOL)automaticallyNotifiesObserversOfFirstIndicator { return NO; }
+ (BOOL)automaticallyNotifiesObserversOfSecondIndicator { return NO; }
+ (BOOL)automaticallyNotifiesObserversOfSubfields { return NO; }

- (void)setFieldTag:(BibFieldTag *)fieldTag {
    if (_fieldTag != fieldTag) {
        [self willChangeValueForKey:BibKey(fieldTag)];
        _fieldTag = [fieldTag copy];
        [self didChangeValueForKey:BibKey(fieldTag)];
    }
}

- (void)setControlValue:(NSString *)controlValue {
    if (_controlValue != controlValue) {
        [self willChangeValueForKey:BibKey(controlValue)];
        _controlValue = [controlValue copy] ?: @"";
        [self didChangeValueForKey:BibKey(controlValue)];
    }
}

- (void)setFirstIndicator:(BibFieldIndicator *)firstIndicator {
    if (_firstIndicator != firstIndicator) {
        [self willChangeValueForKey:BibKey(firstIndicator)];
        _firstIndicator = [firstIndicator copy] ?: [BibFieldIndicator new];
        [self didChangeValueForKey:BibKey(firstIndicator)];
    }
}

- (void)setSecondIndicator:(BibFieldIndicator *)secondIndicator {
    if (_secondIndicator != secondIndicator) {
        [self willChangeValueForKey:BibKey(secondIndicator)];
        _secondIndicator = [secondIndicator copy] ?: [BibFieldIndicator new];
        [self didChangeValueForKey:BibKey(secondIndicator)];
    }
}

- (void)setSubfields:(NSArray<BibSubfield *> *)subfields {
    if (_subfields != subfields) {
        [self willChangeValueForKey:BibKey(subfields)];
        _subfields = [subfields mutableCopy] ?: [NSMutableArray new];
        [self didChangeValueForKey:BibKey(subfields)];
    }
}

@end

@implementation BibMutableRecordField (SubfieldAccess)

- (void)addSubfield:(BibSubfield *)subfield {
    [self insertSubfield:subfield atIndex:_subfields.count];
}

- (void)removeSubfield:(BibSubfield *)subfield {
    NSUInteger const index = [_subfields indexOfObject:subfield];
    if (index != NSNotFound) {
        NSIndexSet *const indexes = [[NSIndexSet alloc] initWithIndex:index];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:BibKey(subfields)];
        [_subfields removeObjectAtIndex:index];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:BibKey(subfields)];
    }
}

- (void)insertSubfield:(BibSubfield *)subfield atIndex:(NSUInteger)index {
    NSIndexSet *const indexes = [[NSIndexSet alloc] initWithIndex:_subfields.count];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:BibKey(subfields)];
    [_subfields insertObject:[subfield copy] atIndex:index];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:BibKey(subfields)];
}

- (void)replaceSubfieldAtIndex:(NSUInteger)index withSubfield:(BibSubfield *)subfield {
    NSIndexSet *const indexes = [[NSIndexSet alloc] initWithIndex:_subfields.count];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:BibKey(subfields)];
    [_subfields replaceObjectAtIndex:index withObject:[subfield copy]];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:BibKey(subfields)];
}

- (void)setSubfield:(BibSubfield *)subfield atIndex:(NSUInteger)index {
    [self replaceSubfieldAtIndex:index withSubfield:subfield];
}

- (void)setObject:(BibSubfield *)subfield atIndexedSubscript:(NSUInteger)index {
    [self replaceSubfieldAtIndex:index withSubfield:subfield];
}

@end

#pragma mark - Mutable Field Specialization

@implementation _BibMutableRecordNofield

- (BOOL)isControlField { return NO; }
- (BOOL)isDataField { return NO; }
- (NSString *)controlValue { return nil; }
- (BibFieldIndicator *)firstIndicator { return nil; }
- (BibFieldIndicator *)secondIndicator { return nil; }
- (NSArray<BibSubfield *> *)subfields { return nil; }

- (NSUInteger)subfieldCount { return 0; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [[NSArray new] objectAtIndex:index]; }
- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NSNotFound; }
- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode { return nil; }
- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NO; }

- (void)setFieldTag:(BibFieldTag *)fieldTag {
    if (_fieldTag != fieldTag) {
        [self willChangeValueForKey:BibKey(fieldTag)];
        _fieldTag = [fieldTag copy];
        if ([fieldTag isDataTag]) {
            object_setClass(self, [_BibMutableRecordDatafield self]);
            self->_firstIndicator = [BibFieldIndicator new];
            self->_secondIndicator = [BibFieldIndicator new];
            self->_subfields = [NSMutableArray new];
        } else if ([fieldTag isControlTag]) {
            object_setClass(self, [_BibMutableRecordControlfield self]);
            self->_controlValue = @"";
        }
        [self didChangeValueForKey:BibKey(fieldTag)];
    }
}

- (void)setControlValue:(NSString *)controlValue {}
- (void)setFirstIndicator:(NSString *)firstIndicator {}
- (void)setSecondIndicator:(NSString *)secondIndicator {}
- (void)setSubfields:(NSArray<BibSubfield *> *)subfields {}

- (void)addSubfield:(BibSubfield *)subfield {}
- (void)removeSubfield:(BibSubfield *)subfield {}
- (void)insertSubfield:(BibSubfield *)subfield atIndex:(NSUInteger)index {}
- (void)replaceSubfieldAtIndex:(NSUInteger)index withSubfield:(BibSubfield *)subfield {}

@end

@implementation _BibMutableRecordDatafield

- (BOOL)isControlField { return NO; }
- (BOOL)isDataField { return YES; }
- (NSString *)controlValue { return nil; }
- (BibFieldIndicator *)firstIndicator { return _firstIndicator; }
- (BibFieldIndicator *)secondIndicator { return _secondIndicator; }
- (NSArray<BibSubfield *> *)subfields { return [_subfields copy]; }

- (NSUInteger)subfieldCount { return _subfields.count; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [_subfields objectAtIndex:index]; }

- (void)setFieldTag:(BibFieldTag *)fieldTag {
    if (_fieldTag != fieldTag) {
        [self willChangeValueForKey:BibKey(fieldTag)];
        _fieldTag = [fieldTag copy];
        if ([fieldTag isDataTag]) {
        } else if ([fieldTag isControlTag]) {
            object_setClass(self, [_BibMutableRecordControlfield self]);
            self->_controlValue = @"";
            self->_firstIndicator = nil;
            self->_secondIndicator = nil;
            self->_subfields = nil;
        } else {
            object_setClass(self, [_BibMutableRecordNofield self]);
            self->_firstIndicator = nil;
            self->_secondIndicator = nil;
            self->_subfields = nil;
        }
        [self didChangeValueForKey:BibKey(fieldTag)];
    }
}

- (void)setControlValue:(NSString *)controlValue {}

@end

@implementation _BibMutableRecordControlfield

- (BOOL)isControlField { return YES; }
- (BOOL)isDataField { return NO; }
- (NSString *)controlValue { return _controlValue ?: @""; }
- (BibFieldIndicator *)firstIndicator { return nil; }
- (BibFieldIndicator *)secondIndicator { return nil; }
- (NSArray<BibSubfield *> *)subfields { return nil; }

- (NSUInteger)subfieldCount { return 0; }
- (BibSubfield *)subfieldAtIndex:(NSUInteger)index { return [[NSArray new] objectAtIndex:index]; }
- (NSUInteger)indexOfSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NSNotFound; }
- (BibSubfield *)subfieldWithCode:(BibSubfieldCode)subfieldCode { return nil; }
- (BOOL)containsSubfieldWithCode:(BibSubfieldCode)subfieldCode { return NO; }

- (void)setFieldTag:(BibFieldTag *)fieldTag {
    if (_fieldTag != fieldTag) {
        [self willChangeValueForKey:BibKey(fieldTag)];
        _fieldTag = [fieldTag copy];
        if ([fieldTag isDataTag]) {
            object_setClass(self, [_BibMutableRecordDatafield self]);
            self->_controlValue = nil;
            self->_firstIndicator = [BibFieldIndicator new];
            self->_secondIndicator = [BibFieldIndicator new];
            self->_subfields = [NSMutableArray new];
        } else if ([fieldTag isControlTag]) {
        } else {
            object_setClass(self, [_BibMutableRecordNofield self]);
            self->_controlValue = nil;
        }
        [self didChangeValueForKey:BibKey(fieldTag)];
    }
}

- (void)setFirstIndicator:(BibFieldIndicator *)firstIndicator {}
- (void)setSecondIndicator:(BibFieldIndicator *)secondIndicator {}
- (void)setSubfields:(NSArray<BibSubfield *> *)subfields {}

- (void)addSubfield:(BibSubfield *)subfield {}
- (void)removeSubfield:(BibSubfield *)subfield {}
- (void)insertSubfield:(BibSubfield *)subfield atIndex:(NSUInteger)index {}
- (void)replaceSubfieldAtIndex:(NSUInteger)index withSubfield:(BibSubfield *)subfield {}

@end
