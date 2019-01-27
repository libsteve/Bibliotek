//
//  NSCharacterSet+BibLowercaseAlphanumericCharacterSet.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "NSCharacterSet+BibLowercaseAlphanumericCharacterSet.h"

@implementation NSCharacterSet (BibLowercaseAlphanumericCharacterSet)

+ (NSCharacterSet *)bib_ASCIICharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(0, 256)];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIControlCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableSet = [NSMutableCharacterSet characterSetWithRange:NSMakeRange(0, 32)];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(127, 1)]];
        characterSet = [mutableSet copy];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIPrintableCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(32, 95)];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIExtendedCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(128, 126)];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIINumericCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(48, 10)];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIAlphabetCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableSet = [NSMutableCharacterSet new];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIILowercaseCharacterSet]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIIUppercaseCharacterSet]];
        characterSet = [mutableSet copy];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIExtendedAlphabetCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableSet = [NSMutableCharacterSet new];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIIAlphabetCharacterSet]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(128, 27)]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(160, 6)]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(181, 3)]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(198, 2)]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(208, 9)]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(222, 1)]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(224, 14)]];
        characterSet = [mutableSet copy];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIGraphicCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableSet = [NSMutableCharacterSet new];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIIPrintableCharacterSet]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIIExtendedCharacterSet]];
        characterSet = [mutableSet copy];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIILowercaseCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(97, 27)];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIUppercaseCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(65, 27)];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIIAlphanumericCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableSet = [NSMutableCharacterSet new];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIIAlphabetCharacterSet]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]];
        characterSet = [mutableSet copy];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_ASCIILowercaseAlphanumericCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableSet = [NSMutableCharacterSet new];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIILowercaseCharacterSet]];
        [mutableSet formUnionWithCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]];
        characterSet = [mutableSet copy];
    });
    return characterSet;
}

#pragma mark -

+ (NSCharacterSet *)bib_westernNumeralCharacterSet {
    return [self bib_ASCIINumericCharacterSet];
}

+ (NSCharacterSet *)bib_lowercaseEnglishCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *const alphabet = @"abcdefghijklmnopqrstuvwxyz";
        characterSet = [NSCharacterSet characterSetWithCharactersInString:alphabet];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_lowercaseAlphanumericCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *const mutableCharacterSet = [NSMutableCharacterSet new];
        [mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet bib_westernNumeralCharacterSet]];
        [mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet bib_lowercaseEnglishCharacterSet]];
        characterSet = [mutableCharacterSet copy];
    });
    return characterSet;
}

+ (NSCharacterSet *)bib_blankIndicatorCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    });
    return characterSet;
}

@end
