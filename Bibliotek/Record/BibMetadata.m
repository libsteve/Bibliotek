//
//  BibMetadata.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMetadata.h"
#import "BibMetadata+Internal.h"
#import "BibLeader.h"

static BibReservedPosition const kAllReservedPositions[] = {
    BibReservedPosition07,
    BibReservedPosition08,
    BibReservedPosition17,
    BibReservedPosition18,
    BibReservedPosition19
};

#pragma mark - Metadata

@implementation BibMetadata {
    BibLeader *_leader;
}

- (instancetype)init {
    if (self = [super init]) {
        _leader = [BibLeader new];
    }
    return self;
}

- (int8_t)valueForReservedPosition:(BibReservedPosition)index {
    return [[self leader] valueForReservedPosition:index];
}

- (NSString *)description {
    NSMutableArray *const components = [NSMutableArray new];
    NSUInteger const count = sizeof(kAllReservedPositions) / sizeof(BibReservedPosition);
    for (NSUInteger index = 0; index < count; index += 1) {
        BibReservedPosition const position = kAllReservedPositions[index];
        uint8_t const value =  [self valueForReservedPosition:position];
        [components addObject:[NSString stringWithFormat:@"\"%c\"", value]];
    }
    return [NSString stringWithFormat:@"[%@]", [components componentsJoinedByString:@", "]];
}

@end

@implementation BibMetadata (Internal)

- (instancetype)initWithLeader:(BibLeader *)leader {
    if (self = [super init]) {
        _leader = [leader copy];
    }
    return self;
}

- (BibLeader *)leader {
    return _leader;
}

@end

#pragma mark -

@implementation BibMetadata (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableMetadata allocWithZone:zone] initWithLeader:[self leader]];
}

@end

@implementation BibMetadata (Equality)

- (BOOL)isEqualToMetadata:(BibMetadata *)metadata {
    int const indexCount = sizeof(kAllReservedPositions) / sizeof(BibReservedPosition);
    for (int index = 0; index < indexCount; index += 1) {
        char const myValue = [self valueForReservedPosition:kAllReservedPositions[index]];
        char const theirValue = [metadata valueForReservedPosition:kAllReservedPositions[index]];
        if (myValue != theirValue) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibMetadata class]] && [self isEqualToMetadata:object]);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    int const indexCount = sizeof(kAllReservedPositions) / sizeof(BibReservedPosition);
    for (int index = 0; index < indexCount; index += 1) {
        hash |= [self valueForReservedPosition:kAllReservedPositions[index]] << (index % 4 * 8);
    }
    return hash;
}

@end

#pragma mark - Mutable Metadata

@implementation BibMutableMetadata {
    BibMutableLeader *_leader;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMetadata allocWithZone:zone] initWithLeader:[self leader]];
}

- (void)setValue:(int8_t)value forReservedPosition:(BibReservedPosition)index {
    [[self leader] setValue:value forReservedPosition:index];
}

@end

@implementation BibMutableMetadata (Internal)

- (BibMutableLeader *)leader {
    if (_leader == nil) {
        _leader = [[super leader] mutableCopy];
    }
    return _leader;
}

@end

#pragma mark - Encoding

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
