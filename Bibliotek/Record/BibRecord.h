//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecordLeader;
@class BibRecordDirectoryEntry;
@class BibRecordControlField;
@class BibRecordDataField;
@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// \brief A collection of information pertaining to some item or entity organized using the MARC 21 standard.
/// \discussion MARC 21 records are comprised of a leader that contains basic metadata about the record itself, a set of
/// control fields storing semantic metadata about the record; and a set of data fields that provide the bibliographic
/// or other data describing the record's item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record)
@interface BibRecord : NSObject

/// A set of metadata positioned at the beginning of each record that describe its encoded structure.
@property (nonatomic, copy, readonly) BibRecordLeader *leader;

@property (nonatomic, copy, readonly) NSArray<BibRecordDirectoryEntry *> *directory;

/// A list of variable fields containing metadata relevant for processing the record.
@property (nonatomic, copy, readonly) NSArray<BibRecordControlField *> *controlFields;

/// A list of variable field containing bibliographic and other data about the item or entity represented by the record.
@property (nonatomic, copy, readonly) NSArray<BibRecordDataField *> *dataFields;

- (instancetype)initWithData:(NSData *)data;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
/// \param leader The leader metadata describing the record's encoded format and status.
/// \param controlFields A list of fields containing data pertaining to the processing of record data.
/// \param dataFields A list of fields containing bibliographic or other data describing an item or entity.
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
/// \discussion More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                 controlFields:(NSArray<BibRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibRecordDataField *> *)dataFields;

/// Determine whether or not the given MARC 21 record contains the same data as the receiver.
/// \param record The record with which the receiver should be compared.
/// \returns Returns \c YES if the given record and the receiver contain the same data.
- (BOOL)isEqualToRecord:(BibRecord *)record;

@end

NS_ASSUME_NONNULL_END
