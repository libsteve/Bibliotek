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

#define guard(predicate) if(!((predicate)))

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
    BibDecoder *const codeDecoder = [[BibJsonDecoder alloc] initWithKeyPath:[decoder keyPath]
                                                        jsonRepresentation:[keys firstObject]];
    BibMarcSubfieldCode *const code = [[BibMarcSubfieldCode alloc] initWithDecoder:codeDecoder error:error];
    guard (code) { return nil; }
    NSString *const content = [[decoder keyedValueContainer:error] decodeStringForKey:[keys firstObject] error:error];
    guard (content) { return nil; }
    return [self initWithCode:code content:content];
}

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
