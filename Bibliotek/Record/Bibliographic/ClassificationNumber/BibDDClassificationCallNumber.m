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
    return [self initWithClassificationNumber:classificationNumber
                                   itemNumber:itemNumber
                           alternativeNumbers:alternativeNumbers
                              scheduleEdition:scheduleEdition
                                  editionKind:editionKind
                              assigningAgency:assigningAgency
                   libraryOfCongressOwnership:libraryOfCongressOwnership];
}

- (instancetype)initWithClassificationNumber:(NSString *)classificationNumber
                                  itemNumber:(NSString *)itemNumber
                          alternativeNumbers:(NSArray<NSString *> *)alternativeNumbers
                             scheduleEdition:(NSString *)scheduleEdition
                                 editionKind:(BibEditionKind)editionKind
                             assigningAgency:(BibMarcOrganization)assigningAgency
                libraryOfCongressOwnership:(BibLibraryOfCongressOwnership)libraryOfCongressOwnership {
    if (self = [super initWithIndicators:@[] subfields:@[]]) {
        _classificationNumber = [classificationNumber copy];
        _itemNumber = [itemNumber copy];
        _alternativeNumbers = [alternativeNumbers copy] ?: [NSArray array];
        _scheduleEdition = [scheduleEdition copy];
        _editionKind = editionKind;
        _assigningAgency = [assigningAgency copy];
        _libraryOfCongressOwnership = libraryOfCongressOwnership;
    }
    return self;
}

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField {
    BibDDClassificationCallNumber *other = (id)dataField;
    return [dataField isKindOfClass:[BibDDClassificationCallNumber class]]
        && [_classificationNumber isEqualToString:[other classificationNumber]]
        && (_itemNumber == [other itemNumber] || [_itemNumber isEqualToString:[other itemNumber]])
        && [_alternativeNumbers isEqualToArray:[other alternativeNumbers]]
        && (_scheduleEdition == [other scheduleEdition] || [_scheduleEdition isEqualToString:[other scheduleEdition]])
        && (_editionKind == [other editionKind])
        && (_assigningAgency == [other assigningAgency] || [_assigningAgency isEqualToString:[other assigningAgency]])
        && (_libraryOfCongressOwnership == [other libraryOfCongressOwnership]);
}

- (NSUInteger)hash {
    return [_classificationNumber hash] ^ [_itemNumber hash] ^ [_alternativeNumbers hash]
         ^ [_scheduleEdition hash] ^ _editionKind ^ [_assigningAgency hash]
         ^ _libraryOfCongressOwnership;
}

- (NSString *)description {
    NSMutableArray *components = [@[ [NSString stringWithFormat:@"$2%@", _scheduleEdition],
                                     [NSString stringWithFormat:@"$a%@", _classificationNumber] ] mutableCopy];
    if (_itemNumber) {
        [components addObject:[NSString stringWithFormat:@"$b%@", _itemNumber]];
    }
    for (NSString *alternate in _alternativeNumbers) {
        [components addObject:[NSString stringWithFormat:@"$a%@", alternate]];
    }
    if (_assigningAgency) {
        [components addObject:[NSString stringWithFormat:@"$q%@", _assigningAgency]];
    }
    char const ownership =
        (_libraryOfCongressOwnership == BibLibraryOfCongressOwnershipUnknown) ? '#' : _libraryOfCongressOwnership;
    return [NSString stringWithFormat:@"%@ %c%c %@", [self tag], (char)_editionKind, ownership,
                                                     [components componentsJoinedByString:@""]];
}

@end
