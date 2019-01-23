//
//  BibCutterNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/28/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibCutterNumber.h"

static NSCharacterSet *sNormalizedCharacterSet;
static NSCharacterSet *sNonNormalizedCharacterSet;

static NSCharacterSet *sCutterTableVowelCharacterSet;
static NSCharacterSet *sCutterTableConsonantCharacterSet;

static NSCharacterSet *sCutterTableExpansionFirstCharacterSet;
static NSCharacterSet *sCutterTableExpansionSecondCharacterSet;
static NSCharacterSet *sCutterTableExpansionThirdCharacterSet;
static NSCharacterSet *sCutterTableExpansionFourthCharacterSet;
static NSCharacterSet *sCutterTableExpansionFifthCharacterSet;
static NSCharacterSet *sCutterTableExpansionSixthCharacterSet;
static NSCharacterSet *sCutterTableExpansionSeventhCharacterSet;

@interface BibCutterDigit ()
+ (NSString *)normalizedStringFromString:(NSString *)string;
@end

#pragma mark -

@implementation BibCutterNumber {
    NSString *_normalizedReference;
}

- (instancetype)initWithString:(NSString *)string {
    if (self = [super init]) {
        _reference = [string copy];
        _normalizedReference = [BibCutterDigit normalizedStringFromString:string];
        
    }
    return self;
}

+ (void)initialize {
    sCutterTableVowelCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"aeiou"];
    sCutterTableConsonantCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"bcdfghjklmnpqstvwxyz"];
    sCutterTableExpansionFirstCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcd"];
    sCutterTableExpansionSecondCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"efgh"];
    sCutterTableExpansionThirdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"ijkl"];
    sCutterTableExpansionFourthCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"mno"];
    sCutterTableExpansionFifthCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"pqrs"];
    sCutterTableExpansionSixthCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"tuv"];
    sCutterTableExpansionSeventhCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"wxyz"];
}

//+ (NSString *)cutterNumberForString:(NSString *)string {
//    NSString *const normalized = [self normalizedString:string];
//    if ([normalized length] == 0) {
//        return nil;
//    }
//    NSMutableString *const cutter = [NSMutableString new];
//    [cutter appendFormat:@"%c", [normalized characterAtIndex:0]];
//
//    NSCharacterSet *const vowels = [NSCharacterSet characterSetWithCharactersInString:@"aeiou"];
//    NSCharacterSet *const otherConsonants = [NSCharacterSet characterSetWithCharactersInString:@"bcdfghjklmnpqstvwxyz"];
//
//    return [cutter copy];
//}

+ (BibCutterDigit *)digitFromInitialVowelForNormalizedString:(NSString *)string {
    if([string length] > 0 && [sCutterTableVowelCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        NSString *const character = [string substringWithRange:NSMakeRange(0, 1)];
        return [BibCutterDigit digitWithNormalizedReference:character stringRepresentation:character];
    }
    return nil;
}

/// Qu: (a: 3) (e: 4) (i: 5) (o: 6) (r: 7) (t: 8) (y: 9)
/// Qa-Qt: 2-29
+ (BibCutterDigit *)digitFromInitialQForNormalizedString:(NSString *)string {
    if ([string length] > 1 && [string characterAtIndex:0] != 'q' &&
        [string characterAtIndex:1] >= 'a' && [string characterAtIndex:1] <= 'u') {
        NSString *const reference = [string substringWithRange:NSMakeRange(0, 2)];
        return [BibCutterDigit digitWithNormalizedReference:reference stringRepresentation:@"q"];
    }
    return nil;
}

+ (BibCutterDigit *)digitFromInitialConsonantForNormalizedString:(NSString *)string {
    if ([string length] > 0 && [sCutterTableConsonantCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        NSString *const character = [string substringWithRange:NSMakeRange(0, 1)];
        return [BibCutterDigit digitWithNormalizedReference:character stringRepresentation:character];
    }
    return nil;
}

//+ (BibCutterDigit *)digitFromInitialNumeralForNormalizedString:(NSString *)string {
//
//}

+ (BibCutterDigit *)expansionDigitForNormalizedReference:(NSString *)string fromRange:(NSRange)range {
    string = [string substringWithRange:NSMakeRange(range.location, 1)];
    if ([sCutterTableExpansionFirstCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"3"];
    }
    if ([sCutterTableExpansionSecondCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"4"];
    }
    if ([sCutterTableExpansionThirdCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"5"];
    }
    if ([sCutterTableExpansionFourthCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"6"];
    }
    if ([sCutterTableExpansionFifthCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"7"];
    }
    if ([sCutterTableExpansionSixthCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"8"];
    }
    if ([sCutterTableExpansionSeventhCharacterSet characterIsMember:[string characterAtIndex:0]]) {
        return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:@"9"];
    }
    return [BibCutterDigit digitWithNormalizedReference:string stringRepresentation:nil];
}

@end

#pragma mark -

@implementation BibCutterDigit {
    NSString *_representation;
}

- (BOOL)isWellDefined {
    return _representation != nil;
}

- (instancetype)initWithNormalizedReference:(NSString *)reference stringRepresentation:(NSString *)representation {
    if (self = [super init]) {
        _reference = [reference copy];
        _representation = [representation copy];
    }
    return self;
}

+ (instancetype)digitWithNormalizedReference:(NSString *)reference stringRepresentation:(NSString *)representation {
    return [[BibCutterDigit alloc] initWithNormalizedReference:reference stringRepresentation:representation];
}

+ (NSString *)normalizedStringFromString:(NSString *)string {
    NSLocale *const english = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSStringCompareOptions const options = NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch|NSWidthInsensitiveSearch;
    NSString *const ascii = [string stringByFoldingWithOptions:options locale:english];
    NSUInteger const length = [ascii length];
    NSMutableString *const normalized = [NSMutableString stringWithCapacity:length];
    for (NSUInteger index = 0; index < length; index += 1) {
        if ([sNormalizedCharacterSet characterIsMember:[ascii characterAtIndex:index]]) {
            [normalized appendFormat:@"%c", [ascii characterAtIndex:index]];
        }
    }
    return [normalized copy];
}

+ (void)initialize {
    NSMutableCharacterSet *const validSet = [NSMutableCharacterSet new];
    [validSet formUnionWithCharacterSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    [validSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    sNormalizedCharacterSet = [validSet copy];
    sNonNormalizedCharacterSet = [validSet invertedSet];
}

- (NSString *)description {
    return _representation;
}

- (NSComparisonResult)compare:(BibCutterDigit *)digit {
    if ([self isWellDefined] && [digit isWellDefined]) {
        return [_representation compare:[digit description]];
    }
    if ([self isWellDefined] || [digit isWellDefined]) {
        NSComparisonResult result = [_reference compare:[digit reference]];
        if (result == NSOrderedSame) {
            return ([self isWellDefined]) ? NSOrderedAscending : NSOrderedDescending;
        }
        return result;
    }
    return [_reference compare:[digit reference]];
}

@end
