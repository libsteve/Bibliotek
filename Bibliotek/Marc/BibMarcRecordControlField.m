//
//  BibMarcRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordControlField.h"

@implementation BibMarcRecordControlField {
@protected
    NSString *_tag;
    NSString *_content;
}

@synthesize tag = _tag;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithTag:@"000" content:@""];
}

- (instancetype)initWithTag:(NSString *)tag content:(NSString *)content {
    if (self = [super init]) {
        _tag = [_tag copy];
        _content = [_content copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTag:[aDecoder decodeObjectForKey:@"tag"] content:[aDecoder decodeObjectForKey:@"content"]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMarcRecordControlField allocWithZone:zone] initWithTag:_tag content:_content];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableControlField allocWithZone:zone] initWithTag:_tag content:_content];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:@"tag"];
    [aCoder encodeObject:_content forKey:@"content"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToControlField:(BibMarcRecordControlField *)other {
    return [_tag isEqualToString:[other tag]]
        && [_content isEqualToString:[other content]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordControlField class]] && [self isEqualToControlField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_content hash];
}

@end

@implementation BibMarcRecordMutableControlField

@dynamic tag;
- (void)setTag:(NSString *)tag {
    if (_tag == tag) {
        return;
    }
    [self willChangeValueForKey:@"tag"];
    _tag = [tag copy];
    [self didChangeValueForKey:@"tag"];
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
