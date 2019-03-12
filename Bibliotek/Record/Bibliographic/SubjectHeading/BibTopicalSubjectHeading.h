//
//  BibTopicalSubjectHeading.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibSubjectHeading.h"
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibTopicalSubjectHeadingLevel) {
    BibTopicalSubjectHeadingLevelNotProvided = ' ',
    BibTopicalSubjectHeadingLevelUnspecified = '0',
    BibTopicalSubjectHeadingLevelPrimary = '1',
    BibTopicalSubjectHeadingLevelSecondary = '2'
} NS_SWIFT_NAME(TopicalSubjectHeading.Level);

/// http://www.loc.gov/marc/bibliographic/bd650.html
NS_SWIFT_NAME(TopicalSubjectHeading)
@interface BibTopicalSubjectHeading : BibRecordDataField <BibSubjectHeading>

@property (class, nonatomic, strong, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
