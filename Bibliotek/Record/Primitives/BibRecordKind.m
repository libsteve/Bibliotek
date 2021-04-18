//
//  BibRecordKind.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordKind.h"

/// An underlying backing type for immutable singleton instances of \c BibRecordKind for each value.
///
/// An instance for each of the 128 possible ASCII values is allocated at load time.
/// When \c -initWithRawValue: is called, one of those pre-allocated instances is returned.
@interface _BibRecordKind : BibRecordKind
@end

@implementation BibRecordKind

@synthesize rawValue = _rawValue;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self isEqualTo:[BibRecordKind class]]
         ? [_BibRecordKind allocWithZone:zone]
         : [super allocWithZone:zone];
}

- (instancetype)initWithRawValue:(uint8_t)rawValue {
    if (self = [super init]) {
        _rawValue = rawValue;
    }
    return self;
}

+ (instancetype)recordKindWithRawValue:(uint8_t)rawValue {
    return [[self alloc] initWithRawValue:rawValue];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)new {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end

#pragma mark - Equality

@implementation BibRecordKind (Equality)

- (BOOL)isEqualToRecordKind:(BibRecordKind *)recordKind {
    return self == recordKind || [self rawValue] == [recordKind rawValue];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibRecordKind class]] && [self isEqualToRecordKind:object]);
}

- (NSUInteger)hash {
    return [self rawValue];
}

@end

#pragma mark - Raw Values

typedef NS_ENUM(char, BibRecordKindRawValue) {
    /// Classification
    BibRecordKindRawValueClassification = 'w',

    /// Language Material
    BibRecordKindRawValueLanguageMaterial = 'a',

    /// Notated Music
    BibRecordKindRawValueNotatedMusic = 'c',

    /// Manuscript Notated Music
    BibRecordKindRawValueManuscriptNotatedMusic = 'd',

    /// Cartographic Material
    BibRecordKindRawValueCartographicMaterial = 'e',

    /// Manuscript Cartographic Material
    BibRecordKindRawValueManuscriptCartographicMaterial = 'f',

    /// Projected Medium
    BibRecordKindRawValueProjectedMedium = 'g',

    /// NonMusical Sound Recording
    BibRecordKindRawValueNonMusicalSoundRecording = 'i',

    /// Musical Sound Recording
    BibRecordKindRawValueMusicalSoundRecording = 'j',

    /// Two-Dimensional Non-Projectable Graphic
    BibRecordKindRawValueTwoDimensionalNonProjectableGraphic = 'k',

    /// Computer File
    BibRecordKindRawValueComputerFile = 'm',

    /// Kit
    BibRecordKindRawValueKit = 'o',

    /// Mixed Materials
    BibRecordKindRawValueMixedMaterials = 'p',

    /// Three-Dimensional Artifact
    BibRecordKindRawValueThreeDimensionalArtifact = 'r',

    /// Manuscript LanguageMateral
    BibRecordKindRawValueManuscriptLanguageMateral = 't',
} NS_SWIFT_NAME(RecordKind);

#pragma mark - MARC 21 Categories

@implementation BibRecordKind (MARC21Categories)

- (BOOL)isClassificationKind {
    return [self rawValue] == BibRecordKindRawValueClassification;
}

- (BOOL)isBibliographicKind {
    uint8_t const rawValue = [self rawValue];
    static BibRecordKindRawValue const kinds[] = {
        BibRecordKindRawValueLanguageMaterial,
        BibRecordKindRawValueNotatedMusic,
        BibRecordKindRawValueManuscriptNotatedMusic,
        BibRecordKindRawValueCartographicMaterial,
        BibRecordKindRawValueManuscriptCartographicMaterial,
        BibRecordKindRawValueProjectedMedium,
        BibRecordKindRawValueNonMusicalSoundRecording,
        BibRecordKindRawValueMusicalSoundRecording,
        BibRecordKindRawValueTwoDimensionalNonProjectableGraphic,
        BibRecordKindRawValueComputerFile,
        BibRecordKindRawValueKit,
        BibRecordKindRawValueMixedMaterials,
        BibRecordKindRawValueThreeDimensionalArtifact,
        BibRecordKindRawValueManuscriptLanguageMateral
    };
    for (NSUInteger index = 0; index < sizeof(kinds); index += 1) {
        if (kinds[index] == rawValue) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark - MARC 21 Record Kinds

@implementation BibRecordKind (MARC21RecordKinds)

+ (BibRecordKind *)classification {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueClassification];
}
+ (BibRecordKind *)languageMaterial {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueLanguageMaterial];
}
+ (BibRecordKind *)notatedMusic {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueNotatedMusic];
}
+ (BibRecordKind *)manuscriptNotatedMusic {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueManuscriptNotatedMusic];
}
+ (BibRecordKind *)cartographicMaterial {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueCartographicMaterial];
}
+ (BibRecordKind *)manuscriptCartographicMaterial {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueManuscriptCartographicMaterial];
}
+ (BibRecordKind *)projectedMedium {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueProjectedMedium];
}
+ (BibRecordKind *)nonMusicalSoundRecording {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueNonMusicalSoundRecording];
}
+ (BibRecordKind *)musicalSoundRecording {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueMusicalSoundRecording];
}
+ (BibRecordKind *)twoDimensionalNonProjectableGraphic {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueTwoDimensionalNonProjectableGraphic];
}
+ (BibRecordKind *)computerFile {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueComputerFile];
}
+ (BibRecordKind *)kit {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueKit];
}
+ (BibRecordKind *)mixedMaterials {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueMixedMaterials];
}
+ (BibRecordKind *)threeDimensionalArtifact {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueThreeDimensionalArtifact];
}
+ (BibRecordKind *)manuscriptLanguageMateral {
    return [BibRecordKind recordKindWithRawValue:BibRecordKindRawValueManuscriptLanguageMateral];
}

- (NSString *)description {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *key = [[NSString alloc] initWithFormat:@"%c", [self rawValue]];
    return [bundle localizedStringForKey:key value:nil table:@"RecordKind"];
}

@end

#pragma mark - Internal Representation

@implementation _BibRecordKind

static NSCache *sFlyweightCache;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFlyweightCache = [[NSCache alloc] init];
        [sFlyweightCache setName:@"_BibRecordKindCache"];
    });
}

- (instancetype)initWithRawValue:(uint8_t)rawValue {
    NSNumber *const key = [[NSNumber alloc] initWithChar:rawValue];
    _BibRecordKind *const recordKind = [sFlyweightCache objectForKey:key];
    if (recordKind) {
        return recordKind;
    }
    switch (rawValue) {
        case BibRecordKindRawValueClassification:
        case BibRecordKindRawValueLanguageMaterial:
        case BibRecordKindRawValueNotatedMusic:
        case BibRecordKindRawValueManuscriptNotatedMusic:
        case BibRecordKindRawValueCartographicMaterial:
        case BibRecordKindRawValueManuscriptCartographicMaterial:
        case BibRecordKindRawValueProjectedMedium:
        case BibRecordKindRawValueNonMusicalSoundRecording:
        case BibRecordKindRawValueMusicalSoundRecording:
        case BibRecordKindRawValueTwoDimensionalNonProjectableGraphic:
        case BibRecordKindRawValueComputerFile:
        case BibRecordKindRawValueKit:
        case BibRecordKindRawValueMixedMaterials:
        case BibRecordKindRawValueThreeDimensionalArtifact:
        case BibRecordKindRawValueManuscriptLanguageMateral:
            if (self = [super initWithRawValue:rawValue]) {
                [sFlyweightCache setObject:self forKey:key];
            }
            return self;
        default:
            return nil;
    }
}

@end
