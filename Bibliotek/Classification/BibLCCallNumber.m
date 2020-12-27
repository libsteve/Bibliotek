//
//  BibLCCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibLCCallNumber.h"
#import "bibtype.h"

@implementation BibLCCallNumber {
    bib_lc_calln_t _calln;
}

@synthesize stringValue = _stringValue;

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        NSCharacterSet *const whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *const trimmed = [string stringByTrimmingCharactersInSet:whitespace];
        if (!bib_lc_calln_init(&_calln, [trimmed cStringUsingEncoding:NSASCIIStringEncoding])) {
            return nil;
        }
    }
    return self;
}

+ (instancetype)callNumberWithString:(NSString *)string
{
    return [[BibLCCallNumber alloc] initWithString:string];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc
{
    bib_lc_calln_deinit(&_calln);
}

- (NSString *)description {
    return [self stringValue];
}

static NSString *bib_date_description(bib_date_t const *const date) {
    NSMutableString *const string = [NSMutableString new];
    [string appendFormat:@"%s", date->year];
    if (bib_date_has_span(date)) {
        [string appendFormat:@"%c%s", date->separator, date->span];
    }
    [string appendFormat:@"%s", date->mark];
    return [string copy];
}

static NSString *bib_ordinal_description(bib_ordinal_t const *const ord) {
    return [NSString stringWithFormat:@"%s%s", ord->number, ord->suffix];
}

static NSString *bib_lc_number_description(bib_lc_dateord_t const *const num) {
    switch (num->kind) {
    case bib_lc_dateord_kind_date:    return bib_date_description(&(num->value.date));
    case bib_lc_dateord_kind_ordinal: return bib_ordinal_description(&(num->value.ordinal));
    }
}

static NSString *bib_volume_description(bib_volume_t const *const vol) {
    return [NSString stringWithFormat:@"%s. %s", vol->prefix, vol->number];
}

static NSString *bib_lc_special_description(bib_lc_specification_t const *const spc) {
    switch (spc->kind) {
        case bib_lc_specification_kind_date: return bib_date_description(&(spc->value.date));
        case bib_lc_specification_kind_ordinal: return bib_ordinal_description(&(spc->value.ordinal));
        case bib_lc_specification_kind_volume: return bib_volume_description(&(spc->value.volume));
        case bib_lc_specification_kind_word: return [NSString stringWithFormat:@"%s", spc->value.word];
    }
}

- (NSString *)stringValue
{
    static BOOL const separateCutterNumbers = YES;
    if (_stringValue == nil) {
        NSMutableString *const string = [NSMutableString new];
        [string appendFormat:@"%s%s", _calln.letters, _calln.integer];
        if (_calln.decimal[0] != '\0') {
            [string appendFormat:@".%s", _calln.decimal];
        }
        BOOL hasNumber = !bib_lc_dateord_is_empty(&_calln.dateord);
        if (hasNumber) {
            [string appendFormat:@" %@", bib_lc_number_description(&(_calln.dateord))];
        }
        BOOL lastCutterHasNumber = NO;
        for (size_t index = 0; index < 3; index += 1) {
            bib_lc_cutter_t const *const cut = &(_calln.cutters[index]);
            if (!bib_lc_cutter_is_empty(cut)) {
                if (index == 0) {
                    if (hasNumber) {
                        [string appendFormat:@" "];
                    }
                    [string appendFormat:@"."];
                } else if (separateCutterNumbers || lastCutterHasNumber) {
                    [string appendFormat:@" "];
                }
                [string appendFormat:@"%c%s%s", cut->cuttnum.letter, cut->cuttnum.number, cut->cuttnum.mark];
                lastCutterHasNumber = !bib_lc_dateord_is_empty(&(cut->dateord));
                if (lastCutterHasNumber) {
                    [string appendFormat:@" %@", bib_lc_number_description(&(cut->dateord))];
                }
            }
        }
        for (size_t index = 0; index < 2; index += 1) {
            bib_lc_specification_t const *const spc = &(_calln.specifications[index]);
            if (!bib_lc_specification_is_empty(spc)) {
                [string appendFormat:@" %@", bib_lc_special_description(spc)];
            }
        }
        for (size_t index = 0; index < _calln.remainder.length; index += 1) {
            bib_lc_specification_t const *const spc = &(_calln.remainder.buffer[index]);
            [string appendFormat:@" %@", bib_lc_special_description(spc)];
        }
        _stringValue = [string copy];
    }
    return _stringValue;
}

- (NSComparisonResult)compare:(BibLCCallNumber *)other
{
    switch ([self compareWithCallNumber:other forSpecialization:NO]) {
        case BibClassificationOrderedDescending: return NSOrderedDescending;
        case BibClassificationOrderedSame: return NSOrderedSame;
        case BibClassificationOrderedAscending: return NSOrderedAscending;
        case BibClassificationOrderedSpecifying: return NSOrderedAscending;
    }
}

- (BibClassificationComparisonResult)compareWithCallNumber:(BibLCCallNumber *)other
{
    return [self compareWithCallNumber:other forSpecialization:YES];
}

- (BibClassificationComparisonResult)compareWithCallNumber:(BibLCCallNumber *)other forSpecialization:(BOOL)specialize
{
    if (other == nil) {
        return BibClassificationOrderedDescending;
    }

    bib_lc_calln_t const *const leftn = &_calln;
    bib_lc_calln_t const *const rightn = &(other->_calln);

    bib_calln_comparison_t result = bib_calln_ordered_same;
    result = bib_lc_calln_compare(result, leftn, rightn, specialize);
    switch (result) {
        case bib_calln_ordered_same: return BibClassificationOrderedSame;
        case bib_calln_ordered_specifying: return BibClassificationOrderedSpecifying;
        case bib_calln_ordered_ascending: return BibClassificationOrderedAscending;
        case bib_calln_ordered_descending: return BibClassificationOrderedDescending;
    }
}

- (BOOL)includesCallNumber:(BibLCCallNumber *)callNumber
{
    switch ([self compareWithCallNumber:callNumber forSpecialization:YES]) {
        case BibClassificationOrderedSpecifying:
        case BibClassificationOrderedSame:
            return YES;

        default:
            return NO;
    }
}

- (BOOL)isEqualToCallNumber:(BibLCCallNumber *)other
{
    return self == other || [self compareWithCallNumber:other forSpecialization:NO] == BibClassificationOrderedSame;
}

- (BOOL)isEqual:(id)object
{
    return self == object
        || ([object isKindOfClass:[BibLCCallNumber self]] && [self isEqualToCallNumber:object]);
}

- (NSUInteger)hash
{
    return [[self stringValue] hash];
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;

}

+ (instancetype)new
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
