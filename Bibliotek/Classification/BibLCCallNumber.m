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
    if (other == nil) {
        return NSOrderedDescending;
    }
    
    int result = strcmp(_rawCallNumber.alphabetic_segment, other->_rawCallNumber.alphabetic_segment);
    if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }

    int const leftNum = atoi(_rawCallNumber.whole_number);
    int const rightNum = atoi(other->_rawCallNumber.whole_number);
    if (leftNum != rightNum) { return (leftNum < rightNum) ? NSOrderedAscending : NSOrderedDescending; }

    result = strcmp(_rawCallNumber.decimal_number, other->_rawCallNumber.decimal_number);
    if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }

    result = strcmp(_rawCallNumber.date_or_other_number, other->_rawCallNumber.date_or_other_number);
    if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }

    result = strcmp(_rawCallNumber.first_cutter_number, other->_rawCallNumber.first_cutter_number);
    if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }

    result = strcmp(_rawCallNumber.date_or_other_number_after_first_cutter,
                    other->_rawCallNumber.date_or_other_number_after_first_cutter);
    if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }

    result = strcmp(_rawCallNumber.second_cutter_number, other->_rawCallNumber.second_cutter_number);
    if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }

    size_t const remaining_count = MIN(_rawCallNumber.remaing_segments_length,
                                       other->_rawCallNumber.remaing_segments_length);
    for (size_t index = 0; index < remaining_count; index += 1) {
        result = strcmp(_rawCallNumber.remaing_segments[index], other->_rawCallNumber.remaing_segments[index]);
        if (result != 0) { return (result < 0) ? NSOrderedAscending : NSOrderedDescending; }
    }
    if (_rawCallNumber.remaing_segments_length < other->_rawCallNumber.remaing_segments_length) {
        return NSOrderedAscending;
    }
    if (_rawCallNumber.remaing_segments_length > other->_rawCallNumber.remaing_segments_length) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

typedef enum string_specialization {
    /// The \c string does not begin with \c prefix and therefore does not specialize it.
    string_specialization_none,

    /// The \c string does begin with \c prefix and they are equal.
    string_specialization_maybe,

    /// The \c string does begin with \c prefix but they are not equal.
    string_specialization_found
} string_specialization_t;

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
static string_specialization_t string_specialization_compare(string_specialization_t status,
                                                             char const *const prefix,
                                                             char const *const string)
{
    switch (status) {
        case string_specialization_none: {
            return string_specialization_none;
        }
        case string_specialization_maybe:
            if (prefix == NULL) { return string_specialization_maybe; }
            else if (string == NULL) { return string_specialization_none; }
            for (size_t index = 0; true; index += 1) {
                char const prefix_char = prefix[index];
                char const string_char = string[index];
                if (prefix_char == '\0') {
                    return (string_char == '\0') ? string_specialization_maybe : string_specialization_found;
                }
                if (string_char == '\0') {
                    return string_specialization_none;
                }
                if (prefix_char != string_char) {
                    return string_specialization_none;
                }
            }
        case string_specialization_found: {
            BOOL empty_prefix = (prefix == NULL) || (prefix[0] == '\0');
            return (empty_prefix) ? string_specialization_found : string_specialization_none;
        }
    }
}

- (BOOL)includesCallNumber:(BibLCCallNumber *)callNumber
{
    if (callNumber == nil) {
        return NO;
    }

    bib_lc_calln_t const *const leftn = &_rawCallNumber;
    bib_lc_calln_t const *const rightn = &(callNumber->_rawCallNumber);

    string_specialization_t status = string_specialization_maybe;
    status = string_specialization_compare(status, leftn->alphabetic_segment, rightn->alphabetic_segment);

    if ((status == string_specialization_none)
        || (status == string_specialization_found && (leftn->whole_number[0] != '\0'))
        || (atoi(leftn->whole_number) != atoi(rightn->whole_number))) {
            return NO;
    }

    status = string_specialization_compare(status, leftn->decimal_number, rightn->decimal_number);
    status = string_specialization_compare(status, leftn->date_or_other_number, rightn->date_or_other_number);
    status = string_specialization_compare(status, leftn->first_cutter_number, rightn->first_cutter_number);
    status = string_specialization_compare(status, leftn->date_or_other_number_after_first_cutter,
                                           rightn->date_or_other_number_after_first_cutter);
    status = string_specialization_compare(status, leftn->second_cutter_number, rightn->second_cutter_number);

    switch (status) {
        case string_specialization_none:
            return NO;
        case string_specialization_maybe:
            if (leftn->remaing_segments_length == 0) { return YES; }
            if (leftn->remaing_segments_length > rightn->remaing_segments_length) { return NO; }
            break;
        case string_specialization_found:
            return (leftn->remaing_segments_length == 0);
    }

    size_t const remaining_count = leftn->remaing_segments_length;
    for (size_t index = 0; index < remaining_count; index += 1) {
        status = string_specialization_compare(status, leftn->remaing_segments[index], rightn->remaing_segments[index]);
        if (status == string_specialization_none) { return NO; }
    }

    return YES;
}

- (BOOL)isEqualToCallNumber:(BibLCCallNumber *)other
{
    return self == other || [[self stringValue] isEqualToString:[other stringValue]];
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
