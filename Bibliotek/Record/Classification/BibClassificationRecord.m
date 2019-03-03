//
//  BibClassificationRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordControlField.h"
#import "BibRecordDataField.h"

#import "BibClassificationRecord.h"
#import "BibClassificationRecordMetadata.h"
#import "BibClassificationRecordClassificationNumber.h"
#import "BibClassificationRecordClassificationScheme.h"

static NSPredicate *sMetadataPredicate;
static NSPredicate *sNumberPredicate;
static NSPredicate *sSchemePredicate;

@implementation BibClassificationRecord

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMetadataPredicate = [NSPredicate predicateWithFormat:@"tag == '%@'", [BibClassificationRecordMetadata recordFieldTag]];
        sNumberPredicate = [NSPredicate predicateWithFormat:@"tag == '%@'", [BibClassificationRecordClassificationNumber recordFieldTag]];
        sSchemePredicate = [NSPredicate predicateWithFormat:@"tag == '%@'", [BibClassificationRecordClassificationScheme recordFieldTag]];
    });
}

- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                 controlFields:(NSArray<BibRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibRecordDataField *> *)dataFields {
    if (self = [super initWithLeader:leader directory:directory controlFields:controlFields dataFields:dataFields]) {
        BibRecordControlField *const metadataField = [[controlFields filteredArrayUsingPredicate:sMetadataPredicate] firstObject];
        _metadata = [[BibClassificationRecordMetadata alloc] initWithContent:[metadataField content]];
        BibRecordDataField *const numberField = [[dataFields filteredArrayUsingPredicate:sNumberPredicate] firstObject];
        _classificationNumber = [[BibClassificationRecordClassificationNumber alloc] initWithIndicators:[numberField indicators]
                                                                                              subfields:[numberField subfields]];
        BibRecordDataField *const schemeField = [[dataFields filteredArrayUsingPredicate:sSchemePredicate] firstObject];
        _classificationScheme = [[BibClassificationRecordClassificationScheme alloc] initWithIndicators:[schemeField indicators]
                                                                                              subfields:[schemeField subfields]];
    }
    return self;
}

@end

BibRecordFieldTag const BibRecordFieldTagClassificationRecordMetadata = @"008";
BibRecordFieldTag const BibRecordFieldTagClassificationRecordClassificationScheme = @"084";
BibRecordFieldTag const BibRecordFieldTagClassificationRecordClassificationNumber = @"153";
