//
//  BibBibliographicSubjectHeading.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicSubjectHeadingThesaurus) {
    BibBibliographicSubjectHeadingThesaurusLibraryOfCongress = '0',
    BibBibliographicSubjectHeadingThesaurusLibraryOfCongressChildrensLiterature = '1',
    BibBibliographicSubjectHeadingThesaurusMedical = '2',
    BibBibliographicSubjectHeadingThesaurusNationalAgriculturalLibrary = '3',
    BibBibliographicSubjectHeadingThesaurusUnspecified = '4',
    BibBibliographicSubjectHeadingThesaurusCanadian = '5',
    BibBibliographicSubjectHeadingThesaurusFrench = '6',
    BibBibliographicSubjectHeadingThesaurusOther = '7'
} NS_SWIFT_NAME(BibliographicSubjectHeading.Thesaurus);

/// http://www.loc.gov/marc/bibliographic/bd6xx.html
NS_SWIFT_NAME(BibliographicSubjectHeading)
@protocol BibBibliographicSubjectHeading <NSObject>

@property (nonatomic, assign, readonly) BibBibliographicSubjectHeadingThesaurus thesaurus;

@property (nonatomic, copy, readonly) NSString *term;

@property (nonatomic, copy, readonly) NSArray<NSString *> *formSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *generalSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *chronologicalSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *geographicSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *realWorldObjectIdentifiers;

@property (nonatomic, copy, readonly, nullable) NSString *source;

@property (class, nonatomic, strong, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
