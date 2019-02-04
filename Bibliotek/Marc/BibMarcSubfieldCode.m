//
//  BibMarcSubfieldCode.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcSubfieldCode.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"

#define guard(predicate) if(!((predicate)))

@implementation BibMarcSubfieldCode {
@protected
    NSString *_stringValue;
}

@synthesize stringValue = _stringValue;

- (instancetype)init {
    return [self initWithString:@"a"];
}

- (instancetype)initWithString:(NSString *)stringValue {
    guard([code length] == 1) {
        return nil;
    }
    guard([code bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIILowercaseAlphanumericCharacterSet]
                                       inRange:NSRangeFromString(code)]) {
        return nil;
    }
    if (self = [super init]) {
        _stringValue = [stringValue copy];
    }
    return self;
}

+ (instancetype)tagWithString:(NSString *)stringValue {
    return [self tagWithString:stringValue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObject]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToSubfieldCode:(BibMarcSubfieldCode *)subfieldCode {
    return [_stringValue isEqualToString:[subfieldCode stringValue]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
    || ([other isKindOfClass:[BibMarcSubfieldCode class]] && [self isEqualToSubfieldCode:other]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

- (NSString *)description {
    return _stringValue;
}

- (NSComparisonResult)compare:(BibMarcSubfieldCode *)subfieldCode {
    return [_stringValue compare:[subfieldCode stringValue]];
}

@end
