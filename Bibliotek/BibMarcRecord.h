//
//  BibMarcRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/18/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibRecord+Protocols.h"
#import <Foundation/Foundation.h>

@class BibClassification;
@class BibRecordField;
@class BibTitleStatement;

NS_ASSUME_NONNULL_BEGIN

/// A collection of information pertaining to some physical entity represented in a MARC database.
NS_SWIFT_NAME(MarcRecord)
@interface BibMarcRecord : NSObject <BibRecord>

@property(nonatomic, readonly, copy) NSString *syntax;
@property(nonatomic, readonly, copy) NSString *schema;

/// A list of the raw data fields contained within this record.
@property(nonatomic, readonly, copy) NSArray<BibRecordField *> *fields;

/// Create a record containing information from the given fields.
/// \param fields A list of raw data fields with which to populate the record.
- (instancetype)initWithFields:(NSArray<BibRecordField *> *)fields NS_SWIFT_NAME(init(fields:));

@end

NS_ASSUME_NONNULL_END
