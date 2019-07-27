//
//  BibContentField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibContentField.h"
#import "BibSubfield.h"
#import "BibContentIndicators.h"
#import "BibFieldTag.h"

@implementation BibContentField {
@protected
    BibFieldTag *_tag;
    BibContentIndicators *_indicators;
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
                  indicators:[BibContentIndicators new]
                   subfields:[NSArray array]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@", [self tag], [self indicators], [[self subfields] componentsJoinedByString:@""]];
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
    return [[self indicators] hash] ^ [[self subfields] hash];
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
        [self willChangeValueForKey:NSStringFromSelector(@selector(tag))];
        _tag = tag;
        [self didChangeValueForKey:NSStringFromSelector(@selector(tag))];
    }
}

@synthesize indicators;
- (void)setIndicators:(BibContentIndicators *)indicators {
    if (_indicators != indicators) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(indicators))];
        _indicators = [indicators copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(indicators))];
    }
}

@synthesize subfields;
- (void)setSubfields:(NSArray<BibSubfield *> *)subfields {
    if (_subfields != subfields) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(subfields))];
        _subfields = [subfields copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(subfields))];
    }
}

@end
