//
//  NSCharacterSet+ASCIICharacterSet.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "NSCharacterSet+BibLowercaseASCIICharacterSet.h"

@implementation NSCharacterSet (BibLowercaseASCIICharacterSet)

+ (NSCharacterSet *)bib_lowercaseASCIICharacterSet {
    static NSCharacterSet *lowercaseASCIICharacterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *const alphabet = @"abcdefghijklmnopqrstuvwxyz";
        lowercaseASCIICharacterSet = [NSCharacterSet characterSetWithCharactersInString:alphabet];
    });
    return lowercaseASCIICharacterSet;
}

@end
