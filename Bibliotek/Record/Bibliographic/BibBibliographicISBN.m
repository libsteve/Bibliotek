//
//  BibBibliographicISBN.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicISBN.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"020";

static NSPredicate *sValuePredicate;

@implementation BibBibliographicISBN

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sValuePredicate = [NSPredicate predicateWithFormat:@"code = 'a'"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _stringValue = [[[[subfields filteredArrayUsingPredicate:sValuePredicate] firstObject] content] copy];
        if (_stringValue == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
        switch ([_stringValue length]) {
            case 10:
                _kind = BibBibliographicISBNKindISBN10;
                break;
            case 13:
                _kind = BibBibliographicISBNKindISBN13;
                break;
            default:
                [NSException raise:NSInternalInconsistencyException format:@"Invalid ISBN value %@", _stringValue];
        }
    }
    return self;
}

- (NSString *)description {
    return _stringValue;
}

@end
