//
//  BibClassificationRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationRecord.h"
#import "BibClassificationRecordMetadata.h"
#import "BibClassificationRecordClassificationNumber.h"
#import "BibClassificationRecordClassificationScheme.h"

static NSPredicate *sMetadataPredicate;
static NSPredicate *sNumberPredicate;
static NSPredicate *sSchemePredicate;
static NSDictionary *sRecordFieldTypes;

@implementation BibClassificationRecord

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class const metadataClass = [BibClassificationRecordMetadata class];
        sMetadataPredicate = [NSPredicate predicateWithBlock:^(id object, id bindings){
            return [object isKindOfClass:metadataClass];
        }];
        Class const numberClass = [BibClassificationRecordClassificationNumber class];
        sNumberPredicate = [NSPredicate predicateWithBlock:^(id object, id bindings){
            return [object isKindOfClass:numberClass];
        }];
        Class const schemeClass = [BibClassificationRecordClassificationScheme class];
        sSchemePredicate = [NSPredicate predicateWithBlock:^(id object, id bindings){
            return [object isKindOfClass:schemeClass];
        }];
        sRecordFieldTypes = @{ [metadataClass recordFieldTag] : [metadataClass class],
                               [numberClass recordFieldTag] : [numberClass class],
                               [schemeClass recordFieldTag] : [schemeClass class] };
    });
}

+ (NSDictionary<BibRecordFieldTag,Class> *)recordSchema { return sRecordFieldTypes; }

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                        fields:(NSArray<id<BibRecordField>> *)fields {
    if (self = [super initWithLeader:leader directory:directory fields:fields]) {
        _metadata = [[fields filteredArrayUsingPredicate:sMetadataPredicate] firstObject];
        _classificationNumber = [[fields filteredArrayUsingPredicate:sNumberPredicate] firstObject];
        _classificationScheme = [[fields filteredArrayUsingPredicate:sSchemePredicate] firstObject];
    }
    return self;
}

@end
