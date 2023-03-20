//
//  BibLCCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibLCCallNumber.h"
#import "bibtype.h"
#import "bibtypeio.h"

BibLCCallNumberFormatOptions const BibLCCallNumberFormatOptionsPocket = BibLCCallNumberFormatOptionsExpandSubject
                                                                      | BibLCCallNumberFormatOptionsExpandCutters
                                                                      | BibLCCallNumberFormatOptionsExpandCutterMarks;
BibLCCallNumberFormatOptions const BibLCCallNumberFormatOptionsSpine = BibLCCallNumberFormatOptionsExpandSubject
                                                                     | BibLCCallNumberFormatOptionsExpandCutters
                                                                     | BibLCCallNumberFormatOptionsExpandCutterMarks
                                                                     | BibLCCallNumberFormatOptionsMultiline;

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

- (NSString *)stringValue
{
    if (_stringValue == nil) {
        _stringValue = [self stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault];
    }
    return _stringValue;
}

- (NSString *)stringWithFormatOptions:(BibLCCallNumberFormatOptions)options
{
    char buffer[] = (char[256]){};
    bib_lc_calln_style_t style = {
        .separator = ' ',
        .split_subject = false,
        .split_cutters = false,
        .split_sections = false,
        .extra_cutpoint = false
    };
    if (options & BibLCCallNumberFormatOptionsExpandSubject) {
        style.split_subject = true;
    }
    if (options & BibLCCallNumberFormatOptionsExpandCutters) {
        style.split_cutters = true;
    }
    if (options & BibLCCallNumberFormatOptionsExpandCutterMarks) {
        style.split_sections = true;
    }
    if (options & BibLCCallNumberFormatOptionsMultiline) {
        style.separator = '\n';
    }
    if (options & BibLCCallNumberFormatOptionsMarkCutterAfterDate) {
        style.extra_cutpoint = true;
    }
    size_t __unused _ = bib_snprint_lc_calln(buffer, sizeof(buffer), &_calln, style);
    return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
}

- (NSComparisonResult)compare:(BibLCCallNumber *)other
{
    switch ([self compareWithCallNumber:other forSpecialization:NO]) {
        case BibClassificationOrderedSpecifying: return NSOrderedAscending;
        case BibClassificationOrderedAscending: return NSOrderedAscending;
        case BibClassificationOrderedSame: return NSOrderedSame;
        case BibClassificationOrderedDescending: return NSOrderedDescending;
        case BibClassificationOrderedGeneralizing: return NSOrderedDescending;
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
        case bib_calln_ordered_generalizing: return BibClassificationOrderedGeneralizing;
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
