//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibClassification;
@class BibRecordField;

NS_ASSUME_NONNULL_BEGIN

/// A collection of information pertaining to some physical entity represented in the database.
NS_SWIFT_NAME(Record)
@interface BibRecord : NSObject

@property(nonatomic, readonly, copy) NSString *syntax;
@property(nonatomic, readonly, copy) NSString *schema;

/// The name of the database from which this record originates.
@property(nonatomic, readonly, copy) NSString *database;

/// A list of the raw data fields contained within this record.
@property(nonatomic, readonly, copy) NSArray<BibRecordField *> *fields;

/// The ISBN-10 value for the item represented by this record.
@property(nonatomic, readonly, nullable, copy) NSString *isbn10;

/// The ISBN-13 value for the item represented by this record.
@property(nonatomic, readonly, nullable, copy) NSString *isbn13;

/// A list of classifications applicable to the item represented by this record.
@property(nonatomic, readonly, copy) NSArray<BibClassification *> *classifications;

/// The title of the item represented by this record.
@property(nonatomic, readonly, copy) NSString *title;

/// The subtitle of the item represented by this record.
@property(nonatomic, readonly, nullable, copy) NSString *subtitle;

/// Create a record containing information from the given fields.
/// \param fields A list of raw data fields with which to populate the record.
- (instancetype)initWithFields:(NSArray<BibRecordField *> *)fields NS_SWIFT_NAME(init(fields:));

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
