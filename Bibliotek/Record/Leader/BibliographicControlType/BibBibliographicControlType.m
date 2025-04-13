//
//  BibBibliographicControlType.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/13/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicControlType.h"
#import "BibLeader.h"

NSString *BibBibliographicControlTypeDescription(BibBibliographicControlType const type) {
    union { char c; unsigned char uc; } v = { .c = type };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", type];
    NSString *key = [NSString stringWithFormat:@"control-type:%c", type];
    return [bundle localizedStringForKey:key value:value table:@"BibliographicControlType"];
}
