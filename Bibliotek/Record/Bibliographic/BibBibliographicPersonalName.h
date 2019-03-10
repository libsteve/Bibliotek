//
//  BibBibliographicPersonalName.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/10/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordDataField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibBibliographicPersonalNameKind) {
    BibBibliographicPersonalNameKindForename = '0',
    BibBibliographicPersonalNameKindSurname = '1',
    BibBibliographicPersonalNameKindFamilyName = '3'
} NS_SWIFT_NAME(BibliographicPersonalName.Kind);

/// - http://www.loc.gov/marc/bibliographic/bd100.html
/// - http://www.loc.gov/marc/bibliographic/bdx00.html
NS_SWIFT_NAME(BibliographicPersonalName)
@interface BibBibliographicPersonalName : BibRecordDataField

@property (nonatomic, assign, readonly) BibBibliographicPersonalNameKind kind;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly, nullable) NSString *numeration;

@property (nonatomic, copy, readonly, nullable) NSString *title;

@property (nonatomic, copy, readonly, nullable) NSString *dates;

@property (nonatomic, copy, readonly) NSArray<NSString *> *relationTerms;

@property (nonatomic, copy, readonly) NSArray<NSString *> *attributionQualifiers;

@property (nonatomic, copy, readonly, nullable) NSString *fullerName;

@property (nonatomic, copy, readonly, nullable) NSString *affiliation;

@property (nonatomic, copy, readonly) NSArray<NSString *> *relationCodes;

@property (class, nonatomic, readonly) BibRecordFieldTag recordFieldTag;

@end

NS_ASSUME_NONNULL_END
