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

typedef NSString *BibRecordKind NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.Kind);

extern BibRecordKind const BibRecordKindClassification;
extern BibRecordKind const BibRecordKindBibliographic;

typedef NSString *BibRecordCharacterCodingScheme NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.CharacterCodingScheme);

extern BibRecordCharacterCodingScheme const BibRecordCharacterCodingSchemeMarc8;
extern BibRecordCharacterCodingScheme const BibRecordCharacterCodingSchemeUnicode;

typedef NS_ENUM(NSUInteger, BibEditionKind) {
    BibEditionKindFull = '0',
    BibEditionKindAbridged = '1',
    BibEditionKindSpecified = '7',
    BibEditionKindOther = '8'
} NS_SWIFT_NAME(EditionKind);

#pragma mark - Record Field Tags

/// An code identifying the semantic purpose of a record field.
typedef NSString *BibRecordFieldTag NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldTag);

#pragma mark - Record Field Indicator

typedef NSString *BibRecordFieldIndicator NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.FieldIndicator);

extern BibRecordFieldIndicator const BibRecordFieldIndicatorBlank;

#pragma mark - Record Field Code

typedef NSString *BibRecordSubfieldCode NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.SubfieldCode);

NS_ASSUME_NONNULL_END
