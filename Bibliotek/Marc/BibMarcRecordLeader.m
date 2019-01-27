//
//  BibMarcRecordLeader.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordLeader.h"
#import "NSCharacterSet+BibLowercaseAlphanumericCharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"
#import <os/log.h>

#define guard(predicate) if(!((predicate)))

static NSRange const kRecordLengthRange = { .location = 0, .length = 5 };
static NSRange const kRecordStatusRange = { .location = 5, .length = 1 };
static NSRange const kRecordTypeRange = { .location = 6, .length = 1 };
static NSRange const kTwoCharacterField = { .location = 7, .length = 2 };
static NSRange const kCharacterCodingSchemeRange = { .location = 9, .length = 1 };
static NSRange const kIndicatorCountRange = { .location = 10, .length = 1 };
static NSRange const kSubfieldCodeLengthRange = { .location = 11, .length = 1 };
static NSRange const kDataBaseAddressRange = { .location = 12, .length = 5 };
static NSRange const kThreeCharacterField = { .location = 17, .length = 3 };
static NSRange const kEntryMapRange = { .location = 20, .length = 4 };

static NSString *const kMarc21IndicatorCount = @"2";
static NSString *const kMarc21SubfieldCodeLength = @"2";
static NSString *const kMarc21EntryMap = @"4500";

#pragma mark -

@implementation BibMarcRecordLeader {
@protected
    NSString *_stringValue;
}

- (instancetype)init {
    return [self initWithString:@"00000cw  a2200000   4500"];
}

- (instancetype)initWithString:(NSString *)stringValue {
    guard([[BibMarcRecordLeader class] isValidLeaderString:stringValue]) {
        return nil;
    }
    if (self = [super init]) {
        _stringValue = [stringValue copy];
    }
    return self;
}

+ (instancetype)leaderWithString:(NSString *)stringValue {
    return [[self alloc] initWithString:stringValue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObject]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Properties

@synthesize stringValue = _stringValue;

@dynamic recordLength;
- (NSInteger)recordLength {
    return [[_stringValue substringWithRange:kRecordLengthRange] integerValue];
}

@dynamic recordStatus;
- (NSString *)recordStatus {
    return [_stringValue substringWithRange:kRecordStatusRange];
}

@dynamic recordType;
- (NSString *)recordType {
    return [_stringValue substringWithRange:kRecordTypeRange];
}

@dynamic twoCharacterField;
- (NSString *)twoCharacterField {
    return [_stringValue substringWithRange:kTwoCharacterField];
}

@dynamic characterCodingScheme;
- (NSString *)characterCodingScheme {
    return [_stringValue substringWithRange:kRecordTypeRange];
}

@dynamic indicatorCount;
- (NSInteger)indicatorCount {
    return [[_stringValue substringWithRange:kIndicatorCountRange] integerValue];
}

@dynamic subfieldCodeLength;
- (NSInteger)subfieldCodeLength {
    return [[_stringValue substringWithRange:kSubfieldCodeLengthRange] integerValue];
}

@dynamic dataBaseAddress;
- (NSInteger)dataBaseAddress {
    return [[_stringValue substringWithRange:kDataBaseAddressRange] integerValue];
}

@dynamic threeCharacterField;
- (NSString *)threeCharacterField {
    return [_stringValue substringWithRange:kThreeCharacterField];
}

@dynamic entryMap;
- (NSString *)entryMap {
    return [_stringValue substringWithRange:kEntryMapRange];
}

#pragma mark -

+ (BOOL)isValidLeaderString:(NSString *)stringValue {
    static os_log_t log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = os_log_create("brun.steve.Bibliotek.BibMarcRecord", "Leader");
    });
    guard([stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                              inRange:kRecordLengthRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIGraphicCharacterSet]
                                                 inRange:kRecordStatusRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIGraphicCharacterSet]
                                                 inRange:kRecordTypeRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIGraphicCharacterSet]
                                                 inRange:kTwoCharacterField]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIGraphicCharacterSet]
                                                 inRange:kCharacterCodingSchemeRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                                 inRange:kIndicatorCountRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                                 inRange:kSubfieldCodeLengthRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                                 inRange:kDataBaseAddressRange]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIGraphicCharacterSet]
                                                 inRange:kThreeCharacterField]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                                 inRange:kEntryMapRange]) {
              os_log_debug(log, "Invalid MARC 21 Leader \"%{public}@\"", stringValue);
              return NO;
          }
    guard([[stringValue substringWithRange:kIndicatorCountRange] isEqualToString:kMarc21IndicatorCount]) {
        os_log_debug(log, "Invalid MARC 21 Leader: \"%{public}@\"", stringValue);
        os_log_info(log, "Indicator Count must be %{public}@", kMarc21IndicatorCount);
        return NO;
    }
    guard([[stringValue substringWithRange:kSubfieldCodeLengthRange] isEqualToString:kMarc21SubfieldCodeLength]) {
        os_log_debug(log, "Invalid MARC 21 Leader: \"%{public}@\"", stringValue);
        os_log_info(log, "Subfield Code Length must be %{public}@", kMarc21SubfieldCodeLength);
        return NO;
    }
    guard([[stringValue substringWithRange:kEntryMapRange] isEqualToString:kMarc21EntryMap]) {
        os_log_debug(log, "Invalid MARC 21 Leader: \"%{public}@\"", stringValue);
        os_log_info(log, "Entry Map must be %{public}@", kMarc21EntryMap);
        return NO;
    }
    return YES;
}

@end
