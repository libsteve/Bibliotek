//
//  BibRecordConstants.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordConstants.h"

#pragma mark - Record Status

BibRecordStatus const BibRecordStatusIncreaseInEncodingLevel = @"a";
BibRecordStatus const BibRecordStatusRevised = @"c";
BibRecordStatus const BibRecordStatusDeleted = @"d";
BibRecordStatus const BibRecordStatusNew = @"n";
BibRecordStatus const BibRecordStatusIncreaseInEncodingLevelFromPrePublication = @"p";

#pragma mark - Record Kind

BibRecordKind const BibRecordKindClassification = @"w";

BibRecordKind const BibRecordKindLanguageMaterial = @"a";
BibRecordKind const BibRecordKindNotatedMusic = @"c";
BibRecordKind const BibRecordKindManuscriptNotatedMusic = @"d";
BibRecordKind const BibRecordKindCartographicMaterial = @"e";
BibRecordKind const BibRecordKindManuscriptCartographicMaterial = @"f";
BibRecordKind const BibRecordKindProjectedMedium = @"g";
BibRecordKind const BibRecordKindNonMusicalSoundRecording = @"i";
BibRecordKind const BibRecordKindMusicalSoundRecording = @"j";
BibRecordKind const BibRecordKindTwoDimensionalNonProjectableGraphic = @"k";
BibRecordKind const BibRecordKindComputerFile = @"m";
BibRecordKind const BibRecordKindKit = @"o";
BibRecordKind const BibRecordKindMixedMaterials = @"p";
BibRecordKind const BibRecordKindThreeDimensionalArtifact = @"r";
BibRecordKind const BibRecordKindManuscriptLanguageMateral = @"t";

BOOL BibRecordKindIsClassification(BibRecordKind recordKind) {
    return [recordKind isEqualToString:BibRecordKindClassification];
}

BOOL BibRecordKindIsBibliographic(BibRecordKind recordKind) {
    static NSCharacterSet *characterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *const bibliohraphicRecordKinds = @[BibRecordKindLanguageMaterial,
                                                    BibRecordKindNotatedMusic,
                                                    BibRecordKindManuscriptNotatedMusic,
                                                    BibRecordKindCartographicMaterial,
                                                    BibRecordKindManuscriptCartographicMaterial,
                                                    BibRecordKindProjectedMedium,
                                                    BibRecordKindNonMusicalSoundRecording,
                                                    BibRecordKindMusicalSoundRecording,
                                                    BibRecordKindTwoDimensionalNonProjectableGraphic,
                                                    BibRecordKindComputerFile,
                                                    BibRecordKindKit,
                                                    BibRecordKindMixedMaterials,
                                                    BibRecordKindThreeDimensionalArtifact,
                                                    BibRecordKindManuscriptLanguageMateral];
        NSString *const stringRepresentations = [bibliohraphicRecordKinds componentsJoinedByString:@""];
        characterSet = [NSCharacterSet characterSetWithCharactersInString:stringRepresentations];
    });
    return [characterSet characterIsMember:[recordKind characterAtIndex:0]];
}

NSString *BibRecordKindDescription(BibRecordKind recordKind) {
    if ([recordKind isEqualToString: BibRecordKindClassification]) return @"Classification";
    if ([recordKind isEqualToString: BibRecordKindLanguageMaterial]) return @"Language Material";
    if ([recordKind isEqualToString: BibRecordKindNotatedMusic]) return @"Notated Music";
    if ([recordKind isEqualToString: BibRecordKindManuscriptNotatedMusic]) return @"Manuscript Notated Music";
    if ([recordKind isEqualToString: BibRecordKindCartographicMaterial]) return @"Cartographic Material";
    if ([recordKind isEqualToString: BibRecordKindManuscriptCartographicMaterial]) return @"Manuscript Cartographic Material";
    if ([recordKind isEqualToString: BibRecordKindProjectedMedium]) return @"Projected Medium";
    if ([recordKind isEqualToString: BibRecordKindNonMusicalSoundRecording]) return @"NonMusical Sound Recording";
    if ([recordKind isEqualToString: BibRecordKindMusicalSoundRecording]) return @"Musical Sound Recording";
    if ([recordKind isEqualToString: BibRecordKindTwoDimensionalNonProjectableGraphic]) return @"Two-Dimensional Non-Projectable Graphic";
    if ([recordKind isEqualToString: BibRecordKindComputerFile]) return @"Computer File";
    if ([recordKind isEqualToString: BibRecordKindKit]) return @"Kit";
    if ([recordKind isEqualToString: BibRecordKindMixedMaterials]) return @"Mixed Materials";
    if ([recordKind isEqualToString: BibRecordKindThreeDimensionalArtifact]) return @"Three-Dimensional Artifact";
    if ([recordKind isEqualToString: BibRecordKindManuscriptLanguageMateral]) return @"Manuscript LanguageMateral";
    return recordKind;
}

#pragma mark - Character Coding Scheme

BibRecordCharacterCodingScheme const BibRecordCharacterCodingSchemeMarc8 = @" ";
BibRecordCharacterCodingScheme const BibRecordCharacterCodingSchemeUnicode = @"a";

NSString *BibRecordCharacterCodingSchemeDescription(BibRecordCharacterCodingScheme characterCodingScheme) {
    if ([characterCodingScheme isEqualToString:BibRecordCharacterCodingSchemeMarc8]) return @"Marc8";
    if ([characterCodingScheme isEqualToString:BibRecordCharacterCodingSchemeUnicode]) return @"Unicode";
    return characterCodingScheme;
}

#pragma mark - Edition Kind

NSString *BibEditionKindDescription(BibEditionKind editionKind) {
    switch (editionKind) {
    case BibEditionKindFull: return @"Full";
    case BibEditionKindAbridged: return @"Abridged";
    case BibEditionKindSpecified: return @"Specified";
    case BibEditionKindOther: return @"Other";
    }
}

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
