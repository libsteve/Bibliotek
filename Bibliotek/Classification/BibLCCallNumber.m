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
