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
    NSBundle *bundle = [NSBundle bundleForClass:[BibLeader self]];
    NSString *value = [NSString stringWithFormat:@"%c", type];
    NSString *key = [NSString stringWithFormat:@"control-type:%c", type];
    return [bundle localizedStringForKey:key value:value table:@"BibliographicControlType"];
}
