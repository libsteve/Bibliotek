//
//  BibBibliographicContents.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicContents.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"505";

static NSPredicate *sBasicNotePredicate;
static NSPredicate *sEnhancedNotePredicate;
static NSPredicate *sURLPredicate;
static NSPredicate *sContentPredicate;

@implementation BibBibliographicContents

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sBasicNotePredicate = [NSPredicate predicateWithFormat:@"code IN { 'a', 'u' }"];
        sEnhancedNotePredicate = [NSPredicate predicateWithFormat:@"code IN { 'g', 'r', 't', 'u' }"];
        sURLPredicate = [NSPredicate predicateWithFormat:@"code = 'u'"];
        sContentPredicate = [NSPredicate predicateWithFormat:@"code IN { 'a', 'g', 'r', 't' }"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _kind = [[indicators firstObject] characterAtIndex:0];
        _level = [[indicators lastObject] characterAtIndex:0];
        switch (_level) {
            case BibBibliographicContentsLevelBasic:
                _note = [[[[subfields filteredArrayUsingPredicate:sBasicNotePredicate] firstObject] content] copy];
                if (_note == nil) {
                    [NSException raise:NSInternalInconsistencyException
                                format:@"Required subfield $a or $u not found"];
                }
                break;
            case BibBibliographicContentsLevelEnhanced:
                _note = [[[subfields filteredArrayUsingPredicate:sEnhancedNotePredicate] valueForKey:@"content"]
                                componentsJoinedByString:@" "];
                if (_note == nil) {
                    [NSException raise:NSInternalInconsistencyException
                                format:@"Required subfields $g, $r, or $t not found"];
                }
                break;
        }
        _contents = [[[[subfields filteredArrayUsingPredicate:sContentPredicate] valueForKey:@"content"]
                            componentsJoinedByString:@" "]
                            componentsSeparatedByString:@" -- "];
        NSMutableArray *const urls = [NSMutableArray array];
        for (NSString *string in [[subfields filteredArrayUsingPredicate:sURLPredicate] valueForKey:@"content"]) {
            NSString *const rawValue = [string hasSuffix:@" --"]
            ? [string substringWithRange:NSMakeRange(0, [string length] - 3)]
            : string;
            NSURL *const url = [NSURL URLWithString:rawValue];
            if (url) {
                [urls addObject:url];
            }
        }
        _urls = [urls copy];
    }
    return self;
}

- (NSString *)description {
    return _note;
}

@end
