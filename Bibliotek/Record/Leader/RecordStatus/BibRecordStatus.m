//
//  BibRecordStatus.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/12/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import "BibRecordStatus.h"
#import "BibLeader.h"

NSString *BibRecordStatusDescription(BibRecordStatus const status) {
    union { char c; unsigned char uc; } v = { .c = status };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"status:%c", status];
    NSString *key = [NSString stringWithFormat:@"%c", status];
    return [bundle localizedStringForKey:key value:value table:@"RecordStatus"];
}
