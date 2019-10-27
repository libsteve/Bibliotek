//
//  BibSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibSubfield.h"
#import "BibHasher.h"

@implementation BibSubfield {
@protected
    BibSubfieldCode _code;
    NSString *_content;
}

@synthesize code = _code;
@synthesize content = _content;

- (instancetype)initWithCode:(BibSubfieldCode)code content:(NSString *)content {
    if (self = [super init]) {
        _code = [code copy];
        _content = [content copy];
    }
    return self;
}

- (instancetype)init {
    return [self initWithCode:@"a" content:@""];
}

- (NSString *)description {
    return [self content];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"$%@%@", [self code], [self content]];
}

@end

#pragma mark - Copying

@implementation BibSubfield (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableSubfield allocWithZone:zone] initWithCode:[self code] content:[self content]];
}

@end

#pragma mark - Equality

@implementation BibSubfield (Equality)

- (BOOL)isEqualToSubfield:(BibSubfield *)subfield {
    return [self code] == [subfield code] && [[self content] isEqualToString:[subfield content]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibSubfield class]] && [self isEqualToSubfield:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self code]];
    [hasher combineWithObject:[self content]];
    return [hasher hash];
}

@end

#pragma mark - Mutable

@implementation BibMutableSubfield

- (id)copyWithZone:(NSZone *)zone {
    return [[BibSubfield allocWithZone:zone] initWithCode:[self code] content:[self content]];
}

@dynamic code;
- (void)setCode:(BibSubfieldCode)code {
    if (_code != code) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(code))];
        _code = [code copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(code))];
    }
}

@dynamic content;
- (void)setContent:(NSString *)content {
    if (_content != content) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(content))];
        _content = [content copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(content))];
    }
}

@end

#pragma mark - Enumerator

@implementation BibSubfieldEnumerator {
    NSEnumerator<BibSubfield *> *_enumerator;
}

- (instancetype)initWithEnumerator:(NSEnumerator *)enumerator {
    if (self = [super init]) {
        _enumerator = enumerator;
    }
    return self;
}

- (instancetype)init {
    return [self initWithEnumerator:[NSEnumerator new]];
}

- (id)nextObject {
    return [_enumerator nextObject];
}

- (BibSubfield *)nextSubfield {
    return [self nextObject];
}

- (BibSubfield *)nextSubfieldWithCode:(BibSubfieldCode)subfieldCode {
    for (BibSubfield *subfield = [self nextSubfield]; subfield != nil; subfield = [self nextSubfield]) {
        if ([[subfield code] isEqualToString:subfieldCode]) {
            return subfield;
        }
    }
    return nil;
}

@end
