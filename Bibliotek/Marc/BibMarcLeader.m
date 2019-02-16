//
//  BibMarcLeader.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcLeader.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"

#define guard(predicate) if(!((predicate)))

NSErrorDomain const BibMarcRecordLeaderErrorDomain = @"brun.steve.bibliotek.marc21.leader.error";

static NSRange const kRecordLengthRange = { .location = 0, .length = 5 };
static NSRange const kRecordStatusRange = { .location = 5, .length = 1 };
static NSRange const kRecordTypeRange = { .location = 6, .length = 1 };
static NSRange const kTwoCharacterField = { .location = 7, .length = 2 };
static NSRange const kCharacterCodingSchemeRange = { .location = 9, .length = 1 };
static NSRange const kIndicatorCountRange = { .location = 10, .length = 1 };
static NSRange const kSubfieldCodeLengthRange = { .location = 11, .length = 1 };
static NSRange const kBaseAddressOfData = { .location = 12, .length = 5 };
static NSRange const kThreeCharacterField = { .location = 17, .length = 3 };
static NSRange const kEntryMapRange = { .location = 20, .length = 4 };

static NSString *const kMarc21IndicatorCount = @"2";
static NSString *const kMarc21SubfieldCodeLength = @"2";
static NSString *const kMarc21EntryMap = @"4500";

#pragma mark -

@implementation BibMarcLeader {
@protected
    NSString *_stringValue;
}

- (instancetype)init {
    return [self initWithString:@"00000cw  a2200000   4500" error:NULL];
}

- (instancetype)initWithString:(NSString *)stringValue error:(NSError **)error {
    guard([[BibMarcLeader class] isValidLeaderString:stringValue error:error]) {
        return nil;
    }
    if (self = [super init]) {
        _stringValue = [stringValue copy];
    }
    return self;
}

+ (instancetype)leaderWithString:(NSString *)stringValue error:(NSError **)error {
    return [[self alloc] initWithString:stringValue error:error];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSError *error = nil;
    self = [self initWithString:[aDecoder decodeObjectForKey:@"stringValue"] error:&error];
    guard(error == nil) {
        [[[NSException alloc] initWithName:error.domain
                                    reason:error.localizedFailureReason ?: error.localizedDescription
                                  userInfo:error.userInfo] raise];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue forKey:@"stringValue"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithDecoder:(BibDecoder *)deocder error:(NSError *__autoreleasing *)error {
    NSString *const string = [[decoder singleValueContainer:error] decodeString:error];
    guard (string) { return nil; }
    return [self initWithString:string error:error];
}

#pragma mark - Equality

- (BOOL)isEqualToLeader:(BibMarcLeader *)leader {
    return [_stringValue isEqualToString:[leader stringValue]];
}

- (BOOL)isEqual:(id)object {
    return [super isEqual:object]
        || ([object isKindOfClass:[BibMarcLeader class]] && [self isEqualToLeader:object]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

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

@dynamic baseAddressOfData;
- (NSInteger)baseAddressOfData {
    return [[_stringValue substringWithRange:kBaseAddressOfData] integerValue];
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

+ (void)throwError:(NSError *__autoreleasing *)error
          withCode:(NSInteger)code
           message:(NSString *)message
            reason:(NSString *)reason {
    guard(error) { return; }
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setObject:message forKeyedSubscript:NSLocalizedDescriptionKey];
    [userInfo setObject:reason forKeyedSubscript:NSLocalizedFailureReasonErrorKey];
    *error = [NSError errorWithDomain:BibMarcRecordLeaderErrorDomain code:code userInfo:[userInfo copy]];
}

+ (BOOL)isValidLeaderString:(NSString *)stringValue error:(NSError *__autoreleasing *)error {
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
                                                 inRange:kBaseAddressOfData]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIGraphicCharacterSet]
                                                 inRange:kThreeCharacterField]
          && [stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                                 inRange:kEntryMapRange]) {
              [self throwError:error
                      withCode:-1
                       message:[NSString stringWithFormat:@"Invalid MARC 21 Leader: \"%@\"", stringValue]
                        reason:nil];
              return NO;
          }
    guard([[stringValue substringWithRange:kIndicatorCountRange] isEqualToString:kMarc21IndicatorCount]) {
        [self throwError:error
                withCode:1
                 message:[NSString stringWithFormat:@"Invalid MARC 21 Leader: \"%@\"", stringValue]
                  reason:[NSString stringWithFormat:@"MARC indicator count must be %@", kMarc21IndicatorCount]];
        return NO;
    }
    guard([[stringValue substringWithRange:kSubfieldCodeLengthRange] isEqualToString:kMarc21SubfieldCodeLength]) {
        [self throwError:error
                withCode:1
                 message:[NSString stringWithFormat:@"Invalid MARC 21 Leader: \"%@\"", stringValue]
                  reason:[NSString stringWithFormat:@"MARC subfield code length must be %@", kMarc21SubfieldCodeLength]];
        return NO;
    }
    guard([[stringValue substringWithRange:kEntryMapRange] isEqualToString:kMarc21EntryMap]) {
        [self throwError:error
                withCode:1
                 message:[NSString stringWithFormat:@"Invalid MARC 21 Leader: \"%@\"", stringValue]
                  reason:[NSString stringWithFormat:@"MARC entry map must be %@", kMarc21EntryMap]];
        return NO;
    }
    return YES;
}

@end
