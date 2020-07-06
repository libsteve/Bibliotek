//
//  BibFieldPath.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/10/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibFieldPath.h"
#import "BibFieldTag.h"
#import "BibHasher.h"

@implementation BibFieldPath

@synthesize fieldTag = _fieldTag;
@synthesize subfieldCode = _subfieldCode;

- (instancetype)init {
    return [self initWithFieldTag:[BibFieldTag new]];
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag {
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        _subfieldCode = nil;
    }
    return self;
}

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode {
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        _subfieldCode = [fieldTag isControlTag] ? nil : [subfieldCode copy];
    }
    return self;
}

- (BOOL)isSubfieldPath {
    return [[self fieldTag] isDataTag] && ([self subfieldCode] != nil);
}

- (BOOL)isDataFieldPath {
    return [[self fieldTag] isDataTag] && ([self subfieldCode] == nil);
}

- (BOOL)isContentFieldPath {
    return [self isDataFieldPath];
}

- (BOOL)isControlFieldPath {
    return [[self fieldTag] isControlTag];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

@implementation BibFieldPath (Convenience)

- (instancetype)initWithFieldTagString:(NSString *)fieldTagString {
    return [self initWithFieldTag:[[BibFieldTag alloc] initWithString:fieldTagString]];
}

- (instancetype)initWithFieldTagString:(NSString *)fieldTagString subfieldCode:(BibSubfieldCode)subfieldCode {
    return [self initWithFieldTag:[[BibFieldTag alloc] initWithString:fieldTagString] subfieldCode:subfieldCode];
}

+ (instancetype)fieldPathWithFieldTag:(BibFieldTag *)fieldTag {
    return [[BibFieldPath alloc] initWithFieldTag:fieldTag];
}

+ (instancetype)fieldPathWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode {
    return [[BibFieldPath alloc] initWithFieldTag:fieldTag subfieldCode:subfieldCode];
}

+ (instancetype)fieldPathWithFieldTagString:(NSString *)fieldTagString {
    return [[BibFieldPath alloc] initWithFieldTagString:fieldTagString];
}

+ (instancetype)fieldPathWithFieldTagString:(NSString *)fieldTagString subfieldCode:(BibSubfieldCode)subfieldCode {
    return [[BibFieldPath alloc] initWithFieldTagString:fieldTagString subfieldCode:subfieldCode];
}

@end

@implementation BibFieldPath (Equality)

- (NSUInteger)hash {
    BibHasher *const hasher = [BibHasher new];
    [hasher combineWithObject:[self fieldTag]];
    [hasher combineWithObject:[self subfieldCode]];
    return [hasher hash];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibFieldPath self]] && [self isEqualToFieldPath:object]);
}

- (BOOL)isEqualToFieldPath:(BibFieldPath *)fieldPath {
    return fieldPath != nil
        && [[self fieldTag] isEqualToTag:[fieldPath fieldTag]]
        && [self isSubfieldPath] == [fieldPath isSubfieldPath]
        && (![self isSubfieldPath] || [[self subfieldCode] isEqualToString:[fieldPath subfieldCode]]);
}

@end
