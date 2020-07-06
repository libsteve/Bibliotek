//
//  BibControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibControlField.h"
#import "BibFieldTag.h"
#import "BibHasher.h"

#import "Bibliotek+Internal.h"

#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation BibControlField {
@protected
    BibFieldTag *_tag;
    NSString *_value;
}

@synthesize tag = _tag;
@synthesize value = _value;

- (instancetype)initWithTag:(BibFieldTag *)tag value:(NSString *)value {
    if (self = [super init]) {
        _tag = tag;
        _value = [value copy];
    }
    return self;
}

- (instancetype)init {
    return [self initWithTag:[BibFieldTag new] value:@""];
}

+ (instancetype)controlFieldWithTag:(BibFieldTag *)tag value:(NSString *)value {
    return [[self alloc] initWithTag:tag value:value];
}

- (NSString *)description {
    return [self value];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObject:BibKey(value)];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ %@", [self tag], [self value]];
}

+ (NSSet *)keyPathsForValuesAffectingDebugDescription {
    return [NSSet setWithObjects:BibKey(tag), BibKey(value), nil];
}

@end

#pragma mark - Copying

@implementation BibControlField (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableControlField allocWithZone:zone] initWithTag:[self tag] value:[self value]];
}

@end

#pragma mark - Equality

@implementation BibControlField (Equality)

- (BOOL)isEqualToControlField:(BibControlField *)controlField {
    return [[self tag] isEqualToTag:[controlField tag]]
        && [[self value] isEqualToString:[controlField value]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibControlField class]] && [self isEqualToControlField:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self tag]];
    [hasher combineWithObject:[self value]];
    return [hasher hash];
}

@end

#pragma mark - Mutable

@implementation BibMutableControlField

- (id)copyWithZone:(NSZone *)zone {
    return [[BibControlField allocWithZone:zone] initWithTag:[self tag] value:[self value]];
}

@dynamic tag;
- (void)setTag:(BibFieldTag *)tag {
    if (_tag != tag) {
        _tag = tag;
    }
}

@dynamic value;
- (void)setValue:(NSString *)value {
    if (_value != value) {
        _value = [value copy];
    }
}

@end
