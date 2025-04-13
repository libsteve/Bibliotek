//
//  BibEncoding.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/20/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import "BibEncoding.h"

NSString *BibEncodingDescription(BibEncoding const encoding) {
    switch (encoding) {
        case BibMARC8Encoding: return @"MARC8";
        case BibUTF8Encoding:  return @"UTF-8";
        default: {
            union { char c; unsigned char uc; } v = { .c = encoding };
            if (v.uc < 0x20 || v.uc >= 0x7F) {
                return [NSString stringWithFormat:@"0x%2Xu", v.uc];
            }
            return [NSString stringWithFormat:@"%c", encoding];
        }
    }
}
