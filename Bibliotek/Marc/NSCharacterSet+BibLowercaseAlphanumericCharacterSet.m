//
//  NSCharacterSet+BibLowercaseAlphanumericCharacterSet.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "NSCharacterSet+BibLowercaseAlphanumericCharacterSet.h"

@implementation NSCharacterSet (BibLowercaseAlphanumericCharacterSet)

+ (NSCharacterSet *)bib_lowercaseAlphanumericCharacterSet {
    static NSCharacterSet *lowercaseASCIICharacterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *const alphabet = @"abcdefghijklmnopqrstuvwxyz";
        NSString *const numerals = @"0123456789";
        NSString *const lowercaseAlphanumerals = [alphabet stringByAppendingString:numerals];
        lowercaseASCIICharacterSet = [NSCharacterSet characterSetWithCharactersInString:lowercaseAlphanumerals];
    });
    return lowercaseASCIICharacterSet;
}

@end
