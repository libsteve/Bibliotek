//
//  BibClassificationRecordNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationRecord.h"
#import "BibClassificationRecordClassificationNumber.h"
#import "BibRecordSubfield.h"

static NSPredicate *sNumbersPredicate;
static NSPredicate *sCaptionsPredicate;
static NSPredicate *sTableIdentifierPredicate;

static BibRecordFieldTag const kRecordFieldTag = @"153";

@implementation BibClassificationRecordClassificationNumber

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sNumbersPredicate = [NSPredicate predicateWithFormat:@"code == 'a' || code == 'c'"];
        sCaptionsPredicate = [NSPredicate predicateWithFormat:@"code == 'h' || code == 'j'"];
        sTableIdentifierPredicate = [NSPredicate predicateWithFormat:@"code == 'z'"];
    });
}

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

- (instancetype)initIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                     subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _tableIdentifier = [[[subfields filteredArrayUsingPredicate:sTableIdentifierPredicate] firstObject] content];
        _classificationNumbers = [[subfields filteredArrayUsingPredicate:sNumbersPredicate] valueForKey:@"content"];
        _captions = [[subfields filteredArrayUsingPredicate:sCaptionsPredicate] valueForKey:@"content"];
    }
    return self;
}

@end
