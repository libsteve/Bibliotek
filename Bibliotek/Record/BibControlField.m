//
//  BibControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibControlField.h"
#import "BibFieldTag.h"

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
    return [NSString stringWithFormat:@"%@ %@", [self tag], [self value]];
}

@end

#pragma mark -

@implementation BibControlField (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableControlField allocWithZone:zone] initWithTag:[self tag] value:[self value]];
}

@end

#pragma mark -

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
    return [[self tag] hash] ^ [[self value] hash];
}

@end

#pragma mark -

@implementation BibMutableControlField

- (id)copyWithZone:(NSZone *)zone {
    return [[BibControlField allocWithZone:zone] initWithTag:[self tag] value:[self value]];
}

@dynamic tag;
- (void)setTag:(BibFieldTag *)tag {
    if (_tag != tag) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(tag))];
        _tag = tag;
        [self didChangeValueForKey:NSStringFromSelector(@selector(tag))];
    }
}

@dynamic value;
- (void)setValue:(NSString *)value {
    if (_value != value) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(value))];
        _value = [value copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(value))];
    }
}

@end
