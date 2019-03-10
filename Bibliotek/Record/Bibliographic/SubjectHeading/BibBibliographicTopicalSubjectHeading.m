//
//  BibBibliographicSubjectHeadingTopical.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibBibliographicTopicalSubjectHeading.h"
#import "BibRecordSubfield.h"

static BibRecordFieldTag const kRecordFieldTag = @"650";

static NSPredicate *sTermPredicate;
static NSPredicate *sFormSubdivisionPredicate;
static NSPredicate *sGeneralSubdivisionPredicate;
static NSPredicate *sChronologicalSubdivisionPredicate;
static NSPredicate *sGeographicSubdivisionPredicate;
static NSPredicate *sRWOIdentifiersPredicate;
static NSPredicate *sSourcePredicate;

@implementation BibBibliographicTopicalSubjectHeading

@synthesize thesaurus = _thesaurus;
@synthesize term = _term;
@synthesize formSubdivision = _formSubdivision;
@synthesize generalSubdivision = _generalSubdivision;
@synthesize chronologicalSubdivision = _chronologicalSubdivision;
@synthesize geographicSubdivision = _geographicSubdivision;
@synthesize realWorldObjectIdentifiers = _realWorldObjectIdentifiers;
@synthesize source = _source;

- (BibRecordFieldTag)tag { return kRecordFieldTag; }

+ (BibRecordFieldTag)recordFieldTag { return kRecordFieldTag; }

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTermPredicate = [NSPredicate predicateWithFormat:@"code = 'a'"];
        sFormSubdivisionPredicate = [NSPredicate predicateWithFormat:@"code = 'v'"];
        sGeneralSubdivisionPredicate = [NSPredicate predicateWithFormat:@"code = 'x'"];
        sChronologicalSubdivisionPredicate = [NSPredicate predicateWithFormat:@"code = 'y'"];
        sGeographicSubdivisionPredicate = [NSPredicate predicateWithFormat:@"code = 'z'"];
        sRWOIdentifiersPredicate = [NSPredicate predicateWithFormat:@"code = '1'"];
        sSourcePredicate = [NSPredicate predicateWithFormat:@"code = '2'"];
    });
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _thesaurus = [[indicators lastObject] characterAtIndex:0];
        _term = [[[subfields filteredArrayUsingPredicate:sTermPredicate] firstObject] content];
        _formSubdivision = [[subfields filteredArrayUsingPredicate:sFormSubdivisionPredicate] valueForKey:@"content"];
        _generalSubdivision = [[subfields filteredArrayUsingPredicate:sGeographicSubdivisionPredicate] valueForKey:@"content"];
        _chronologicalSubdivision = [[subfields filteredArrayUsingPredicate:sChronologicalSubdivisionPredicate] valueForKey:@"content"];
        _geographicSubdivision = [[subfields filteredArrayUsingPredicate:sGeographicSubdivisionPredicate] valueForKey:@"content"];
        _realWorldObjectIdentifiers = [[subfields filteredArrayUsingPredicate:sRWOIdentifiersPredicate] valueForKey:@"content"];
        _source = [[[subfields filteredArrayUsingPredicate:sSourcePredicate] firstObject] content];
        if (_term == nil) {
            [NSException raise:NSInternalInconsistencyException format:@"Required subfield $a not found"];
        }
    }
    return self;
}

@end
