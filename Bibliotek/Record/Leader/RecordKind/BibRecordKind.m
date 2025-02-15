//
//  BibRecordKind.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordKind.h"
#import "BibRecord.h"

BibRecordFormat BibRecordKindFormat(BibRecordKind kind) {
    switch (kind) {
        case BibRecordKindLanguageMaterial:
        case BibRecordKindNotatedMusic:
        case BibRecordKindManuscriptNotatedMusic:
        case BibRecordKindCartographicMaterial:
        case BibRecordKindManuscriptCartographicMaterial:
        case BibRecordKindProjectedMedium:
        case BibRecordKindNonMusicalSoundRecording:
        case BibRecordKindMusicalSoundRecording:
        case BibRecordKindTwoDimensionalNonProjectableGraphic:
        case BibRecordKindComputerFile:
        case BibRecordKindKit:
        case BibRecordKindMixedMaterials:
            return BibRecordFormatBibliographic;
        case BibRecordKindCommunityInformation:
            return BibRecordFormatCommunity;
        case BibRecordKindThreeDimensionalArtifact:
        case BibRecordKindManuscriptLanguageMaterial:
            return BibRecordFormatBibliographic;
        case BibRecordKindUnknownHoldings:
        case BibRecordKindMultipartItemHoldings:
            return BibRecordFormatHoldings;
        case BibRecordKindClassification:
            return BibRecordFormatClassification;
        case BibRecordKindSinglePartItemHoldings:
        case BibRecordKindSerialItemHoldings:
            return BibRecordFormatHoldings;
        case BibRecordKindAuthorityData:
            return BibRecordFormatAuthority;
        default:
            return ' '; /* The record format for an unrecognized record kind. */
    }
}

NSString *BibRecordKindDescription(BibRecordKind kind) {
    union { char c; unsigned char uc; } v = { .c = kind };
    if (v.uc < 0x20 || v.uc >= 0x7F) {
        return [NSString stringWithFormat:@"0x%2Xu", v.uc];
    }
    NSBundle *bundle = [NSBundle bundleForClass:[BibRecord class]];
    NSString *value = [NSString stringWithFormat:@"%c", kind];
    NSString *key = [NSString stringWithFormat:@"kind:%c", kind];
    return [bundle localizedStringForKey:key value:value table:@"RecordKind"];
}
