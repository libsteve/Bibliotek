//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMetadata.h"

@class BibControlField;
@class BibContentField;

NS_ASSUME_NONNULL_BEGIN

/// \brief A collection of information pertaining to some item or entity organized using the MARC 21 standard.
/// \discussion MARC 21 records are comprised of a leader that contains basic metadata about the record itself, a set of
/// control fields storing semantic metadata about the record; and a set of data fields that provide the bibliographic
/// or other data describing the record's item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
@interface BibRecord : NSObject

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@property (nonatomic, assign, readonly) BibRecordKind kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readonly) BibRecordStatus status;

@property (nonatomic, copy, readonly) BibMetadata *metadata;

@property (nonatomic, copy, readonly) NSArray<BibControlField *> *controlFields;

@property (nonatomic, copy, readonly) NSArray<BibContentField *> *contentFields;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
///
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
/// \discussion More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
- (instancetype)initWithKind:(BibRecordKind)kind
                      status:(BibRecordStatus)status
                    metadata:(BibMetadata *)metadata
               controlFields:(NSArray<BibControlField *> *)controlFields
               contentFields:(NSArray<BibContentField *> *)contentFields NS_DESIGNATED_INITIALIZER;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
///
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
/// \discussion More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
+ (instancetype)recordWithKind:(BibRecordKind)kind
                        status:(BibRecordStatus)status
                      metadata:(BibMetadata *)metadata
                 controlFields:(NSArray<BibControlField *> *)controlFields
                 contentFields:(NSArray<BibContentField *> *)contentFields
    NS_SWIFT_UNAVAILABLE("Use init(kind:status:controlFields:contentFields:");

@end

#pragma mark - Copying

@interface BibRecord (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibRecord (Equality)

/// Determine whether or not the given MARC 21 record contains the same data as the receiver.
/// \param record The record with which the receiver should be compared.
/// \returns Returns \c YES if the given record and the receiver contain the same data
- (BOOL)isEqualToRecord:(BibRecord *)record;

@end

#pragma mark - Mutable

@interface BibMutableRecord : BibRecord

/// The type of data represented by the record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
@property (nonatomic, assign, readwrite) BibRecordKind kind;

/// The record's current status in the database it was fetched from.
@property (nonatomic, assign, readwrite) BibRecordStatus status;

@property (nonatomic, copy, readwrite) BibMetadata *metadata;

@property (nonatomic, copy, readwrite) NSArray<BibControlField *> *controlFields;

@property (nonatomic, copy, readwrite) NSArray<BibContentField *> *contentFields;

@end

NS_ASSUME_NONNULL_END
