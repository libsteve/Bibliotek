//
//  BibDDClassificationNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDDClassificationNumber.h"
#import "BibFieldTag.h"
#import "BibContentField.h"
#import "BibContentIndicatorList.h"
#import "BibHasher.h"

@implementation BibDDClassificationNumber {
@protected
    NSString *_classification;
    NSString *_item;
    NSArray *_alternatives;
    BibClassificationNumberSource _source;
    NSString *_scheduleEdition;
    BibMarcOrganization _assigningAgency;
}

@synthesize classification = _classification;
@synthesize item = _item;
@synthesize alternatives = _alternatives;
@synthesize source = _source;
@synthesize scheduleEdition = _scheduleEdition;
@synthesize assigningAgency = _assigningAgency;

- (instancetype)initWithClassification:(NSString *)classification
                                  item:(NSString *)item {
    if (self = [super init]) {
        _classification = [classification copy];
        _item = [item copy];
        _alternatives = [NSArray new];
        _source = BibClassificationNumberSourceOther;
        _scheduleEdition = nil;
        _assigningAgency = nil;
    }
    return self;
}

- (instancetype)initWithDDClassificationNumber:(BibDDClassificationNumber *)callNumber {
    if (self = [self initWithClassification:[callNumber classification]
                                       item:[callNumber item]]) {
        _alternatives = [[callNumber alternatives] copy];
        _source = [callNumber source];
        _scheduleEdition = [[callNumber scheduleEdition] copy];
        _assigningAgency = [[callNumber assigningAgency] copy];
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
    return [[BibMutableDDClassificationNumber alloc] initWithDDClassificationNumber:self];
}

@end

@implementation BibDDClassificationNumber (Equality)

- (BOOL)isEqualToDDClassificationNumber:(BibDDClassificationNumber *)classificationNumber {
    if (self == classificationNumber) {
        return YES;
    }
    return [[self classification] isEqualToString:[classificationNumber classification]]
        && BibNullableStringEqual([self item], [classificationNumber item])
        && [[self alternatives] isEqualToArray:[classificationNumber alternatives]]
        && [self source] == [classificationNumber source]
        && BibNullableStringEqual([self scheduleEdition], [classificationNumber scheduleEdition])
        && BibNullableStringEqual([self assigningAgency], [classificationNumber assigningAgency]);
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibDDClassificationNumber class]] && [self isEqualToDDClassificationNumber:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self classification]];
    [hasher combineWithObject:[self item]];
    [hasher combineWithHash:[self source]];
    [hasher combineWithObject:[self alternatives]];
    [hasher combineWithObject:[self scheduleEdition]];
    [hasher combineWithObject:[self assigningAgency]];
    return [hasher hash];
}

@end

#pragma mark - Mutable

@implementation BibMutableDDClassificationNumber

- (id)copyWithZone:(NSZone *)zone {
    return [[BibDDClassificationNumber alloc] initWithDDClassificationNumber:self];
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

@dynamic source;
- (void)setSource:(BibClassificationNumberSource)source {
    _source = source;
}

@dynamic scheduleEdition;
- (void)setScheduleEdition:(NSString *)scheduleEdition {
    if (_scheduleEdition != scheduleEdition) {
        _scheduleEdition = [scheduleEdition copy];
    }
}

@dynamic assigningAgency;
- (void)setAssigningAgency:(BibMarcOrganization)assigningAgency {
    if (_assigningAgency != assigningAgency) {
        _assigningAgency = [assigningAgency copy];
    }
}

@end
