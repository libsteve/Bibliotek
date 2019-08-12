//
//  BibLCClassificationNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibLCClassificationNumber.h"

@implementation BibLCClassificationNumber {
@protected
    NSString *_classification;
    NSString *_item;
    NSArray *_alternatives;
    BibLibraryOfCongressOwnership _libraryOfCongressOwnership;
    BibLCClassificationNumberSource _source;
}

@synthesize classification = _classification;
@synthesize item = _item;
@synthesize alternatives = _alternatives;
@synthesize libraryOfCongressOwnership = _libraryOfCongressOwnership;
@synthesize source = _source;

- (instancetype)initWithClassification:(NSString *)classification
                                  item:(NSString *)item {
    if (self = [super init]) {
        _classification = [classification copy];
        _item = [item copy];
        _alternatives = [NSArray new];
        _libraryOfCongressOwnership = BibLibraryOfCongressOwnershipUnknown;
        _source = BibLCClassificationNumberSourceOther;
    }
    return self;
}

- (instancetype)initWithLCClassificationNumber:(BibLCClassificationNumber *)callNumber {
    if (self = [self initWithClassification:[callNumber classification]
                                       item:[callNumber item]]) {
        _libraryOfCongressOwnership = [callNumber libraryOfCongressOwnership];
        _source = [callNumber source];
    }
    return self;
}

- (instancetype)init {
    return nil;
}

+ (instancetype)new {
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableLCClassificationNumber alloc] initWithLCClassificationNumber:self];
}

@end

@implementation BibLCClassificationNumber (Equality)

inline static BOOL sNullableStringsEqual(NSString *first, NSString *second) {
    return first == second
        || (first && second && [first isEqualToString:second]);
}

- (BOOL)isEqualToLCClassificationNumber:(BibLCClassificationNumber *)classificationNumber {
    if (self == classificationNumber) {
        return YES;
    }
    return [[self classification] isEqualToString:[classificationNumber classification]]
        && sNullableStringsEqual([self item], [classificationNumber item])
        && [[self alternatives] isEqualToArray:[classificationNumber alternatives]]
        && [self libraryOfCongressOwnership] == [classificationNumber libraryOfCongressOwnership]
        && [self source] == [classificationNumber source];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibLCClassificationNumber class]] && [self isEqualToLCClassificationNumber:object]);
}

inline static NSUInteger sRotateUnsignedInteger(NSUInteger const value, NSUInteger const rotation) {
    static NSUInteger const bitCount = CHAR_BIT * sizeof(NSUInteger);
    NSUInteger const amount = bitCount / rotation;
    return (value << amount) | (value >> (bitCount - amount));
}

- (NSUInteger)hash {
    return [[self classification] hash]
         ^ sRotateUnsignedInteger([[self item] hash], 2)
         ^ sRotateUnsignedInteger([[self alternatives] hash], 3)
         ^ sRotateUnsignedInteger([self libraryOfCongressOwnership], 4)
         ^ sRotateUnsignedInteger([self source], 5);
}

@end

#pragma mark - Mutable

@implementation BibMutableLCClassificationNumber

- (id)copyWithZone:(NSZone *)zone {
    return [[BibLCClassificationNumber alloc] initWithLCClassificationNumber:self];
}

@dynamic classification;
- (void)setClassification:(NSString *)classification {
    if (_classification != classification) {
        _classification = [classification copy];
    }
}

@dynamic item;
- (void)setItem:(NSString *)item {
    if (_item != item) {
        _item = [item copy];
    }
}

@dynamic alternatives;
- (void)setAlternativeNumbers:(NSArray<NSString *> *)alternatives {
    if (_alternatives != alternatives) {
        _alternatives = [alternatives copy];
    }
}

@dynamic libraryOfCongressOwnership;
- (void)setLibraryOfCongressOwnership:(BibLibraryOfCongressOwnership)libraryOfCongressOwnership {
    _libraryOfCongressOwnership = libraryOfCongressOwnership;
}

@dynamic source;
- (void)setSource:(BibLCClassificationNumberSource)source {
    _source = source;
}

@end
