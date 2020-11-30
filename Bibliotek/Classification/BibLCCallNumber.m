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
    bib_lc_callnum_t _calln;
}

@synthesize stringValue = _stringValue;

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        NSCharacterSet *const whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *const trimmed = [string stringByTrimmingCharactersInSet:whitespace];
        if (!bib_lc_callnum_init(&_calln, [trimmed cStringUsingEncoding:NSASCIIStringEncoding])) {
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
    bib_lc_callnum_deinit(&_calln);
}

- (NSString *)description {
    return [self stringValue];
}

- (NSString *)stringValue
{
    if (_stringValue == nil) {
        NSMutableString *const string = [NSMutableString new];
        [string appendFormat:@"%s%s", _calln.caption.letters, _calln.caption.integer];
        if (_calln.caption.decimal[0] != '\0') {
            [string appendFormat:@".%s", _calln.caption.decimal];
        }
        BOOL const hasCaptionDate = (_calln.caption.date[0] != '\0');
        if (hasCaptionDate) {
            [string appendFormat:@" %s", _calln.caption.date];
        }
        BOOL const hasOrdinalNumber = (_calln.caption.ordinal.number[0] != '\0');
        if (hasOrdinalNumber) {
            [string appendFormat:@" %s", _calln.caption.ordinal.number];
            if (_calln.caption.ordinal.suffix[0] != '\0') {
                [string appendFormat:@"%s", _calln.caption.ordinal.suffix];
            }
        }
        for (size_t index = 0; (index < 3) && (_calln.cutters[index].number[0] != '\0'); index += 1) {
            if (index == 0) {
                if (hasCaptionDate || hasOrdinalNumber) {
                    [string appendString:@" ."];
                } else {
                    [string appendString:@"."];
                }
            } else {
                [string appendString:@" "];
            }
            [string appendFormat:@"%s", _calln.cutters[index].number];
            if (_calln.cutters[index].suffix[0] != '\0') {
                [string appendFormat:@"%s", _calln.cutters[index].suffix];
            }
            if (_calln.cutters[index].date[0] != '\0') {
                [string appendFormat:@" %s", _calln.cutters[index].date];
            }
        }
        for (size_t index = 0; index < _calln.special_count; index += 1) {
            switch (_calln.special[index].spec) {
                case bib_lc_special_spec_date:
                    [string appendFormat:@" %s", _calln.special[index].value.date];
                    break;
                case bib_lc_special_spec_suffix:
                    [string appendFormat:@"%s", _calln.special[index].value.suffix];
                    break;
                case bib_lc_special_spec_ordinal:
                    [string appendFormat:@" %s%s", _calln.special[index].value.ordinal.number,
                                                   _calln.special[index].value.ordinal.suffix];
                    break;
                case bib_lc_special_spec_workmark:
                    [string appendFormat:@"%s", _calln.special[index].value.workmark];
                    break;
                case bib_lc_special_spec_datespan:
                    [string appendFormat:@" %s%c%s", _calln.special[index].value.datespan.year,
                                                     _calln.special[index].value.datespan.separator,
                                                     _calln.special[index].value.datespan.span];
                    break;
            }
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

    bib_lc_callnum_t const *const leftn = &_calln;
    bib_lc_callnum_t const *const rightn = &(other->_calln);

    bib_calln_comparison_t result = bib_calln_ordered_same;
    result = bib_lc_callnum_compare(result, leftn, rightn, specialize);
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
