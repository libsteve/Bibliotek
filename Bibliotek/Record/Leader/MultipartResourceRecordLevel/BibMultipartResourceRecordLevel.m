//
//  BibMultipartResourceRecordLevel.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/13/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import "BibMultipartResourceRecordLevel.h"
#import "BibLeader.h"

NSString *BibMultipartResourceRecordLevelDescription(BibMultipartResourceRecordLevel level) {
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", level];
    NSString *key = [NSString stringWithFormat:@"level:%c", level];
    return [bundle localizedStringForKey:key value:value table:@"MultipartResourceRecordLevel"];
}
