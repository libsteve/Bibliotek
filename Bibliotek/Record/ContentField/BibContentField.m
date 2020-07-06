//
//  BibContentField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibContentField.h"
#import "BibSubfield.h"
#import "BibContentIndicatorList.h"
#import "BibFieldTag.h"
#import "BibHasher.h"

#import "Bibliotek+Internal.h"

#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation BibContentField {
@protected
    BibFieldTag *_tag;
    BibContentIndicatorList *_indicators;
    NSArray<BibSubfield *> *_subfields;
}

@synthesize tag = _tag;
@synthesize indicators = _indicators;
@synthesize subfields = _subfields;

- (instancetype)initWithTag:(BibFieldTag *)tag indicators:(NSArray *)indicators subfields:(NSArray *)subfields {
    if (self = [super init]) {
        _tag = tag;
        _indicators = [indicators copy];
        _subfields = [subfields copy];
    }
    return self;
}

- (instancetype)init {
    return [self initWithTag:[[BibFieldTag alloc] initWithString:@"100"]
                  indicators:[BibContentIndicatorList new]
                   subfields:[NSArray array]];
}

- (NSString *)description {
    return [[[self subfields] valueForKey:BibKey(description)] componentsJoinedByString:@" "];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:BibKey(tag), BibKey(indicators), BibKeyPath(subfields, description), nil];
}

- (NSString *)debugDescription {
    NSArray *const subfieldDebugDescriptions = [[self subfields] valueForKey:BibKey(debugDescription)];
    NSString *const combinedSubfiledsDebugDescription = [subfieldDebugDescriptions componentsJoinedByString:@""];
    return [NSString stringWithFormat:@"%@ %@ %@", [self tag], [self indicators], combinedSubfiledsDebugDescription];
}

+ (NSSet *)keyPathsForValuesAffectingDebugDescription {
    return [NSSet setWithObjects:BibKey(tag), BibKey(indicators), BibKey(subfields), nil];
}

@end

#pragma mark - Copying

@implementation BibContentField (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableContentField allocWithZone:zone] initWithTag:[self tag]
                                                         indicators:[self indicators]
                                                          subfields:[self subfields]];
}

@end

#pragma mark - Equality

@implementation BibContentField (Equality)

- (BOOL)isEqualToContentField:(BibContentField *)contentField {
    return [[self indicators] isEqualToIndicators:[contentField indicators]]
        && [[self subfields] isEqualToArray:[contentField subfields]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibContentField class]] && [self isEqualToContentField:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self indicators]];
    [hasher combineWithObject:[self subfields]];
    return [hasher hash];
}

@end

#pragma mark - Subfield Access

@implementation BibContentField (SubfieldAccess)

- (BibSubfieldEnumerator *)subfieldEnumerator {
    return [[BibSubfieldEnumerator alloc] initWithEnumerator:[[self subfields] objectEnumerator]];
}

- (BibSubfield *)firstSubfieldWithCode:(BibSubfieldCode)code {
    return [[self subfieldEnumerator] nextSubfieldWithCode:code];
}

- (NSString *)contentOfFirstSubfieldWithCode:(BibSubfieldCode)code {
    return [[self firstSubfieldWithCode:code] content];
}

- (NSIndexSet *)indexesOfSubfieldsWithCode:(BibSubfieldCode)code {
    NSMutableIndexSet *const indexSet = [NSMutableIndexSet new];
    NSArray *const subfields = [self subfields];
    NSUInteger const count = [subfields count];
    for (NSUInteger index = 0; index < count; index += 1) {
        BibSubfield *const subfield = [subfields objectAtIndex:index];
        if ([[subfield subfieldCode] isEqualToString:code]) {
            [indexSet addIndex:index];
        }
    }
    return [indexSet copy];
}

- (NSArray<BibSubfield *> *)subfieldsWithCode:(BibSubfieldCode)code {
    return [[self subfields] objectsAtIndexes:[self indexesOfSubfieldsWithCode:code]];
}

- (BibSubfield *)subfieldAtIndex:(NSUInteger)index {
    return [[self subfields] objectAtIndex:index];
}

@end

#pragma mark - Mutable

@implementation BibMutableContentField

- (id)copyWithZone:(NSZone *)zone {
    return [[BibContentField allocWithZone:zone] initWithTag:[self tag]
                                                  indicators:[self indicators]
                                                   subfields:[self subfields]];
}

@synthesize tag;
- (void)setTag:(BibFieldTag *)tag {
    if (_tag != tag) {
        _tag = tag;
    }
}

@synthesize indicators;
- (void)setIndicators:(BibContentIndicatorList *)indicators {
    if (_indicators != indicators) {
        _indicators = [indicators copy];
    }
}

@synthesize subfields;
- (void)setSubfields:(NSArray<BibSubfield *> *)subfields {
    if (_subfields != subfields) {
        _subfields = [subfields copy];
    }
}

@end
