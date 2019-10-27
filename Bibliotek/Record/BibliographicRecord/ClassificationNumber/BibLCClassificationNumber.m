//
//  BibLCClassificationNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibLCClassificationNumber.h"
#import "BibFieldTag.h"
#import "BibContentField.h"
#import "BibContentIndicatorList.h"
#import "BibHasher.h"

@implementation BibLCClassificationNumber {
@protected
    NSString *_classification;
    NSString *_item;
    NSArray *_alternatives;
    BibClassificationNumberSource _source;
    BibLibraryOfCongressOwnership _libraryOfCongressOwnership;
}

@synthesize classification = _classification;
@synthesize item = _item;
@synthesize alternatives = _alternatives;
@synthesize source = _source;
@synthesize libraryOfCongressOwnership = _libraryOfCongressOwnership;

- (instancetype)initWithClassification:(NSString *)classification
                                  item:(NSString *)item {
    if (self = [super init]) {
        _classification = [classification copy];
        _item = [item copy];
        _alternatives = [NSArray new];
        _source = BibClassificationNumberSourceOther;
        _libraryOfCongressOwnership = BibLibraryOfCongressOwnershipUnknown;
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

- (instancetype)initWithContentField:(BibContentField *)contentField {
    if (![[[contentField tag] stringValue] isEqualToString:@"050"]) {
        return nil;
    }
    NSString *const classification = [[contentField firstSubfieldWithCode:@"a"] content];
    if (classification == nil) {
        return nil;
    }
    NSString *const item = [[contentField firstSubfieldWithCode:@"b"] content];
    if (self = [self initWithClassification:classification item:item]) {
        _source = [[contentField indicators] secondIndicator];
        _libraryOfCongressOwnership = [[contentField indicators] firstIndicator];
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

- (BOOL)isEqualToLCClassificationNumber:(BibLCClassificationNumber *)classificationNumber {
    if (self == classificationNumber) {
        return YES;
    }
    return [[self classification] isEqualToString:[classificationNumber classification]]
        && BibNullableStringEqual([self item], [classificationNumber item])
        && [[self alternatives] isEqualToArray:[classificationNumber alternatives]]
        && [self libraryOfCongressOwnership] == [classificationNumber libraryOfCongressOwnership]
        && [self source] == [classificationNumber source];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibLCClassificationNumber class]] && [self isEqualToLCClassificationNumber:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self item]];
    [hasher combineWithObject:[self alternatives]];
    [hasher combineWithHash:[self source]];
    [hasher combineWithHash:[self libraryOfCongressOwnership]];
    return [hasher hash];
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
- (void)setSource:(BibClassificationNumberSource)source {
    _source = source;
}

@end
