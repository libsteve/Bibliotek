//
//  BibMarcRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordControlField.h"
#import "BibMarcRecordFieldTag.h"

@implementation BibMarcRecordControlField {
@protected
    BibMarcRecordFieldTag *_tag;
    NSString *_content;
}

@synthesize tag = _tag;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithTag:[BibMarcRecordFieldTag new] content:@""];
}

- (instancetype)initWithTag:(BibMarcRecordFieldTag *)tag content:(NSString *)content {
    if (self = [super init]) {
        _tag = tag;
        _content = [_content copy];
    }
    return self;
}

+ (instancetype)controlFieldWithTag:(BibMarcRecordFieldTag *)tag content:(NSString *)content {
    return [[self alloc] initWithTag:tag content:content];
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
    return [_tag isEqualToFieldTag:[other tag]]
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
+ (BOOL)automaticallyNotifiesObserversOfTag { return NO; }
- (void)setTag:(BibMarcRecordFieldTag *)tag {
    if (_tag == tag) {
        return;
    }
    [self willChangeValueForKey:@"tag"];
    _tag = tag;
    [self didChangeValueForKey:@"tag"];
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
