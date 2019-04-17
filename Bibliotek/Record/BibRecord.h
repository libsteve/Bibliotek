//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"

@class BibRecordLeader;
@class BibRecordDirectoryEntry;
@protocol BibRecordField;

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

/// A list of objects describing details about the record or the entity it represents.
@property (nonatomic, copy, readonly) NSArray<id<BibRecordField>> *fields;

@property (class, nonatomic, readonly) NSDictionary<BibRecordFieldTag, Class> *recordSchema;

- (instancetype)initWithData:(NSData *)data;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
/// \param leader The leader metadata describing the record's encoded format and status.
/// \param directory A collection of metadata describing the location and semantic purpose of the record's fields.
/// \param fields A list of objects describing details about the record or the entity it represents.
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
/// \discussion More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                        fields:(NSArray<id<BibRecordField>> *)fields NS_DESIGNATED_INITIALIZER;

/// Create a MARC 21 record containing data from the given leader, control fields, and data fields.
/// \param leader The leader metadata describing the record's encoded format and status.
/// \param directory A collection of metadata describing the location and semantic purpose of record and data fields.
/// \returns Returns a valid MARC 21 record for some item or entity described by the given fields.
/// \discussion More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
- (instancetype)initWithLeader:(BibRecordLeader *)leader
                     directory:(NSArray<BibRecordDirectoryEntry *> *)directory
                          data:(NSData *)data;

/// Determine whether or not the given MARC 21 record contains the same data as the receiver.
/// \param record The record with which the receiver should be compared.
/// \returns Returns \c YES if the given record and the receiver contain the same data.
- (BOOL)isEqualToRecord:(BibRecord *)record;

+ (NSArray<BibRecord *> *)recordsWithData:(NSData *)data;

+ (NSArray<BibRecord *> *)recordsWithContentsOfFile:(NSString *)filePath;

+ (NSArray<BibRecord *> *)recordsWithContentsOfURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
