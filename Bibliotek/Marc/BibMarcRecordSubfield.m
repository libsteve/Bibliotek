//
//  BibMarcRecordSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordSubfield.h"

@implementation BibMarcRecordSubfield {
@protected
    NSString *_code;
    NSString *_content;
}

@synthesize code = _code;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithCode:@"" content:@""];
}

- (instancetype)initWithCode:(NSString *)code content:(NSString *)content {
    if (self = [super init]) {
        _code = [code copy];
        _content = [content copy];
    }
    return self;
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
- (void)setCode:(NSString *)code {
    if (_code == code) {
        return;
    }
    [self willChangeValueForKey:@"code"];
    _code = [code copy];
    [self didChangeValueForKey:@"code"];
}

@dynamic content;
- (void)setContent:(NSString *)content {
    if (_content == content) {
        return;
    }
    [self willChangeValueForKey:@"content"];
    _content = [content copy];
    [self didChangeValueForKey:@"content"];
}

@end
