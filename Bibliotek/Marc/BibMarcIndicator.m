//
//  BibMarcIndicator.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordError.h"
#import "BibMarcIndicator.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import <os/log.h>

#define guard(predicate) if (!((predicate)))

@implementation BibMarcIndicator {
@protected
    NSString *_stringValue;
}

- (BOOL)isBlank {
    return [[NSCharacterSet bib_blankIndicatorCharacterSet] characterIsMember:[_stringValue characterAtIndex:0]];
}

- (instancetype)init {
    return [self initWithString:@" "];
}

- (instancetype)initWithString:(NSString *)stringValue {
    return [self initWithString:stringValue error:NULL];
}

- (instancetype)initWithString:(NSString *)stringValue {
    if (self = [super init]) {
        guard([stringValue length] == 1) {
            return nil;
        }
        unichar const code = [stringValue characterAtIndex:0];
        guard([[NSCharacterSet bib_blankIndicatorCharacterSet] characterIsMember:code]
              || [[NSCharacterSet bib_lowercaseAlphanumericCharacterSet] characterIsMember:code]) {
            return nil;
        }
        _stringValue = [stringValue copy];
    }
    return self;
}

+ (instancetype)indicatorWithString:(NSString *)stringValue {
    return [self indicatorWithString:stringValue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObject]];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

- (BOOL)isEqualToIndicator:(BibMarcIndicator *)indicator {
    return [_stringValue isEqualToString:[indicator stringValue]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcIndicator class]] && [self isEqualToIndicator:other]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

- (NSComparisonResult)compare:(BibMarcIndicator *)indicator {
    if ([self isEqualToIndicator:indicator]) {
        return NSOrderedSame;
    }
    NSString *const otherStringValue = [indicator stringValue];
    BOOL const valueIsBlank = [_stringValue isEqualToString:@" "];
    BOOL const otherValueIsBlank = [otherStringValue isEqualToString:@" "];
    if (valueIsBlank && otherValueIsBlank) {
        return NSOrderedSame;
    } else if (valueIsBlank) {
        return NSOrderedAscending;
    } else if (otherValueIsBlank) {
        return NSOrderedDescending;
    }
    NSCharacterSet *const numericCharacterSet = [NSCharacterSet bib_ASCIIAlphanumericCharacterSet];
    BOOL const valueIsDigit = [numericCharacterSet characterIsMember:[_stringValue characterAtIndex:0]];
    BOOL const otherValueIsDigit = [numericCharacterSet characterIsMember:[otherStringValue characterAtIndex:0]];
    if (valueIsDigit == otherValueIsDigit) {
        NSLocale *const posix = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        return [_stringValue compare:otherStringValue options:0 range:NSMakeRange(0, 1) locale:posix];
    } else if (otherValueIsDigit) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

@end
