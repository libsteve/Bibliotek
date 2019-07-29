//
//  BibDDClassificationNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDDClassificationNumber.h"

@implementation BibDDClassificationNumber {
@protected
    NSString *_classification;
    NSString *_item;
    NSArray *_alternatives;
    BibLibraryOfCongressOwnership _libraryOfCongressOwnership;
    NSString *_scheduleEdition;
    BibMarcOrganization _assigningAgency;
}

@synthesize classification = _classification;
@synthesize item = _item;
@synthesize alternatives = _alternatives;
@synthesize libraryOfCongressOwnership = _libraryOfCongressOwnership;
@synthesize scheduleEdition = _scheduleEdition;
@synthesize assigningAgency = _assigningAgency;

- (instancetype)initWithClassification:(NSString *)classification
                                  item:(NSString *)item {
    if (self = [super init]) {
        _classification = [classification copy];
        _item = [item copy];
        _alternatives = [NSArray new];
        _libraryOfCongressOwnership = BibLibraryOfCongressOwnershipUnknown;
        _scheduleEdition = nil;
        _assigningAgency = nil;
    }
    return self;
}

- (instancetype)initWithDDClassificationNumber:(BibDDClassificationNumber *)callNumber {
    if (self = [self initWithClassification:[callNumber classification]
                                       item:[callNumber item]]) {
        _alternatives = [[callNumber alternatives] copy];
        _libraryOfCongressOwnership = [callNumber libraryOfCongressOwnership];
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

inline static BOOL sNullableStringsEqual(NSString *first, NSString *second) {
    return first == second
        || (first && second && [first isEqualToString:second]);
}

- (BOOL)isEqualToDDClassificationNumber:(BibDDClassificationNumber *)classificationNumber {
    if (self == classificationNumber) {
        return YES;
    }
    return [[self classification] isEqualToString:[classificationNumber classification]]
        && sNullableStringsEqual([self item], [classificationNumber item])
        && [[self alternatives] isEqualToArray:[classificationNumber alternatives]]
        && [self libraryOfCongressOwnership] == [classificationNumber libraryOfCongressOwnership]
        && sNullableStringsEqual([self scheduleEdition], [classificationNumber scheduleEdition])
        && sNullableStringsEqual([self assigningAgency], [classificationNumber assigningAgency]);
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibDDClassificationNumber class]] && [self isEqualToDDClassificationNumber:object]);
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
         ^ sRotateUnsignedInteger([[self scheduleEdition] hash], 4)
         ^ sRotateUnsignedInteger([[self assigningAgency] hash], 5);
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

@dynamic libraryOfCongressOwnership;
- (void)setLibraryOfCongressOwnership:(BibLibraryOfCongressOwnership)libraryOfCongressOwnership {
    _libraryOfCongressOwnership = libraryOfCongressOwnership;
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
