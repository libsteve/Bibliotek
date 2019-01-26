//
//  NSCharacterSet+BibLowercaseAlphanumericCharacterSet.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "NSCharacterSet+BibLowercaseAlphanumericCharacterSet.h"

@implementation NSCharacterSet (BibLowercaseAlphanumericCharacterSet)

+ (NSCharacterSet *)bib_westernNumeralCharacterSet {
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *const numerals = @"0123456789";
        characterSet = [NSCharacterSet characterSetWithCharactersInString:numerals];
    });
    return characterSet;
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

@end
