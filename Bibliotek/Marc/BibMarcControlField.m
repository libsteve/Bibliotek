//
//  BibMarcControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcControlField.h"
#import "BibMarcTag.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"

#define guard(predicate) if(!((predicate)))

static NSString *const kTagKey = @"tag";
static NSString *const kContentKey = @"content";

static BOOL sIsValidTag(NSString *tag);

@implementation BibMarcControlField {
@protected
    BibMarcTag *_tag;
    NSString *_content;
}

@synthesize tag = _tag;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithTag:[BibMarcTag controlNumberTag] content:@""];
}

- (instancetype)initWithTag:(BibMarcTag *)tag content:(NSString *)content {
    guard([tag isControlFieldTag]) {
        return nil;
    }
    if (self = [super init]) {
        _tag = [tag copy];
        _content = [_content copy];
    }
    return self;
}

+ (instancetype)controlFieldWithTag:(BibMarcTag *)tag content:(NSString *)content {
    return [[self alloc] initWithTag:tag content:content];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMarcControlField allocWithZone:zone] initWithTag:_tag content:_content];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcMutableControlField allocWithZone:zone] initWithTag:_tag content:_content];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTag:[aDecoder decodeObjectForKey:kTagKey]
                     content:[aDecoder decodeObjectForKey:kContentKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:kTagKey];
    [aCoder encodeObject:_content forKey:kContentKey];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithDecoder:(BibDecoder *)decoder error:(NSError *__autoreleasing *)error {
    guard ([[decoder mimeType] containsString:@"application/json"]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:@"brun.steve.bibliotek.marc-record.decoder" code:1 userInfo:nil];
        return nil;
    }
    NSDictionary *const dictionary = [[decoder singleValueContainer:error] decodeDictionary:error];
    guard (dictionary) { return nil; }
    NSArray *const keys = [dictionary allKeys];
    guard ([keys count] == 1) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidData
                                 userInfo:@{ BibDecoderErrorKeyPathKey : [decoder keyPath],
                                             BibDecoderErrorInvalidDataKey : dictionary,
                                             BibDecoderErrorExpectedClassKey : [self class] }];
        return nil;
    }
    BibDecoder *const tagDecoder = [[BibJsonDecoder alloc] initWithKeyPath:[decoder keyPath]
                                                        jsonRepresentation:[keys firstObject]];
    BibMarcTag *const tag = [[BibMarcTag alloc] initWithDecoder:tagDecoder error:error];
    guard (tag) { return nil; }
    NSString *const content = [[decoder keyedValueContainer:error] decodeStringForKey:[keys firstObject] error:error];
    guard (content) { return nil; }
    return [self initWithTag:tag content:content];
}

#pragma mark - Equality

- (BOOL)isEqualToControlField:(BibMarcControlField *)other {
    return [_tag isEqualToTag:[other tag]]
        && [_content isEqualToString:[other content]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcControlField class]] && [self isEqualToControlField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_content hash];
}

@end

#pragma mark -

@implementation BibMarcMutableControlField

@dynamic tag;
+ (BOOL)automaticallyNotifiesObserversOfTag { return NO; }
- (void)setTag:(BibMarcTag *)tag {
    if (_tag == tag) {
        return;
    }
    guard ([tag isControlFieldTag]) {
        return;
    }
    [self willChangeValueForKey:kTagKey];
    _tag = tag;
    [self didChangeValueForKey:kTagKey];
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
