//
//  BibSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibSubfield.h"
#import "BibHasher.h"

#import "Bibliotek+Internal.h"

@implementation BibSubfield {
@protected
    BibSubfieldCode _subfieldCode;
    NSString *_content;
}

@synthesize subfieldCode = _subfieldCode;
@synthesize content = _content;

- (instancetype)initWithCode:(BibSubfieldCode)code content:(NSString *)content {
    if (self = [super init]) {
        _subfieldCode = [code copy];
        _content = [content copy];
    }
    return self;
}

- (instancetype)init {
    return [self initWithCode:@"a" content:@""];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\u2021%@%@", [self subfieldCode], [self content]];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:BibKey(subfieldCode), BibKey(content), nil];
}

@end

#pragma mark - Copying

@implementation BibSubfield (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableSubfield allocWithZone:zone] initWithCode:[self subfieldCode] content:[self content]];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)coder {
    BibSubfieldCode const code = [coder decodeObjectOfClass:[NSString self] forKey:BibKey(code)];
    NSString *const content = [coder decodeObjectOfClass:[NSString self] forKey:BibKey(content)];
    return [self initWithCode:code content:content];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self subfieldCode] forKey:BibKey(code)];
    [coder encodeObject:[self content] forKey:BibKey(content)];
}

@end

#pragma mark - Equality

@implementation BibSubfield (Equality)

- (BOOL)isEqualToSubfield:(BibSubfield *)subfield {
    return [[self subfieldCode] isEqualToString:[subfield subfieldCode]]
        && [[self content] isEqualToString:[subfield content]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibSubfield class]] && [self isEqualToSubfield:object]);
}

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self subfieldCode]];
    [hasher combineWithObject:[self content]];
    return [hasher hash];
}

@end

#pragma mark - Mutable

@implementation BibMutableSubfield

- (id)copyWithZone:(NSZone *)zone {
    return [[BibSubfield allocWithZone:zone] initWithCode:[self subfieldCode] content:[self content]];
}

@dynamic subfieldCode;
- (void)setSubfieldCode:(BibSubfieldCode)subfieldCode {
    if (_subfieldCode != subfieldCode) {
        _subfieldCode = [subfieldCode copy];
    }
}

@dynamic content;
- (void)setContent:(NSString *)content {
    if (_content != content) {
        _content = [content copy];
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
        if ([[subfield subfieldCode] isEqualToString:subfieldCode]) {
            return subfield;
        }
    }
    return nil;
}

@end
