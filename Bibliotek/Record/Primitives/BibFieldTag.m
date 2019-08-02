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
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
}

- (instancetype)init {
    return [self initWithString:@"000"];
}

- (NSString *)description {
    return [self stringValue];
}

- (BOOL)isControlFieldTag {
    return [[self stringValue] hasPrefix:@"00"];
}

@end

#pragma mark - Equality

@implementation BibFieldTag (Equality)

- (BOOL)isEqualToTag:(BibFieldTag *)fieldTag {
    return [[self stringValue] isEqualToString:[fieldTag stringValue]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibFieldTag class]] && [self isEqualToTag:object]);
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
