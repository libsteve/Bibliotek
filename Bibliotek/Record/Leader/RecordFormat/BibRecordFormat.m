//
//  BibRecordFormat.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/21/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import "BibRecordFormat.h"
#import "BibLeader.h"

NSString *BibRecordFormatDescription(BibRecordFormat format) {
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader class]];
    NSString *value = [NSString stringWithFormat:@"%c", format];
    NSString *key = [NSString stringWithFormat:@"format:%c", format];
    return [bundle localizedStringForKey:key value:value table:@"RecordFormat"];
}
