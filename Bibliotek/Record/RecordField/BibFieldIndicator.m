//
//  BibFieldIndicator.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/7/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibFieldIndicator.h"
#import "Bibliotek+Internal.h"
#import <objc/runtime.h>
#import <objc/message.h>

/// \note Although only a lowercase ASCII characters and ASCII digits are valid indicators, the MARC8 formatted 2014
///       Library of Congress Classification schedule at https://loc.gov/cds/products/MDSConnect-classification.html
///       contains an indicator value of \c ')' at offset \c 42507804 , so we should be gracefully handling this case
///       by assuming that any 8-byte value could be provided as a valid indicator. If the LoC's schedule has this
///       indicator value, it must be valid, right‽ ¯\_(ツ)_/¯
static size_t const BibIndicatorCount = 256;
static size_t BibIndicatorInstanceSize;
static void *BibIndicatorBuffer;

@interface _BibFieldIndicator : BibFieldIndicator
@end

__attribute__((always_inline))
static inline _BibFieldIndicator *BibIndicatorGetCachedInstance(char rawValue)  {
    return BibIndicatorBuffer + (((size_t)rawValue) * BibIndicatorInstanceSize);
}

@implementation BibFieldIndicator {
@protected
    char rawValue;
}

@synthesize rawValue = rawValue;

+ (BibFieldIndicator *)blank { return [BibFieldIndicator indicatorWithRawValue:' ']; }

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return (self == [BibFieldIndicator self]) ? BibIndicatorGetCachedInstance(' ') : [super allocWithZone:zone];
}

- (instancetype)initWithRawValue:(char)rawValue {
    if (self = [super init]) {
        self->rawValue = rawValue;
    }
    return self;
}

+ (instancetype)indicatorWithRawValue:(char)rawValue {
    if (self == [BibFieldIndicator self]) {
        return [_BibFieldIndicator indicatorWithRawValue:rawValue];
    } else {
        return [[[self alloc] initWithRawValue:rawValue] autorelease];
    }
}

- (instancetype)init {
    return [self initWithRawValue:' '];
}

- (id)copyWithZone:(NSZone *)zone { return self; }

+ (instancetype)objectAtIndexedSubscript:(char)rawValue {
    return [self indicatorWithRawValue:rawValue];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)coder {
    char const rawValue = (char)[coder decodeIntForKey:BibKey(rawValue)];
    return [self initWithRawValue:rawValue];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:(int)(self->rawValue) forKey:BibKey(rawValue)];
}

#pragma mark - Equality

- (BOOL)isEqualToIndicator:(BibFieldIndicator *)indicator {
    return self == indicator
        || (self->rawValue == indicator->rawValue);
}

- (BOOL)isEqual:(id)object {
    return (self == object)
        || ([object isKindOfClass:[BibFieldIndicator self]] && [self isEqual:object]);
}

- (NSUInteger)hash {
    return (NSUInteger)self->rawValue;
}

#pragma mark - Description

- (NSString *)description {
    return (self->rawValue == ' ') ? @"\u2422" : [NSString stringWithFormat:@"%c", self->rawValue];
}

#if DEBUG
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<BibFieldIndicator rawValue='%c', %#04X; '%@'>",
                                      self->rawValue, self->rawValue, [self description]];
}
#endif

@end

#pragma mark -

@implementation _BibFieldIndicator

+ (void)load {
    BibIndicatorInstanceSize = class_getInstanceSize(self);
    BibIndicatorBuffer = calloc(BibIndicatorCount, BibIndicatorInstanceSize);
    for (char rawValue = 0; rawValue < BibIndicatorCount; rawValue += 1) {
        BibFieldIndicator *indicator = BibIndicatorGetCachedInstance(rawValue);
        objc_constructInstance(self, indicator);
        struct objc_super _super = { indicator, [NSObject self] };
        ((id(*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(init));
        indicator->rawValue = rawValue;
    }
}

- (instancetype)initWithRawValue:(char)rawValue {
    self = BibIndicatorGetCachedInstance(rawValue);
    NSParameterAssert(self != nil);
    return self;
}

+ (instancetype)indicatorWithRawValue:(char)rawValue {
    _BibFieldIndicator *indicator = BibIndicatorGetCachedInstance(rawValue);
    NSParameterAssert(indicator != nil);
    return indicator;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {}
#pragma clang diagnostic pop

- (instancetype)retain { return self; }

- (oneway void)release {}

- (instancetype)autorelease { return self; }

- (NSUInteger)retainCount { return 1; }

@end
