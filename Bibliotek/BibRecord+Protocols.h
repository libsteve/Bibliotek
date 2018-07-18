//
//  BibRecord+Protocols.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/18/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibClassification;
@class BibRecordField;
@class BibTitleStatement;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RecordStore)
@protocol BibRecord <NSObject, NSCopying, NSMutableCopying, NSSecureCoding>

/// The name of the database from which this record originates.
@property(nonatomic, readonly, copy) NSString *database;

/// The ISBN-10 value for the item represented by this record.
@property(nonatomic, readonly, nullable, copy) NSString *isbn10;

/// The ISBN-13 value for the item represented by this record.
@property(nonatomic, readonly, nullable, copy) NSString *isbn13;

/// A list of classifications applicable to the item represented by this record.
@property(nonatomic, readonly, copy) NSArray<BibClassification *> *classifications;

/// The title of the item represented by this record.
@property(nonatomic, readonly, copy) NSString *title;

/// A list of subtitles applicable to the item represented by this record.
@property(nonatomic, readonly, copy) NSArray<NSString *> *subtitles;

/// The authors of the represented item.
@property(nonatomic, readonly, copy) NSArray<NSString *> *authors;

/// A list the people involved in creating the represented item, along with their respective roles.
@property(nonatomic, readonly, copy) NSArray<NSString *> *contributors;

/// Edition descriptions applicable to the represented item.
@property(nonatomic, readonly, copy) NSArray<NSString *> *editions;

/// A list of subjects to which the represented item belongs.
@property(nonatomic, readonly, copy) NSArray<NSString *> *subjects;

/// A list of statements describing the represented item.
@property(nonatomic, readonly, copy) NSArray<NSString *> *summaries;

@end

NS_SWIFT_NAME(MutableRecordStore)
@protocol BibMutableRecord <BibRecord>

/// The name of the database from which this record originates.
@property(nonatomic, readwrite, copy) NSString *database;

/// The ISBN-10 value for the item represented by this record.
@property(nonatomic, readwrite, nullable, copy) NSString *isbn10;

/// The ISBN-13 value for the item represented by this record.
@property(nonatomic, readwrite, nullable, copy) NSString *isbn13;

/// A list of classifications applicable to the item represented by this record.
@property(nonatomic, readwrite, copy) NSArray<BibClassification *> *classifications;

/// The title of the item represented by this record.
@property(nonatomic, readwrite, copy) NSString *title;

/// A list of subtitles applicable to the item represented by this record.
@property(nonatomic, readwrite, copy) NSArray<NSString *> *subtitles;

/// The authors of the represented item.
@property(nonatomic, readwrite, copy) NSArray<NSString *> *authors;

/// A list the people involved in creating the represented item, along with their respective roles.
@property(nonatomic, readwrite, copy) NSArray<NSString *> *contributors;

/// Edition descriptions applicable to the represented item.
@property(nonatomic, readwrite, copy) NSArray<NSString *> *editions;

/// A list of subjects to which the represented item belongs.
@property(nonatomic, readwrite, copy) NSArray<NSString *> *subjects;

/// A list of statements describing the represented item.
@property(nonatomic, readwrite, copy) NSArray<NSString *> *summaries;

@end

NS_ASSUME_NONNULL_END
