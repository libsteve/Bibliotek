//
//  BibDDClassificationCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDDClassificationCallNumber.h"
#import "BibRecordSubfield.h"

static NSPredicate *sClassificationNumberPredicate;
static NSPredicate *sItemNumberPredicate;
static NSPredicate *sScheduleEditionPredicate;
static NSPredicate *sAssigningAgencyPredicate;

static BibRecordFieldTag const kRecordFieldTag = @"082";

@implementation BibDDClassificationCallNumber

@synthesize classificationNumber = _classificationNumber;
@synthesize itemNumber = _itemNumber;
@synthesize alternativeNumbers = _alternativeNumbers;
@synthesize libraryOfCongressOwnership = _libraryOfCongressOwnership;

@synthesize scheduleEdition = _scheduleEdition;
@synthesize editionKind = _editionKind;
@synthesize assigningAgency = _assigningAgency;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sClassificationNumberPredicate = [NSPredicate predicateWithFormat:@"code == 'a'"];
        sItemNumberPredicate = [NSPredicate predicateWithFormat:@"code == 'b'"];
        sScheduleEditionPredicate = [NSPredicate predicateWithFormat:@"code == '2'"];
        sAssigningAgencyPredicate = [NSPredicate predicateWithFormat:@"code == 'q'"];
    });
}

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    BibEditionKind const editionKind = [[indicators firstObject] characterAtIndex:0];
    BibLibraryOfCongressOwnership const libraryOfCongressOwnership = [[indicators lastObject] characterAtIndex:0];
    NSArray *const classificationNumbers = [subfields filteredArrayUsingPredicate:sClassificationNumberPredicate];
    NSString *const classificationNumber = [[classificationNumbers firstObject] content];
    NSString *const itemNumber = [[[subfields filteredArrayUsingPredicate:sItemNumberPredicate] firstObject] content];
    NSUInteger const classificationNumbersCount = [classificationNumbers count];
    NSRange const alternativeNumbersRange = NSMakeRange(1, classificationNumbersCount - 1);
    NSArray *const alternativeNumbers = (classificationNumbersCount)
                                      ? [classificationNumbers subarrayWithRange:alternativeNumbersRange]
                                      : [NSArray array];
    NSString *const scheduleEdition = [[[subfields filteredArrayUsingPredicate:sScheduleEditionPredicate] firstObject] content];
    NSString *const assigningAgency = [[[subfields filteredArrayUsingPredicate:sAssigningAgencyPredicate] firstObject] content];
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _classificationNumber = [classificationNumber copy];
        _itemNumber = [itemNumber copy];
        _alternativeNumbers = [alternativeNumbers copy] ?: [NSArray array];
        _scheduleEdition = [scheduleEdition copy];
        _editionKind = editionKind;
        _assigningAgency = [assigningAgency copy];
        _libraryOfCongressOwnership = libraryOfCongressOwnership;
        if (_classificationNumber == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
    }
    return self;
}

- (NSString *)description {
    if (_itemNumber) {
        return [@[_classificationNumber, _itemNumber] componentsJoinedByString:@" "];
    }
    return _classificationNumber;
}

@end
