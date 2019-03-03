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

static NSPredicate *lccNumberPredicate;
static NSPredicate *ddcNumberPredicate;

static NSArray *objectsOfClassFromDataFieldsMatchingPredicate(Class class,
                                                              NSArray<BibRecordDataField *> *dataFields,
                                                              NSPredicate *predicate);

@implementation BibBibliographicRecord

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lccNumberPredicate = [NSPredicate predicateWithFormat:@"tag == '%@'", [BibLCClassificationCallNumber recordFieldTag]];
        ddcNumberPredicate = [NSPredicate predicateWithFormat:@"tag == '%@'", [BibDDClassificationCallNumber recordFieldTag]];
    });
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                 controlFields:(NSArray<BibRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibRecordDataField *> *)dataFields {
    if (self = [super initWithLeader:leader directory:directory controlFields:controlFields dataFields:dataFields]) {
        _lccCallNumbers = objectsOfClassFromDataFieldsMatchingPredicate([BibLCClassificationCallNumber class],
                                                                        dataFields,
                                                                        lccNumberPredicate);
        _ddcCallNumbers = objectsOfClassFromDataFieldsMatchingPredicate([BibLCClassificationCallNumber class],
                                                                        dataFields,
                                                                        ddcNumberPredicate);
    }
    return self;
}

@end

static NSArray *objectsOfClassFromDataFieldsMatchingPredicate(Class class,
                                                              NSArray<BibRecordDataField *> *dataFields,
                                                              NSPredicate *predicate) {
    NSMutableArray *const objects = [NSMutableArray array];
    for (BibRecordDataField *dataField in [dataFields filteredArrayUsingPredicate:predicate]) {
        [objects addObject:[[BibLCClassificationCallNumber alloc] initWithIndicators:[dataField indicators]
                                                                           subfields:[dataField subfields]]];
    }
    return [objects copy];
}
