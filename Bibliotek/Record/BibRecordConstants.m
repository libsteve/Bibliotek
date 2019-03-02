//
//  BibRecordConstants.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordConstants.h"

BibRecordKind const BibRecordKindClassification = @"";
BibRecordKind const BibRecordKindBibliographic = @"";

#pragma mark - Record Field Tags

BibRecordFieldTag const BibRecordFieldTagIsbn = @"020";
BibRecordFieldTag const BibRecordFieldTagLCC = @"050";
BibRecordFieldTag const BibRecordFieldTagDDC = @"082";
BibRecordFieldTag const BibRecordFieldTagAuthor = @"100";
BibRecordFieldTag const BibRecordFieldTagTitle = @"245";
BibRecordFieldTag const BibRecordFieldTagEdition = @"250";
BibRecordFieldTag const BibRecordFieldTagPublication = @"264";
BibRecordFieldTag const BibRecordFieldTagPhysicalDescription = @"300";
BibRecordFieldTag const BibRecordFieldTagNote = @"500";
BibRecordFieldTag const BibRecordFieldTagBibliography = @"504";
BibRecordFieldTag const BibRecordFieldTagSummary = @"520";
BibRecordFieldTag const BibRecordFieldTagSubject = @"650";
BibRecordFieldTag const BibRecordFieldTagGenre = @"655";
BibRecordFieldTag const BibRecordFieldTagSeries = @"940";

NSString *BibMarcRecordFieldTagDescription(BibRecordFieldTag const tag) {
    if ([tag isEqualToString: BibRecordFieldTagIsbn]) return @"ISBN";
    if ([tag isEqualToString: BibRecordFieldTagLCC]) return @"LCC";
    if ([tag isEqualToString: BibRecordFieldTagDDC]) return @"DDC";
    if ([tag isEqualToString: BibRecordFieldTagAuthor]) return @"Author";
    if ([tag isEqualToString: BibRecordFieldTagTitle]) return @"Title";
    if ([tag isEqualToString: BibRecordFieldTagEdition]) return @"Edition";
    if ([tag isEqualToString: BibRecordFieldTagPublication]) return @"Publication";
    if ([tag isEqualToString: BibRecordFieldTagPhysicalDescription]) return @"Physical-Description";
    if ([tag isEqualToString: BibRecordFieldTagNote]) return @"Note";
    if ([tag isEqualToString: BibRecordFieldTagBibliography]) return @"Bibliography";
    if ([tag isEqualToString: BibRecordFieldTagSummary]) return @"Summary";
    if ([tag isEqualToString: BibRecordFieldTagSubject]) return @"Subject";
    if ([tag isEqualToString: BibRecordFieldTagGenre]) return @"Genre";
    if ([tag isEqualToString: BibRecordFieldTagSeries]) return @"Series";
    return [NSString stringWithFormat:@"Unknown-Tag(%@)", tag];
}

#pragma mark - Record Field Indicator

BibRecordFieldIndicator const BibRecordFieldIndicatorBlank = @" ";
