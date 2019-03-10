//
//  BibBibliographicTopicalSubjectHeading.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibBibliographicSubjectHeading.h"
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicSubjectHeadingTopicalLevel) {
    BibBibliographicSubjectHeadingTopicalLevelNotProvided = ' ',
    BibBibliographicSubjectHeadingTopicalLevelUnspecified = '0',
    BibBibliographicSubjectHeadingTopicalLevelPrimary = '1',
    BibBibliographicSubjectHeadingTopicalLevelSecondary = '2'
} NS_SWIFT_NAME(BibliographicTopicalSubjectHeading.Level);

/// http://www.loc.gov/marc/bibliographic/bd650.html
NS_SWIFT_NAME(BibliographicTopicalSubjectHeading)
@interface BibBibliographicTopicalSubjectHeading : BibRecordDataField <BibBibliographicSubjectHeading>

@end

NS_ASSUME_NONNULL_END
