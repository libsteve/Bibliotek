//
//  BibBibliographicEditionStatement.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/bibliographic/bd250.html
NS_SWIFT_NAME(BibliographicEditionStatement)
@interface BibBibliographicEditionStatement : BibRecordDataField

@property (nonatomic, copy, readonly) NSString *content;

@property (nonatomic, copy, readonly, nullable) NSString *detail;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
