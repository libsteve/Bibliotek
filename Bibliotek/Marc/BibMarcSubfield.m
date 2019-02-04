//
//  BibMarcSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcSubfield.h"
#import "BibMarcSubfieldCode.h"

static NSString *const kCodeKey = @"code";
static NSString *const kContentKey = @"content";

@implementation BibMarcSubfield {
@protected
    BibMarcSubfieldCode *_code;
    NSString *_content;
}

@synthesize code = _code;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithCode:[BibMarcSubfieldCode new] content:@""];
}

- (instancetype)initWithCode:(BibMarcSubfieldCode *)code content:(NSString *)content {
    if (self = [super init]) {
        _code = [code copy];
        _content = [content copy] ?: @"";
    }
    return self;
}

+ (instancetype)subfieldWithCode:(BibMarcSubfieldCode *)code content:(NSString *)content {
    return [[self alloc] initWithCode:code content:content];
}

- (id)copyWithZone:(NSZone *)zone {
    if (zone == nil && [[self class] isEqualTo:[BibMarcSubfield class]]) {
        return self;
    }
    return [[BibMarcSubfield allocWithZone:zone] initWithCode:_code content:_content];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcMutableSubfield allocWithZone:zone] initWithCode:_code content:_content];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithCode:[aDecoder decodeObjectForKey:kCodeKey]
                      content:[aDecoder decodeObjectForKey:kContentKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_code forKey:kCodeKey];
    [aCoder encodeObject:_content forKey:kContentKey];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Equality

- (BOOL)isEqualToSubfield:(BibMarcSubfield *)other {
    return (_code == [other code] || [_code isEqualToSubfieldCode:[other code]])
        && (_content == [other content] || [_content isEqualToString:[other content]]);
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcSubfield class]] && [self isEqualToSubfield:other]);
}

- (NSUInteger)hash {
    return [_code hash] ^ [_content hash];
}

@end

#pragma mark -

@implementation BibMarcMutableSubfield

@dynamic code;
+ (BOOL)automaticallyNotifiesObserversOfCode { return NO; }
- (void)setCode:(BibMarcSubfieldCode *)code {
    if (_code == code) {
        return;
    }
    [self willChangeValueForKey:kCodeKey];
    _code = [code copy];
    [self didChangeValueForKey:kCodeKey];
}

@dynamic content;
+ (BOOL)automaticallyNotifiesObserversOfContent { return NO; }
- (void)setContent:(NSString *)content {
    if (_content == content) {
        return;
    }
    [self willChangeValueForKey:kContentKey];
    _content = [content copy];
    [self didChangeValueForKey:kContentKey];
}

@end
