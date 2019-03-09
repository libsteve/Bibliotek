//
//  BibBibliographicTitleStatement.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/bibliographic/bd245.html
@interface BibBibliographicTitleStatement : BibRecordDataField

/// The proper title of the represented work.
@property (nonatomic, copy, readonly) NSString *title;

/// The amount of initial characters in the @c title that should be ingored for sorting purposes.
@property (nonatomic, assign, readonly) NSUInteger nonfillingCharacterCount;

/// The subtitles, alternate titles, and other title-like information of the represented work,
@property (nonatomic, copy, readonly, nullable) NSString *subtitle;

/// A statement listing the people or entities involved in the creation of the represented work.
@property (nonatomic, copy, readonly, nullable) NSString *author;

/// A value indicating the represented work's location within a sequential collection of other works.
///
/// For example: "Part 1", "Section A", "Book 1", etc.
@property (nonatomic, copy, readonly, nullable) NSString *sectionIndex;

/// A value indentifying the represented work within a non-sequential collection of other works.
///
/// For example: "Teacher's Edition", "Remastered Edition", "Workbook", etc.
@property (nonatomic, copy, readonly, nullable) NSString *sectionName;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
