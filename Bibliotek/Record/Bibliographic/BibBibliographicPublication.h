//
//  BibBibliographicPublication.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

@class BibBibliographicPublicationInformation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicPublicationSequenceKind) {
    BibBibliographicPublicationSequenceKindNone = ' ',
    BibBibliographicPublicationSequenceKindIntervening = '2',
    BibBibliographicPublicationSequenceKindCurrent = '3'
} NS_SWIFT_NAME(BibliographicPublication.SequenceKind);

/// http://www.loc.gov/marc/bibliographic/bd260.html
NS_SWIFT_NAME(BibliographicPublication)
@interface BibBibliographicPublication : BibRecordDataField

@property (nonatomic, copy, readonly) NSString *statement;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
