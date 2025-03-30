//
//  BibPunctuationPolicy.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

#import "BibPunctuationPolicy.h"
#import "BibLeader.h"

NSString *BibPunctuationPolicyDescription(BibPunctuationPolicy const policy) {
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", policy];
    NSString *key = [NSString stringWithFormat:@"policy:%c", policy];
    return [bundle localizedStringForKey:key value:value table:@"PunctuationPolicy"];
}
