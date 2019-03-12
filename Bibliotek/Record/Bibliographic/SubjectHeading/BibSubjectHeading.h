//
//  BibSubjectHeading.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibSubjectHeadingThesaurus) {
    BibSubjectHeadingThesaurusLibraryOfCongress = '0',
    BibSubjectHeadingThesaurusLibraryOfCongressChildrensLiterature = '1',
    BibSubjectHeadingThesaurusMedical = '2',
    BibSubjectHeadingThesaurusNationalAgriculturalLibrary = '3',
    BibSubjectHeadingThesaurusUnspecified = '4',
    BibSubjectHeadingThesaurusCanadian = '5',
    BibSubjectHeadingThesaurusFrench = '6',
    BibSubjectHeadingThesaurusOther = '7'
} NS_SWIFT_NAME(SubjectHeadingThesaurus);

/// http://www.loc.gov/marc/bibliographic/bd6xx.html
NS_SWIFT_NAME(SubjectHeading)
@protocol BibSubjectHeading <NSObject>

@property (nonatomic, assign, readonly) BibSubjectHeadingThesaurus thesaurus;

@property (nonatomic, copy, readonly) NSString *term;

@property (nonatomic, copy, readonly) NSArray<NSString *> *formSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *generalSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *chronologicalSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *geographicSubdivision;

@property (nonatomic, copy, readonly) NSArray<NSString *> *realWorldObjectIdentifiers;

@property (nonatomic, copy, readonly, nullable) NSString *source;

@end

NS_ASSUME_NONNULL_END
