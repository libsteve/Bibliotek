//
//  BibLCClassificationCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibLCClassificationCallNumber.h"
#import "BibRecordSubfield.h"

static NSPredicate *sClassificationNumberPredicate;
static NSPredicate *sItemNumberPredicate;

static BibRecordFieldTag const kRecordFieldTag = @"050";

@implementation BibLCClassificationCallNumber

@synthesize classificationNumber = _classificationNumber;
@synthesize itemNumber = _itemNumber;
@synthesize alternativeNumbers = _alternativeNumbers;
@synthesize libraryOfCongressOwnership = _libraryOfCongressOwnership;
@synthesize source = _source;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sClassificationNumberPredicate = [NSPredicate predicateWithFormat:@"code == 'a'"];
        sItemNumberPredicate = [NSPredicate predicateWithFormat:@"code == 'b'"];
    });
}

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    BibLibraryOfCongressOwnership const libraryOfCongressOwnership = [[indicators firstObject] characterAtIndex:0];
    BibLCClassificationCallNumberSource const source = [[indicators lastObject] characterAtIndex:0];
    NSArray *const classificationNumbers = [subfields filteredArrayUsingPredicate:sClassificationNumberPredicate];
    NSString *const classificationNumber = [[classificationNumbers firstObject] content];
    NSString *const itemNumber = [[[subfields filteredArrayUsingPredicate:sItemNumberPredicate] firstObject] content];
    NSUInteger const classificationNumbersCount = [classificationNumbers count];
    NSRange const alternativeNumbersRange = NSMakeRange(1, classificationNumbersCount - 1);
    NSArray *const alternativeNumbers = (classificationNumbersCount)
                                      ? [classificationNumbers subarrayWithRange:alternativeNumbersRange]
                                      : [NSArray array];
    if (classificationNumber == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
    }
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _classificationNumber = [classificationNumber copy];
        _itemNumber = [itemNumber copy];
        _alternativeNumbers = [alternativeNumbers copy] ?: [NSArray array];
        _libraryOfCongressOwnership = libraryOfCongressOwnership;
        _source = source;
    }
    return self;
}

@end
