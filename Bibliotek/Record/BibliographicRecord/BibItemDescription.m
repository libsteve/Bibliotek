//
//  BibItemDescription.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibItemDescription.h"

@implementation BibItemDescription {
@protected
    BibItemDescriptionKind _kind;
    NSString *_content;
    NSString *_detail;
    NSString *_source;
    NSArray *_urls;
}

@synthesize kind = _kind;
@synthesize content = _content;
@synthesize detail = _detail;
@synthesize source = _source;
@synthesize urls = _urls;

- (instancetype)initWithKind:(BibItemDescriptionKind)kind
                     content:(NSString *)content
                      detail:(nullable NSString *)detail
                      source:(nullable NSString *)source
                        urls:(NSArray<NSURL *> *)urls {
    if (self = [super init]) {
        _kind = kind;
        _content = [content copy];
        _detail = [detail copy];
        _source = [source copy];
        _urls = [urls copy];
    }
    return self;
}

- (instancetype)initWithKind:(BibItemDescriptionKind)kind content:(NSString *)content {
    return [self initWithKind:kind content:content detail:nil source:nil urls:[NSArray array]];
}

- (instancetype)init {
    return nil;
}

+ (instancetype)new {
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableItemDescription alloc] initWithKind:[self kind]
                                                   content:[self content]
                                                    detail:[self detail]
                                                    source:[self source]
                                                      urls:[self urls]];
}

@end

@implementation BibItemDescription (Equality)

inline static BOOL sNullableStringsEqual(NSString *const first, NSString *const second) {
    return first == second
        || (first && second && [first isEqualToString:second]);
}

- (BOOL)isEqualToItemDescription:(BibItemDescription *)itemDescription {
    if (self == itemDescription) {
        return YES;
    }
    return [self kind] == [itemDescription kind]
        && [[self content] isEqualToString:[itemDescription content]]
        && sNullableStringsEqual([self detail], [itemDescription detail])
        && sNullableStringsEqual([self source], [itemDescription source])
        && [[self urls] isEqualToArray:[itemDescription urls]];
}

- (BOOL)isEqual:(id)object {
    return self == object;
}

inline static NSUInteger sRotateUnsignedInteger(NSUInteger const value, NSUInteger const rotation) {
    static NSUInteger const bitCount = CHAR_BIT * sizeof(NSUInteger);
    NSUInteger const amount = bitCount / rotation;
    return (value << amount) | (value >> (bitCount - amount));
}

- (NSUInteger)hash {
    return [self kind]
         ^ sRotateUnsignedInteger([[self content] hash], 2)
         ^ sRotateUnsignedInteger([[self detail] hash], 3)
         ^ sRotateUnsignedInteger([[self source] hash], 4)
         ^ sRotateUnsignedInteger([[self urls] hash], 5);
}

@end

#pragma mark - Mutable

@implementation BibMutableItemDescription

- (id)copyWithZone:(NSZone *)zone {
    return [[BibItemDescription alloc] initWithKind:[self kind]
                                            content:[self content]
                                             detail:[self detail]
                                             source:[self source]
                                               urls:[self urls]];
}

@dynamic kind;
- (void)setKind:(BibItemDescriptionKind)kind {
    _kind = kind;
}

@dynamic content;
- (void)setContent:(NSString *)content {
    if (_content != content) {
        _content = [content copy];
    }
}

@dynamic detail;
- (void)setDetail:(NSString *)detail {
    if (_detail != detail) {
        _detail = [detail copy];
    }
}

@dynamic source;
- (void)setSource:(NSString *)source {
    if (_source != source) {
        _source = [source copy];
    }
}

@dynamic urls;
- (void)setUrls:(NSArray<NSURL *> *)urls {
    if (_urls != urls) {
        _urls = [urls copy];
    }
}

@end
