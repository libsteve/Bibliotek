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
        default: return [NSString stringWithFormat:@"%c", encoding];
    }
}
