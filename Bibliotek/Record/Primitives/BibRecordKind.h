//
//  BibRecordKind.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The type of data represented by a MARC 21 record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@interface BibRecordKind : NSObject

@property (nonatomic, assign, readonly) uint8_t rawValue;

- (nullable instancetype)initWithRawValue:(uint8_t)rawValue;

+ (nullable instancetype)recordKindWithRawValue:(uint8_t)rawValue NS_SWIFT_UNAVAILABLE("Use init(rawValue:)");

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Equality

@interface BibRecordKind (Equality)

- (BOOL)isEqualToRecordKind:(BibRecordKind *)recordKind;

@end

#pragma mark - MARC 21 Categories

@interface BibRecordKind (MARC21Categories)

/// Does a record marked with this kind represent classification information?
@property (nonatomic, readonly) BOOL isClassificationKind;

/// Does a record marked with this kind represent bibliographic information?
@property (nonatomic, readonly) BOOL isBibliographicKind;

@end

#pragma mark - MARC 21 Record Kinds

@interface BibRecordKind (MARC21RecordKinds)

/// Classification
@property (class, nonatomic, readonly) BibRecordKind *classification;

/// Language Material
@property (class, nonatomic, readonly) BibRecordKind *languageMaterial;

/// Notated Music
@property (class, nonatomic, readonly) BibRecordKind *notatedMusic;

/// Manuscript Notated Music
@property (class, nonatomic, readonly) BibRecordKind *manuscriptNotatedMusic;

/// Cartographic Material
@property (class, nonatomic, readonly) BibRecordKind *cartographicMaterial;

/// Manuscript Cartographic Material
@property (class, nonatomic, readonly) BibRecordKind *manuscriptCartographicMaterial;

/// Projected Medium
@property (class, nonatomic, readonly) BibRecordKind *projectedMedium;

/// NonMusical Sound Recording
@property (class, nonatomic, readonly) BibRecordKind *nonMusicalSoundRecording;

/// Musical Sound Recording
@property (class, nonatomic, readonly) BibRecordKind *musicalSoundRecording;

/// Two-Dimensional Non-Projectable Graphic
@property (class, nonatomic, readonly) BibRecordKind *twoDimensionalNonProjectableGraphic;

/// Computer File
@property (class, nonatomic, readonly) BibRecordKind *computerFile;

/// Kit
@property (class, nonatomic, readonly) BibRecordKind *kit;

/// Mixed Materials
@property (class, nonatomic, readonly) BibRecordKind *mixedMaterials;

/// Three-Dimensional Artifact
@property (class, nonatomic, readonly) BibRecordKind *threeDimensionalArtifact;

/// Manuscript LanguageMateral
@property (class, nonatomic, readonly) BibRecordKind *manuscriptLanguageMateral;

@end

NS_ASSUME_NONNULL_END
