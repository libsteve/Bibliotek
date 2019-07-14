//
//  BibMetadata.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMetadata.h"

#pragma mark Encoding

NSString *BibEncodingDescription(BibEncoding const encoding) {
    switch (encoding) {
        case BibMARC8Encoding: return @"MARC8";
        case BibUTF8Encoding:  return @"UTF8";
        default: return [NSString stringWithFormat:@"%c", encoding];
    }
}

#pragma mark - Record Kind

BOOL BibRecordKindIsClassification(BibRecordKind recordKind) {
    return recordKind == BibRecordKindClassification;
}

BOOL BibRecordKindIsBibliographic(BibRecordKind recordKind) {
    static BibRecordKind const kinds[] = {
        BibRecordKindLanguageMaterial,
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
        BibRecordKindManuscriptLanguageMateral
    };
    for (NSUInteger index = 0; index < sizeof(kinds); index += 1) {
        if (kinds[index] == recordKind) {
            return YES;
        }
    }
    return NO;
}

NSString *BibRecordKindDescription(BibRecordKind recordKind) {
    switch (recordKind) {
        case BibRecordKindClassification:                      return @"Classification";
        case BibRecordKindLanguageMaterial:                    return @"Language Material";
        case BibRecordKindNotatedMusic:                        return @"Notated Music";
        case BibRecordKindManuscriptNotatedMusic:              return @"Manuscript Notated Music";
        case BibRecordKindCartographicMaterial:                return @"Cartographic Material";
        case BibRecordKindManuscriptCartographicMaterial:      return @"Manuscript Cartographic Material";
        case BibRecordKindProjectedMedium:                     return @"Projected Medium";
        case BibRecordKindNonMusicalSoundRecording:            return @"NonMusical Sound Recording";
        case BibRecordKindMusicalSoundRecording:               return @"Musical Sound Recording";
        case BibRecordKindTwoDimensionalNonProjectableGraphic: return @"Two-Dimensional Non-Projectable Graphic";
        case BibRecordKindComputerFile:                        return @"Computer File";
        case BibRecordKindKit:                                 return @"Kit";
        case BibRecordKindMixedMaterials:                      return @"Mixed Materials";
        case BibRecordKindThreeDimensionalArtifact:            return @"Three-Dimensional Artifact";
        case BibRecordKindManuscriptLanguageMateral:           return @"Manuscript LanguageMateral";
        case BibRecordKindUndefined:                           return @"Undefined";
        default: return [NSString stringWithFormat:@"%c", recordKind];
    }
}
