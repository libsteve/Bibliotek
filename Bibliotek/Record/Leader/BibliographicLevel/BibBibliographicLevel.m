//
//  BibBibliographicLevel.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/13/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicLevel.h"
#import "BibLeader.h"

NSString *BibBibliographicLevelDescription(BibBibliographicLevel const level) {
    union { char c; unsigned char uc; } v = { .c = level };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", level];
    NSString *key = [NSString stringWithFormat:@"level:%c", level];
    return [bundle localizedStringForKey:key value:value table:@"BibliographicLevel"];
}
