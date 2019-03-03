//
//  BibBibliographicRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicRecord.h"
#import "BibClassificationCallNumber.h"
#import "BibLCClassificationCallNumber.h"
#import "BibDDClassificationCallNumber.h"

static NSPredicate *sLCCCallNumberPredicate;
static NSPredicate *sDDCCallNumberPredicate;

@implementation BibBibliographicRecord

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class const lccCallNumberClass = [BibLCClassificationCallNumber class];
        sLCCCallNumberPredicate = [NSPredicate predicateWithBlock:^(id object, id bindings) {
            return [object isKindOfClass:lccCallNumberClass];
        }];
        Class const ddcCallNumberClass = [BibDDClassificationCallNumber class];
        sDDCCallNumberPredicate = [NSPredicate predicateWithBlock:^(id object, id bindings) {
            return [object isKindOfClass:ddcCallNumberClass];
        }];
    });
}

+ (NSDictionary<BibRecordFieldTag,Class> *)recordSchema {
    static NSDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = @{ [BibLCClassificationCallNumber recordFieldTag] : [BibLCClassificationCallNumber class],
                        [BibDDClassificationCallNumber recordFieldTag] : [BibDDClassificationCallNumber class] };
    });
    return dictionary;
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                        fields:(NSArray<id<BibRecordField>> *)fields {
    if (self = [super initWithLeader:leader directory:directory fields:fields]) {
        _lccCallNumbers = (id)[fields filteredArrayUsingPredicate:sLCCCallNumberPredicate];
        _ddcCallNumbers = (id)[fields filteredArrayUsingPredicate:sDDCCallNumberPredicate];
    }
    return self;
}

@end
