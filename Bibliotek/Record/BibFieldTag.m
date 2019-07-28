//
//  BibFieldTag.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibFieldTag.h"

@implementation BibFieldTag

@synthesize stringValue = _stringValue;

static NSCache *sFlyweightCache;

+ (void)initialize {
    sFlyweightCache = [[NSCache alloc] init];
    [sFlyweightCache setName:@"BibFieldTagCache"];
}

- (instancetype)initWithString:(NSString *)stringValue {
    if ([stringValue length] != 3) {
        return nil;
    }
    BibFieldTag *const tag = [sFlyweightCache objectForKey:stringValue];
    if (tag) {
        return tag;
    }
    if (self = [super init]) {
        _stringValue = [stringValue copy];
        [sFlyweightCache setObject:self forKey:stringValue];
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
