//
//  BibContentDescription.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibContentDescription.h"

@implementation BibContentDescription {
@protected
    BibContentDescriptionKind _kind;
    BibContentDescriptionLevel _level;
    NSString *_note;
    NSArray *_urls;
    NSArray *_contents;
}

@synthesize kind = _kind;
@synthesize level = _level;
@synthesize note = _note;
@synthesize urls = _urls;
@synthesize contents = _contents;

- (instancetype)initWithKind:(BibContentDescriptionKind)kind
                       level:(BibContentDescriptionLevel)level
                        note:(NSString *)note
                        urls:(NSArray<NSString *> *)urls
                    contents:(NSArray<NSString *> *)contents {
    if (self = [super init]) {
        _kind = kind;
        _level = level;
        _note = [note copy];
        _urls = [urls copy];
        _contents = [contents copy];
    }
    return self;
}

- (instancetype)init {
    return [self initWithKind:BibContentDescriptionKindOther
                        level:BibContentDescriptionLevelBasic
                         note:@"" urls:@[] contents:@[]];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableContentDescription allocWithZone:zone] initWithKind:[self kind]
                                                                     level:[self level]
                                                                      note:[self note]
                                                                      urls:[self urls]
                                                                  contents:[self contents]];
}

@end

@implementation BibContentDescription (Equality)

- (BOOL)isEqualToContentDescription:(BibContentDescription *)contentDescription {
    if (self == contentDescription) {
        return YES;
    }
    return [self kind] == [contentDescription kind]
        && [self level] == [contentDescription level]
        && [[self note] isEqualToString:[contentDescription note]]
        && [[self urls] isEqualToArray:[contentDescription urls]]
        && [[self contents] isEqualToArray:[contentDescription contents]];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibContentDescription class]] && [self isEqualToContentDescription:object]);
}


inline static NSUInteger sRotateUnsignedInteger(NSUInteger const value, NSUInteger const rotation) {
    static NSUInteger const bitCount = CHAR_BIT * sizeof(NSUInteger);
    NSUInteger const amount = bitCount / rotation;
    return (value << amount) | (value >> (bitCount - amount));
}

- (NSUInteger)hash {
    return [self kind]
         ^ sRotateUnsignedInteger([self level], 2)
         ^ sRotateUnsignedInteger([[self note] hash], 3)
         ^ sRotateUnsignedInteger([[self urls] hash], 4)
         ^ sRotateUnsignedInteger([[self contents] hash], 5);
}

@end

#pragma mark - Mutable

@implementation BibMutableContentDescription

- (id)copyWithZone:(NSZone *)zone {
    return [[BibContentDescription allocWithZone:zone] initWithKind:[self kind]
                                                              level:[self level]
                                                               note:[self note]
                                                               urls:[self urls]
                                                           contents:[self contents]];
}

@dynamic kind;
- (void)setKind:(BibContentDescriptionKind)kind {
    [self willChangeValueForKey:NSStringFromSelector(@selector(kind))];
    _kind = kind;
    [self didChangeValueForKey:NSStringFromSelector(@selector(kind))];
}

@dynamic level;
- (void)setLevel:(BibContentDescriptionLevel)level {
    [self willChangeValueForKey:NSStringFromSelector(@selector(level))];
    _level = level;
    [self didChangeValueForKey:NSStringFromSelector(@selector(level))];
}

@dynamic note;
- (void)setNote:(NSString *)note {
    if (_note != note) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(note))];
        _note = [note copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(note))];
    }
}

@dynamic urls;
- (void)setUrls:(NSArray<NSURL *> *)urls {
    if (_urls != urls) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(urls))];
        _urls = [urls copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(urls))];
    }
}

@dynamic contents;
- (void)setContents:(NSArray<NSString *> *)contents {
    if (_contents != contents) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(contents))];
        _contents = [contents copy];
        [self didChangeValueForKey:NSStringFromSelector(@selector(contents))];
    }
}

@end
