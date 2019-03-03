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
    if (self = [super initWithIndicators:@[] subfields:@[]]) {
        _classificationNumber = [classificationNumber copy];
        _itemNumber = [itemNumber copy];
        _alternativeNumbers = [alternativeNumbers copy] ?: [NSArray array];
        _libraryOfCongressOwnership = libraryOfCongressOwnership;
        _source = source;
    }
    return self;
}

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField {
    BibLCClassificationCallNumber *other = (id)dataField;
    return [dataField isKindOfClass:[BibLCClassificationCallNumber class]]
        && [_classificationNumber isEqualToString:[other classificationNumber]]
        && (_itemNumber == [other itemNumber] || [_itemNumber isEqualToString:[other itemNumber]])
        && [_alternativeNumbers isEqualToArray:[other alternativeNumbers]]
        && _libraryOfCongressOwnership == [other libraryOfCongressOwnership]
        && _source == [other source];
}

- (NSUInteger)hash {
    return [_classificationNumber hash] ^ [_itemNumber hash] ^ [_alternativeNumbers hash]
         ^ _libraryOfCongressOwnership ^ _source;
}

- (NSString *)description {
    NSMutableArray *components = [@[ [NSString stringWithFormat:@"$a%@", _classificationNumber] ] mutableCopy];
    if (_itemNumber) {
        [components addObject:[NSString stringWithFormat:@"$b%@", _itemNumber]];
    }
    for (NSString *alternate in _alternativeNumbers) {
        [components addObject:[NSString stringWithFormat:@"$a%@", alternate]];
    }
    char const ownership =
        (_libraryOfCongressOwnership == BibLibraryOfCongressOwnershipUnknown) ? '#' : _libraryOfCongressOwnership;
    char const source = (_source == BibLCClassificationCallNumberSourceUnknown) ? '#' : _source;
    return [NSString stringWithFormat:@"%@ %c%c %@", [self tag], ownership, source,
                                                     [components componentsJoinedByString:@""]];
}

@end
