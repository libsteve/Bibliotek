//
//  BibDescriptiveCatalogingForm.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/24.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import "BibDescriptiveCatalogingForm.h"
#import "BibLeader.h"

NSString *BibDescriptiveCatalogingFormDescription(BibDescriptiveCatalogingForm const form) {
    union { char c; unsigned char uc; } v = { .c = form };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", form];
    NSString *key = [NSString stringWithFormat:@"form:%c", form];
    return [bundle localizedStringForKey:key value:value table:@"DescriptiveCatalogingForm"];
}
