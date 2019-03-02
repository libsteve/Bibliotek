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

+ (BibRecordFieldTag)recordFieldTag {
    return @"050";
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithClassificationNumber:@"QA76.76.C672"
                                   itemNumber:@"B3693 2011"
                           alternativeNumbers:[NSArray array]
                   libraryOfCongressOwnership:BibLibraryOfCongressOwnershipUnknown
                                       source:BibLCClassificationCallNumberSourceUnknown];
}

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
    return [self initWithClassificationNumber:classificationNumber
                                   itemNumber:itemNumber
                           alternativeNumbers:alternativeNumbers
                    libraryOfCongressOwnership:libraryOfCongressOwnership
                                       source:source];
}

- (instancetype)initWithClassificationNumber:(NSString *)classificationNumber
                                  itemNumber:(NSString *)itemNumber
                          alternativeNumbers:(NSArray<NSString *> *)alternativeNumbers
                  libraryOfCongressOwnership:(BibLibraryOfCongressOwnership)libraryOfCongressOwnership
                                      source:(BibLCClassificationCallNumberSource)source {
    if (self = [super init]) {
        _classificationNumber = [classificationNumber copy];
        _itemNumber = [itemNumber copy];
        _alternativeNumbers = [alternativeNumbers copy] ?: [NSArray array];
        _libraryOfCongressOwnership = libraryOfCongressOwnership;
        _source = source;
    }
    return self;
}

@end
