//
//  BibMarcRecordFieldIndicator.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordFieldIndicator.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import <os/log.h>

#define GUARD(CONDITION) if (!(CONDITION))

@implementation BibMarcRecordFieldIndicator {
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
    static os_log_t log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = os_log_create("brun.steve.Bibliotek.BibMarcRecord", "FieldIndicator");
    });
    if (self = [super init]) {
        GUARD([stringValue length] == 1) {
            os_log_debug(log, "Invalid field indicator \"%{public}@\"", stringValue);
            os_log_info(log, "Field indicator codes must be exactly one lowercase alphanumeric or space character");
            return nil;
        }
        unichar const code = [stringValue characterAtIndex:0];
        GUARD([[NSCharacterSet bib_blankIndicatorCharacterSet] characterIsMember:code]
              || [[NSCharacterSet bib_lowercaseAlphanumericCharacterSet] characterIsMember:code]) {
            os_log_debug(log, "Invalid field indicator \"%{public}@\"", stringValue);
            os_log_info(log, "Field indicator codes must be exactly one lowercase alphanumeric or space character");
            return nil;
        }
        _stringValue = [stringValue copy];
    }
    return self;
}

+ (instancetype)fieldIndicatorWithString:(NSString *)stringValue {
    return [[self alloc] initWithString:stringValue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObject]];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

- (BOOL)isEqualToFieldIndicator:(BibMarcRecordFieldIndicator *)other {
    return [_stringValue isEqualToString:[other stringValue]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordFieldIndicator class]] && [self isEqualToFieldIndicator:other]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

- (NSComparisonResult)compare:(BibMarcRecordFieldIndicator *)fieldIndicator {
    if ([self isEqualToFieldIndicator:fieldIndicator]) {
        return NSOrderedSame;
    }
    NSString *const stringValue = _stringValue;
    NSString *const otherStringValue = [fieldIndicator stringValue];
    NSCharacterSet *const blankCharacterSet = [NSCharacterSet bib_blankIndicatorCharacterSet];
    BOOL const valueIsBlank = [blankCharacterSet characterIsMember:[stringValue characterAtIndex:0]];
    BOOL const otherValueIsBlank = [blankCharacterSet characterIsMember:[otherStringValue characterAtIndex:0]];
    if (valueIsBlank && otherValueIsBlank) {
        return NSOrderedSame;
    } else if (valueIsBlank) {
        return NSOrderedAscending;
    } else if (otherValueIsBlank) {
        return NSOrderedDescending;
    }
    NSCharacterSet *const numericCharacterSet = [NSCharacterSet bib_westernNumeralCharacterSet];
    BOOL const valueIsDigit = [numericCharacterSet characterIsMember:[stringValue characterAtIndex:0]];
    BOOL const otherValueIsDigit = [numericCharacterSet characterIsMember:[otherStringValue characterAtIndex:0]];
    if (valueIsDigit == otherValueIsDigit) {
        NSLocale *const posix = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        return [_stringValue compare:[fieldIndicator stringValue] options:0 range:NSMakeRange(0, 1) locale:posix];
    } else if (otherValueIsDigit) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

@end
