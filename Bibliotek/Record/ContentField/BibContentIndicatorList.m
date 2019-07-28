//
//  BibContentIndicatorList.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibContentIndicatorList.h"

@implementation BibContentIndicatorList {
@protected
    BibContentIndicator *_indicators;
    NSUInteger _count;
}

@synthesize count = _count;

- (instancetype)initWithIndicators:(BibContentIndicator const *)indicators count:(NSUInteger)count {
    if (self = [super init]) {
        _indicators = calloc(count, sizeof(BibContentIndicator));
        memcpy(_indicators, indicators, count);
        _count = count;
    }
    return self;
}

- (instancetype)init {
    BibContentIndicator const empty[0];
    return [self initWithIndicators:empty count:0];
}

- (void)dealloc {
    free(_indicators);
}

- (BibContentIndicator)indicatorAtIndex:(NSUInteger)index {
    if (index >= _count) {
        [NSException raise:NSRangeException format:@"Index out of bounds."];
        return -1;
    }
    return _indicators[index];
}

- (NSString *)description {
    uint8_t *const buffer = (uint8_t *)_indicators;
    CFStringRef string = CFStringCreateWithBytes(kCFAllocatorDefault, buffer, _count, kCFStringEncodingASCII, false);
    return CFBridgingRelease(string);
}

@end

#pragma mark - Copying

@implementation BibContentIndicatorList (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableContentIndicatorList allocWithZone:zone] initWithIndicators:_indicators count:_count];
}

@end

#pragma mark - Equality

@implementation BibContentIndicatorList (Equality)

- (BOOL)isEqualToIndicators:(BibContentIndicatorList *)indicators {
    return _count == indicators->_count
        && 0 == memcmp(_indicators, indicators->_indicators, _count);
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibContentIndicatorList class]] && [self isEqualToIndicators:object]);
}

- (NSUInteger)hash {
    return [[self description] hash];
}

@end

#pragma mark - MARC 21

@implementation BibContentIndicatorList (MARC21)

- (BibContentIndicator)firstIndicator {
    return _indicators[0];
}

- (BibContentIndicator)secondIndicator {
    return _indicators[1];
}

- (instancetype)initWithFirstIndicator:(BibContentIndicator)firstIndicator
                       secondIndicator:(BibContentIndicator)secondIndicator {
    BibContentIndicator indicators[2] = { firstIndicator, secondIndicator };
    return [self initWithIndicators:indicators count:2];
}

@end

#pragma mark - Mutable

@implementation BibMutableContentIndicatorList

- (id)copyWithZone:(NSZone *)zone {
    return [[BibContentIndicatorList allocWithZone:zone] initWithIndicators:_indicators count:_count];
}

- (void)setIndicator:(BibContentIndicator)indicator atIndex:(NSUInteger)index {
    _indicators[index] = indicator;
}

@end

#pragma mark - Mutable MARC 21

@implementation BibMutableContentIndicatorList (MARC21)

@dynamic firstIndicator;
- (void)setFirstIndicator:(BibContentIndicator)firstIndicator {
    _indicators[0] = firstIndicator;
}

@dynamic secondIndicator;
- (void)setSecondIndicator:(BibContentIndicator)secondIndicator {
    _indicators[1] = secondIndicator;
}

@end
