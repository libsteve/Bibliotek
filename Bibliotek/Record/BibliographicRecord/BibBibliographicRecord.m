//
//  BibBibliographicRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicRecord.h"
#import "BibISBN.h"
#import "BibDDClassificationNumber.h"
#import "BibLCClassificationNumber.h"

#import "BibRecord.h"
#import "BibRecordKind.h"
#import "BibFieldTag.h"
#import "BibControlField.h"
#import "BibContentField.h"
#import "BibSubfield.h"

static BibFieldTag *BibFieldTagISBN;
static BibFieldTag *BibFieldTagDDClassificationNumber;
static BibFieldTag *BibFieldTagLCClassificationNumber;

static NSDictionary<BibFieldTag *, Class> *bibliographicSchema;

@implementation BibBibliographicRecord {
    NSArray<BibISBN *> *_isbns;
    NSArray<BibDDClassificationNumber *> *_ddClassificationNumbers;
    NSArray<BibLCClassificationNumber *> *_lcClassificationNumbers;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BibFieldTagISBN = [[BibFieldTag alloc] initWithString:@"020"];
        BibFieldTagDDClassificationNumber = [[BibFieldTag alloc] initWithString:@"082"];
        BibFieldTagLCClassificationNumber = [[BibFieldTag alloc] initWithString:@"050"];
        bibliographicSchema = @{
            BibFieldTagISBN : [BibISBN class],
            BibFieldTagDDClassificationNumber : [BibDDClassificationNumber class],
            BibFieldTagLCClassificationNumber : [BibLCClassificationNumber class]
        };
    });
}

- (instancetype)initWithRecord:(BibRecord *)record {
    if (![[record kind] isBibliographicKind]) { return nil; }
    if (self = [super init]) {
        NSMutableArray *const isbns = [NSMutableArray new];
        NSMutableArray *const lccns = [NSMutableArray new];
        NSMutableArray *const ddcns = [NSMutableArray new];
        NSDictionary<BibFieldTag *, NSMutableArray *> *const builder = @{
            BibFieldTagISBN : isbns,
            BibFieldTagDDClassificationNumber : ddcns,
            BibFieldTagLCClassificationNumber : lccns
        };
        for (BibContentField *contentField in [record contentFieldEnumerator]) {
            BibFieldTag *const fieldTag = [contentField tag];
            Class const fieldClass = [bibliographicSchema objectForKey:fieldTag];
            id const bibField = [[fieldClass alloc] initWithContentField:contentField];
            if (bibField) { [[builder objectForKey:fieldTag] addObject:bibField]; }
        }
        _isbns = [isbns copy];
        _ddClassificationNumbers = [ddcns copy];
        _lcClassificationNumbers = [lccns copy];
    }
    return self;
}

@end
