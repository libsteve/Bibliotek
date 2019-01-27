//
//  BibMarcRecordSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordSubfield.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"

#define BIB_ASSERT_VALID_SUBFILED_CODE(CODE) do {                                                                    \
    NSAssert([(CODE) length] == 1, @"Invalid subfield code \"%@\": "                                                 \
             @"Subfield codes must be exactly one lowercase ASCII character", (CODE));                               \
    NSAssert([[NSCharacterSet bib_lowercaseAlphanumericCharacterSet] characterIsMember:[(CODE) characterAtIndex:0]], \
             @"Invalid subfield code \"%@\": Subfield codes must be a lowercase ASCII character", (CODE));           \
} while(0)

@implementation BibMarcRecordSubfield {
@protected
    NSString *_code;
    NSString *_content;
}

@synthesize code = _code;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithCode:@"a" content:@""];
}

- (instancetype)initWithCode:(NSString *)code content:(NSString *)content {
    if (self = [super init]) {
        BIB_ASSERT_VALID_SUBFILED_CODE(code);
        _code = [code copy];
        _content = [content copy] ?: @"";
    }
    return self;
}

+ (instancetype)subfieldWithCode:(NSString *)code content:(NSString *)content {
    return [[self alloc] initWithCode:code content:content];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithCode:[aDecoder decodeObjectForKey:@"code"]
                      content:[aDecoder decodeObjectForKey:@"content"]];
}

- (id)copyWithZone:(NSZone *)zone {
    if (zone == nil && [[self class] isEqualTo:[BibMarcRecordSubfield class]]) {
        return self;
    }
    return [[BibMarcRecordSubfield allocWithZone:zone] initWithCode:_code content:_content];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableSubfield allocWithZone:zone] initWithCode:_code content:_content];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_code forKey:@"code"];
    [aCoder encodeObject:_content forKey:@"content"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToSubfield:(BibMarcRecordSubfield *)other {
    return (_code == [other code] || [_code isEqualToString:[other code]])
        && (_content == [other content] || [_content isEqualToString:[other content]]);
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordSubfield class]] && [self isEqualToSubfield:other]);
}

- (NSUInteger)hash {
    return [_code hash] ^ [_content hash];
}

@end

@implementation BibMarcRecordMutableSubfield

@dynamic code;
+ (BOOL)automaticallyNotifiesObserversOfCode { return NO; }
- (void)setCode:(NSString *)code {
    if (_code == code) {
        return;
    }
    BIB_ASSERT_VALID_SUBFILED_CODE(code);
    [self willChangeValueForKey:@"code"];
    _code = [code copy];
    [self didChangeValueForKey:@"code"];
}

@dynamic content;
+ (BOOL)automaticallyNotifiesObserversOfContent { return NO; }
- (void)setContent:(NSString *)content {
    if (_content == content) {
        return;
    }
    [self willChangeValueForKey:@"content"];
    _content = [content copy];
    [self didChangeValueForKey:@"content"];
}

@end
