//
//  BibEncodingLevel.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/5/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import "BibEncodingLevel.h"
#import "BibLeader.h"

#pragma mark Bibliographic

NSString *BibBibliographicEncodingLevelDescription(BibBibliographicEncodingLevel const level) {
    union { char c; unsigned char uc; } v = { .c = level };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", level];
    NSString *key = [NSString stringWithFormat:@"bibliographic:%c", level];
    return [bundle localizedStringForKey:key value:value table:@"EncodingLevel"];
}

#pragma mark - Authority

NSString *BibAuthorityEncodingLevelDescription(BibAuthorityEncodingLevel level) {
    union { char c; unsigned char uc; } v = { .c = level };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", level];
    NSString *key = [NSString stringWithFormat:@"authority:%c", level];
    return [bundle localizedStringForKey:key value:value table:@"EncodingLevel"];
}

#pragma mark - Holdings

NSString *BibHoldingsEncodingLevelDescription(BibHoldingsEncodingLevel level) {
    union { char c; unsigned char uc; } v = { .c = level };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", level];
    NSString *key = [NSString stringWithFormat:@"holdings:%c", level];
    return [bundle localizedStringForKey:key value:value table:@"EncodingLevel"];
}

#pragma mark - Classification

NSString *BibClassificationEncodingLevelDescription(BibClassificationEncodingLevel level) {
    union { char c; unsigned char uc; } v = { .c = level };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", level];
    NSString *key = [NSString stringWithFormat:@"classification:%c", level];
    return [bundle localizedStringForKey:key value:value table:@"EncodingLevel"];
}
