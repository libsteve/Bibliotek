//
//  BibMarcDataField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcDataField.h"
#import "BibMarcIndicator.h"
#import "BibMarcSubfield.h"
#import "BibMarcTag.h"

#define guard(predicate) if(!((predicate)))

static NSString *const kTagKey = @"tag";
static NSString *const kInd1Key = @"ind1";
static NSString *const kInd2Key = @"ind2";
static NSString *const kFirstIndicatorKey = @"firstIndicator";
static NSString *const kSecondIndicatorKey = @"secondIndicator";
static NSString *const kSubfieldsKey = @"subfields";

@implementation BibMarcDataField {
@protected
    BibMarcTag *_tag;
    BibMarcIndicator *_firstIndicator;
    BibMarcIndicator *_secondIndicator;
    NSArray<BibMarcSubfield *> *_subfields;
}

@synthesize tag = _tag;
@synthesize firstIndicator = _firstIndicator;
@synthesize secondIndicator = _secondIndicator;
@synthesize subfields = _subfields;

- (instancetype)init {
    return [self initWithTag:[BibMarcTag tagWithString:@"100"]
              firstIndicator:[BibMarcIndicator new]
             secondIndicator:[BibMarcIndicator new]
                   subfields:[NSArray array]];
}

- (instancetype)initWithTag:(BibMarcTag *)tag
             firstIndicator:(BibMarcIndicator *)firstIndicator
            secondIndicator:(BibMarcIndicator *)secondIndicator
                  subfields:(NSArray<BibMarcSubfield *> *)subfields {
    guard([subfields count] >= 1) {
        return nil;
    }
    if ([tag isControlFieldTag]) {
        return nil;
    }
    if (self = [super init]) {
        _tag = tag;
        _firstIndicator = firstIndicator;
        _secondIndicator = secondIndicator;
        _subfields = [[NSArray alloc] initWithArray:subfields copyItems:YES];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    if (zone == nil && [[self class] isEqualTo:[BibMarcSubfield class]]) {
        return self;
    }
    return [[BibMarcDataField allocWithZone:zone] initWithTag:_tag
                                               firstIndicator:_firstIndicator
                                              secondIndicator:_secondIndicator
                                                    subfields:_subfields];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcMutableDataField allocWithZone:zone] initWithTag:_tag
                                                      firstIndicator:_firstIndicator
                                                     secondIndicator:_secondIndicator
                                                           subfields:_subfields];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTag:[aDecoder decodeObjectForKey:kTagKey]
              firstIndicator:[aDecoder decodeObjectForKey:kInd1Key]
             secondIndicator:[aDecoder decodeObjectForKey:kInd2Key]
                   subfields:[aDecoder decodeObjectForKey:kSubfieldsKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:kTagKey];
    [aCoder encodeObject:_firstIndicator forKey:kInd1Key];
    [aCoder encodeObject:_secondIndicator forKey:kInd2Key];
    [aCoder encodeObject:_subfields forKey:kSubfieldsKey];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Equality

- (BOOL)isEqualToDataField:(BibMarcDataField *)other {
    return [_tag isEqualToTag:[other tag]]
        && [_firstIndicator isEqualToIndicator:[other firstIndicator]]
        && [_secondIndicator isEqualToIndicator:[other secondIndicator]]
        && [_subfields isEqualToArray:[other subfields]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcDataField class]] && [self isEqualToDataField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_firstIndicator hash] ^ [_secondIndicator hash] ^ [_subfields hash];
}

@end

#pragma mark -

@implementation BibMarcMutableDataField

@dynamic tag;
+ (BOOL)automaticallyNotifiesObserversOfTag { return NO; }
- (void)setTag:(BibMarcTag *)tag {
    if (_tag == tag) {
        return;
    }
    [self willChangeValueForKey:kTagKey];
    _tag = tag;
    [self didChangeValueForKey:kTagKey];
}

@dynamic firstIndicator;
+ (BOOL)automaticallyNotifiesObserversOfFirstIndicator { return NO; }
- (void)setFirstIndicator:(BibMarcIndicator *)firstIndicator {
    if (_firstIndicator == firstIndicator) {
        return;
    }
    [self willChangeValueForKey:kFirstIndicatorKey];
    _firstIndicator = firstIndicator;
    [self didChangeValueForKey:kFirstIndicatorKey];
}

@dynamic secondIndicator;
+ (BOOL)automaticallyNotifiesObserversOfSecondIndicator { return NO; }
- (void)setSecondIndicator:(BibMarcIndicator *)secondIndicator {
    if (_secondIndicator == secondIndicator) {
        return;
    }
    [self willChangeValueForKey:kSecondIndicatorKey];
    _secondIndicator = secondIndicator;
    [self didChangeValueForKey:kSecondIndicatorKey];
}

@dynamic subfields;
+ (BOOL)automaticallyNotifiesObserversOfSubfields { return NO; }
- (void)setSubfields:(NSArray<BibMarcSubfield *> *)subfields {
    if (_subfields == subfields) {
        return;
    }
    [self willChangeValueForKey:kSubfieldsKey];
    _subfields = [[NSArray alloc] initWithArray:subfields copyItems:YES];
    [self didChangeValueForKey:kSubfieldsKey];
}

@end
