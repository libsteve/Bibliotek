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

static size_t const BibIndicatorCount = 128;
static size_t BibIndicatorInstanceSize;
static void *BibIndicatorBuffer;

/// An underlying backing type for immutable singleton instances of ``BibFieldIndicator`` for each value.
///
/// An instance for each of the 128 possible ASCII values is allocated at load time.
/// When ``BibFieldIndicator/initWithRawValue`` is called, one of those pre-allocated instances is returned.
@interface _BibFieldIndicator : BibFieldIndicator
@end

NS_INLINE _BibFieldIndicator *BibIndicatorGetCachedInstance(char rawValue)  {
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
    char rawValue = ' ';
    [coder decodeValueOfObjCType:@encode(char) at:&rawValue];
    return [self initWithRawValue:rawValue];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeValueOfObjCType:@encode(char) at:&(self->rawValue)];
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
    for (size_t index = 0; index < BibIndicatorCount; index += 1) {
        char const rawValue = (char)index;
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
