//
//  BibRecordConstants.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

/// http://www.loc.gov/standards/sourcelist/classification.html
typedef NSString *BibClassificationScheme NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(ClassificationScheme);

/// http://www.loc.gov/marc/languages/langhome.html
typedef NSString *BibMarcLanguageCode NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(MarcLanguageCode);

/// http://www.loc.gov/marc/organizations/orgshome.html
typedef NSString *BibMarcOrganization NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(MarcOrganization);

#pragma mark - Record Status

typedef NSString *BibRecordStatus NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.Status);

extern BibRecordStatus const BibRecordStatusIncreaseInEncodingLevel;
extern BibRecordStatus const BibRecordStatusRevised;
extern BibRecordStatus const BibRecordStatusDeleted;
extern BibRecordStatus const BibRecordStatusNew;
extern BibRecordStatus const BibRecordStatusIncreaseInEncodingLevelFromPrePublication;

#pragma mark - Record Kind

typedef NSString *BibRecordKind NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.Kind);

extern BOOL BibRecordKindIsClassification(BibRecordKind recordKind) NS_REFINED_FOR_SWIFT;
extern BOOL BibRecordKindIsBibliographic(BibRecordKind recordKind) NS_REFINED_FOR_SWIFT;
extern NSString *BibRecordKindDescription(BibRecordKind recordKind) NS_REFINED_FOR_SWIFT;

#pragma mark Classification

extern BibRecordKind const BibRecordKindClassification;

#pragma mark Bibliographic

extern BibRecordKind const BibRecordKindLanguageMaterial;
extern BibRecordKind const BibRecordKindNotatedMusic;
extern BibRecordKind const BibRecordKindManuscriptNotatedMusic;
extern BibRecordKind const BibRecordKindCartographicMaterial;
extern BibRecordKind const BibRecordKindManuscriptCartographicMaterial;
extern BibRecordKind const BibRecordKindProjectedMedium;
extern BibRecordKind const BibRecordKindNonMusicalSoundRecording;
extern BibRecordKind const BibRecordKindMusicalSoundRecording;
extern BibRecordKind const BibRecordKindTwoDimensionalNonProjectableGraphic;
extern BibRecordKind const BibRecordKindComputerFile;
extern BibRecordKind const BibRecordKindKit;
extern BibRecordKind const BibRecordKindMixedMaterials;
extern BibRecordKind const BibRecordKindThreeDimensionalArtifact;
extern BibRecordKind const BibRecordKindManuscriptLanguageMateral;

#pragma mark - Character Coding Scheme

typedef NSString *BibRecordCharacterCodingScheme NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.CharacterCodingScheme);

extern BibRecordCharacterCodingScheme const BibRecordCharacterCodingSchemeMarc8;
extern BibRecordCharacterCodingScheme const BibRecordCharacterCodingSchemeUnicode;

extern NSString *BibRecordCharacterCodingSchemeDescription(BibRecordCharacterCodingScheme characterCodingScheme) NS_REFINED_FOR_SWIFT;

#pragma mark - Edition Kind

typedef NS_ENUM(NSUInteger, BibEditionKind) {
    BibEditionKindFull = '0',
    BibEditionKindAbridged = '1',
    BibEditionKindSpecified = '7',
    BibEditionKindOther = '8'
} NS_SWIFT_NAME(EditionKind);

extern NSString *BibEditionKindDescription(BibEditionKind editionKind) NS_REFINED_FOR_SWIFT;

#pragma mark - Record Field Tags

/// An code identifying the semantic purpose of a record field.
typedef NSString *BibRecordFieldTag NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldTag);

#pragma mark - Record Field Indicator

typedef NSString *BibRecordFieldIndicator NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldIndicator);

extern BibRecordFieldIndicator const BibRecordFieldIndicatorBlank;

#pragma mark - Record Field Code

typedef NSString *BibRecordSubfieldCode NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.SubfieldCode);

NS_ASSUME_NONNULL_END
