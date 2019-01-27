//
//  NSString+BibCharacterSetValidation.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "NSString+BibCharacterSetValidation.h"

@implementation NSString (BibCharacterSetValidation)

- (BOOL)bib_isRestrictedToCharacterSet:(NSCharacterSet *)characterSet inRange:(NSRange)range {
    range = NSIntersectionRange(range, NSRangeFromString(self));
    guard(range.length != 0) {
        return NO;
    }
    for (NSUInteger index = range.location; index < NSMaxRange(range); index += 1) {
        guard([characterSet characterIsMember:[self characterAtIndex:index]]) {
            return NO;
        }
    }
    return YES;
}

@end
