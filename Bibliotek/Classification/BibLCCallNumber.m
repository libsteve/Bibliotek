//
//  BibLCCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibLCCallNumber.h"
#import "BibLCCallNumber+Internal.h"

@implementation BibLCCallNumber {
    bib_lc_calln_t _rawCallNumber;
}

@synthesize stringValue = _stringValue;

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        NSCharacterSet *const whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *const trimmed = [string stringByTrimmingCharactersInSet:whitespace];
        if (!bib_lc_calln_init(&_rawCallNumber, [trimmed cStringUsingEncoding:NSASCIIStringEncoding])) {
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
    bib_lc_calln_deinit(&_rawCallNumber);
}

- (NSString *)description {
    return [self stringValue];
}

- (NSString *)stringValue
{
    if (_stringValue == nil) {
        NSMutableString *const string = [NSMutableString new];
        [string appendFormat:@"%s%s", _rawCallNumber.alphabetic_segment, _rawCallNumber.whole_number];
        if (_rawCallNumber.decimal_number[0] != '\0') {
            [string appendFormat:@".%s", _rawCallNumber.decimal_number];
        }
        if (_rawCallNumber.date_or_other_number[0] != '\0') {
            [string appendFormat:@" %s ", _rawCallNumber.date_or_other_number];
        }
        if (_rawCallNumber.first_cutter_number[0] != '\0') {
            [string appendFormat:@".%s", _rawCallNumber.first_cutter_number];
        }
        if (_rawCallNumber.date_or_other_number_after_first_cutter[0] != '\0') {
            [string appendFormat:@" %s", _rawCallNumber.date_or_other_number_after_first_cutter];
        }
        if (_rawCallNumber.second_cutter_number[0] != '\0') {
            [string appendFormat:@" %s", _rawCallNumber.second_cutter_number];
        }
        for (size_t index = 0; index < _rawCallNumber.remaing_segments_length; index += 1) {
            [string appendFormat:@" %s", _rawCallNumber.remaing_segments[index]];
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

typedef enum string_specialized_comparison_result {
    /// The \c string is lexically ordered before the \c prefix and therefore does not specialize it.
    string_specialized_ordered_descending = -1,

    /// The \c string does begin with \c prefix and they are equal.
    string_specialized_ordered_same       =  0,

    /// The \c string is lexically ordered after the \c prefix in a way that does not specialize it.
    string_specialized_ordered_ascending  =  1,

    /// The \c string does begin with \c prefix but they are not equal.
    string_specialized_ordered_specifying =  2
} string_specialized_comparison_result_t;

/// Determine if the given \c string begins with the given \c prefix and whether or not they are equal.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param prefix A prefix string search for.
/// \param string A string that may or may not begin with or euqal to the given prefix
/// \returns \c string_specialization_none when the string does begin with the given prefix
/// \returns \c string_specialization_none when the status is set to \c string_specialization_none
/// \returns \c string_specialization_none when the status is \c string_specialization_found
///          and the given prefix is not the empty string.
/// \returns \c string_specialization_maybe when the status is set to \c string_specialization_maybe
///          and the string and prefix are equivalent.
/// \returns \c string_specialization_found when the string begins with, but is not equal to, the given prefix.
/// \returns \c string_specialization_found when the status is set to \c string_specialization_found
///          and the given prefix is empty the empty string.
static string_specialized_comparison_result_t string_specialized_compare(string_specialized_comparison_result_t status,
                                                                         char const *const prefix,
                                                                         char const *const string)
{
    switch (status) {
        case string_specialized_ordered_ascending:
        case string_specialized_ordered_descending: {
            return status;
        }
        case string_specialized_ordered_same:
            if (prefix == NULL) { return string_specialized_ordered_same; }
            else if (string == NULL) { return string_specialized_ordered_descending; }
            for (size_t index = 0; true; index += 1) {
                char const prefix_char = prefix[index];
                char const string_char = string[index];
                if (prefix_char == '\0') {
                    return (string_char == '\0') ? string_specialized_ordered_same
                                                 : string_specialized_ordered_specifying;
                }
                if (string_char == '\0') {
                    return string_specialized_ordered_descending;
                }
                if (prefix_char < string_char) {
                    return string_specialized_ordered_ascending;
                }
                if (prefix_char > string_char) {
                    return string_specialized_ordered_descending;
                }
            }
        case string_specialized_ordered_specifying: {
            BOOL empty_prefix = (prefix == NULL) || (prefix[0] == '\0');
            return (empty_prefix) ? string_specialized_ordered_specifying : string_specialized_ordered_ascending;
        }
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

    bib_lc_calln_t const *const leftn = &_rawCallNumber;
    bib_lc_calln_t const *const rightn = &(other->_rawCallNumber);

    string_specialized_comparison_result_t result = string_specialized_ordered_same;
    result = string_specialized_compare(result, leftn->alphabetic_segment, rightn->alphabetic_segment);
    if (result == string_specialized_ordered_ascending) { return BibClassificationOrderedAscending; }
    if (result == string_specialized_ordered_descending) { return BibClassificationOrderedDescending; }
    if (!specialize && result == BibClassificationOrderedSpecifying) { return BibClassificationOrderedAscending; }

    if (result == string_specialized_ordered_specifying && (leftn->whole_number[0] != '\0')) { return BibClassificationOrderedAscending; }
    int const leftNum = atoi(leftn->whole_number);
    int const rightNum = atoi(rightn->whole_number);
    if (leftNum != rightNum) { return (leftNum < rightNum) ? BibClassificationOrderedAscending : BibClassificationOrderedDescending; }

    result = string_specialized_compare(result, leftn->decimal_number, rightn->decimal_number);
    if (!specialize && result == BibClassificationOrderedSpecifying) { return BibClassificationOrderedAscending; }
    result = string_specialized_compare(result, leftn->date_or_other_number, rightn->date_or_other_number);
    if (!specialize && result == BibClassificationOrderedSpecifying) { return BibClassificationOrderedAscending; }
    result = string_specialized_compare(result, leftn->first_cutter_number, rightn->first_cutter_number);
    if (!specialize && result == BibClassificationOrderedSpecifying) { return BibClassificationOrderedAscending; }
    result = string_specialized_compare(result, leftn->date_or_other_number_after_first_cutter, rightn->date_or_other_number_after_first_cutter);
    if (!specialize && result == BibClassificationOrderedSpecifying) { return BibClassificationOrderedAscending; }
    result = string_specialized_compare(result, leftn->second_cutter_number, rightn->second_cutter_number);
    if (!specialize && result == BibClassificationOrderedSpecifying) { return BibClassificationOrderedAscending; }

    switch (result) {
        case BibClassificationOrderedAscending: return BibClassificationOrderedAscending;
        case BibClassificationOrderedDescending: return BibClassificationOrderedDescending;
        case BibClassificationOrderedSpecifying: if (!specialize) { return BibClassificationOrderedAscending; }
        case BibClassificationOrderedSame: break;
    }

    size_t const remaining_count = MIN(leftn->remaing_segments_length, rightn->remaing_segments_length);
    for (size_t index = 0; index < remaining_count; index += 1) {
        result = string_specialized_compare(result, leftn->remaing_segments[index], rightn->remaing_segments[index]);
        if (result == string_specialized_ordered_ascending) { return BibClassificationOrderedAscending; }
        if (result == string_specialized_ordered_descending) { return BibClassificationOrderedDescending; }
        if (!specialize && result == string_specialized_ordered_specifying) { return BibClassificationOrderedAscending; }
    }
    if (leftn->remaing_segments_length < rightn->remaing_segments_length) {
        return (specialize) ? BibClassificationOrderedSpecifying : BibClassificationOrderedAscending;
    }
    if (leftn->remaing_segments_length > rightn->remaing_segments_length) {
        return BibClassificationOrderedDescending;
    }
    switch (result) {
        case BibClassificationOrderedSame: return BibClassificationOrderedSame;
        case BibClassificationOrderedSpecifying: return BibClassificationOrderedSpecifying;
        case BibClassificationOrderedAscending: return BibClassificationOrderedAscending;
        case BibClassificationOrderedDescending: return BibClassificationOrderedDescending;
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
