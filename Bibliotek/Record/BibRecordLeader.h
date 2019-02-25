//
//  BibRecordLeader.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

NS_ASSUME_NONNULL_BEGIN

/// The required field positioned at the beginning of each record.
/// \discussion The record leader provides information about the layout of data within a record.
/// Such information includes the total size in memory of the record, the layout of fields' tags and indicators,
/// and other miscellaneous metadata.
///
/// More information about the MARC 21 leader can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader.
NS_SWIFT_NAME(Record.Leader)
@interface BibRecordLeader : NSObject

/// The raw string representation of the leader data.
@property (nonatomic, readonly) NSString *stringValue;

@property (nonatomic, assign, readonly) NSUInteger recordLength;

@property (nonatomic, readonly) NSString *recordStatus;

@property (nonatomic, readonly) BibRecordKind recordType;

@property (nonatomic, readonly) BibRecordCharacterCodingScheme characterCodingScheme;

@property (nonatomic, assign, readonly) NSUInteger recordBodyLocation;

- (instancetype)initWithData:(NSData *)data;

/// Create the leader for a MARC 21 record.
/// \param stringValue The raw string representation of the leader data.
/// \returns Returns a new record leader backed by the given string value.
/// \discussion More information about the MARC 21 leader can be found in the Library of Congress's
/// documentation on MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader.
- (instancetype)initWithString:(NSString *)stringValue NS_DESIGNATED_INITIALIZER;

/// Determine whether or not the given leader describes the same MARC 21 record as the receiver.
/// \param leader The leader with which the receiver should be compared.
/// \returns Returns \c YES if the given leader and the receiver describe the same MARC 21 record.
- (BOOL)isEqualToLeader:(BibRecordLeader *)leader;

@end

NS_ASSUME_NONNULL_END
