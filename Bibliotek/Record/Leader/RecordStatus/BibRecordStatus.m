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
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"status:%c", status];
    NSString *key = [NSString stringWithFormat:@"%c", status];
    return [bundle localizedStringForKey:key value:value table:@"RecordStatus"];
}
