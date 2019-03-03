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

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, assign, readonly) NSUInteger nonfillingCharacterCount;

@property (nonatomic, copy, readonly, nullable) NSString *subtitle;

@property (nonatomic, copy, readonly, nullable) NSString *author;

@property (nonatomic, copy, readonly, nullable) NSString *sectionNumber;

@property (nonatomic, copy, readonly, nullable) NSString *sectionName;

@property (nonatomic, copy, readonly, nullable) NSString *version;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
