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

@implementation BibClassificationRecordClassificationNumber

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sNumbersPredicate = [NSPredicate predicateWithFormat:@"code == 'a' || code == 'c'"];
        sCaptionsPredicate = [NSPredicate predicateWithFormat:@"code == 'h' || code == 'j'"];
        sTableIdentifierPredicate = [NSPredicate predicateWithFormat:@"code == 'z'"];
    });
}

+ (BibRecordFieldTag)recordFieldTag {
    return BibRecordFieldTagClassificationRecordClassificationNumber;
}

- (instancetype)init {
    return [self initWithIndicators:@[BibRecordFieldIndicatorBlank, BibRecordFieldIndicatorBlank]
                          subfields:@[[[BibRecordSubfield alloc] initWithCode:@"a" content:@"F61"],
                                      [[BibRecordSubfield alloc] initWithCode:@"h"
                                                                      content:@"United States local history"]]];
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super init]) {
        _tableIdentifier = [[[subfields filteredArrayUsingPredicate:sTableIdentifierPredicate] firstObject] content];
        _classificationNumbers = [[subfields filteredArrayUsingPredicate:sNumbersPredicate] valueForKey:@"content"];
        _captions = [[subfields filteredArrayUsingPredicate:sCaptionsPredicate] valueForKey:@"content"];
    }
    return self;
}

@end
