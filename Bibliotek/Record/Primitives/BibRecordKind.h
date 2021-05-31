//
//  BibRecordKind.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>

NS_ASSUME_NONNULL_BEGIN

/// The type of data represented by a MARC 21 record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this value to determine how tags and subfield codes should be used to interpret a record's content.
BIB_SWIFT_BRIDGE(RecordKind)
@interface BibRecordKind : NSObject <NSCopying>

/// The raw character value used in a record's leader to indicate the record's kind.
@property (nonatomic, assign, readonly) uint8_t rawValue;

/// Create a \c BibRecordKind instance using the given byte.
///
/// \param rawValue The character value in a record's leader that indicates a record's kind.
- (nullable instancetype)initWithRawValue:(uint8_t)rawValue;

/// Create a \c BibRecordKind instance using the given byte.
///
/// \param rawValue The character value in a record's leader that indicates a record's kind.
/// \returns An instance of \c BibRecordKind when given a \c rawValue representing a known record kind.
+ (nullable instancetype)recordKindWithRawValue:(uint8_t)rawValue NS_SWIFT_UNAVAILABLE("Use init(rawValue:)");

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Equality

@interface BibRecordKind (Equality)

/// Is the given record kind equivalent to the receiver?
///
/// \param recordKind The record kind with which the receiver should be compared.
/// \returns Returns \c YES if the given record kind and the receiver are equivalent.
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

/// Non-Musical Sound Recording
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

/// Manuscript Language Material
@property (class, nonatomic, readonly) BibRecordKind *manuscriptLanguageMaterial;

@end

NS_ASSUME_NONNULL_END
