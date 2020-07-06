//
//  BibFieldTag.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibFieldTag.h"

@interface _BibFieldTag : BibFieldTag
@end

@implementation BibFieldTag

@synthesize stringValue = _stringValue;
@synthesize isControlTag = _isControlTag;
@synthesize isDataTag = _isDataTag;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self isEqualTo:[BibFieldTag class]]
         ? [_BibFieldTag allocWithZone:zone]
         : [super allocWithZone:zone];
}

- (instancetype)initWithString:(NSString *)stringValue {
    if ([stringValue length] != 3) {
        return nil;
    }
    if (self = [super init]) {
        _stringValue = [stringValue copy];
        _isControlTag = [stringValue hasPrefix:@"00"];
        _isDataTag = !_isControlTag && ![stringValue isEqualToString:@"000"];
    }
    return self;
}

+ (instancetype)fieldTagWithString:(NSString *)stringValue {
    return [[_BibFieldTag alloc] initWithString:stringValue];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
}

- (instancetype)init {
    return [self initWithString:@"000"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithData:[coder decodeDataObject]];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeDataObject:[[self stringValue] dataUsingEncoding:NSASCIIStringEncoding]];
}

- (NSString *)description {
    return [self stringValue];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

#pragma mark - Equality

@implementation BibFieldTag (Equality)

- (BOOL)isEqualToTag:(BibFieldTag *)fieldTag {
    return [[self stringValue] isEqualToString:[fieldTag stringValue]];
}

- (BOOL)isEqualToString:(NSString *)stringValue {
    return [[self stringValue] isEqualToString:stringValue];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibFieldTag class]] && [self isEqualToTag:object])
        || ([object isKindOfClass:[NSString class]] && [self isEqualToString:object]);
}

- (NSUInteger)hash {
    return [[self stringValue] hash];
}

@end

#pragma mark -

@implementation _BibFieldTag

static NSCache *sFlyweightCache;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFlyweightCache = [[NSCache alloc] init];
        [sFlyweightCache setName:@"_BibFieldTagCache"];
    });
}

- (instancetype)initWithString:(NSString *)stringValue {
    _BibFieldTag *const tag = [sFlyweightCache objectForKey:stringValue];
    if (tag) {
        return tag;
    }
    if (self = [super initWithString:stringValue]) {
        [sFlyweightCache setObject:self forKey:stringValue];
    }
    return self;
}

@end
