//
//  BibMarcRecordLeader.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The required field positioned at the beginning of each record.
/// \discussion The record leader provides information about the layout of data within a record.
/// Such information includes the total size in memory of the record, the layout of fields' tags and indicators,
/// and other miscellaneous metadata.
///
/// More information about the MARC 21 leader can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader.
NS_SWIFT_NAME(MarcRecord.Leader)
@interface BibMarcRecordLeader : NSObject <NSSecureCoding>

/// The raw string representation of the leader data.
@property (nonatomic, copy, readonly) NSString *stringValue NS_SWIFT_NAME(rawValue);

@property (nonatomic, assign, readonly) NSInteger recordLength;
@property (nonatomic, copy, readonly) NSString *recordStatus;
@property (nonatomic, copy, readonly) NSString *recordType;
@property (nonatomic, copy, readonly) NSString *twoCharacterField;
@property (nonatomic, copy, readonly) NSString *characterCodingScheme;
@property (nonatomic, assign, readonly) NSInteger indicatorCount;
@property (nonatomic, assign, readonly) NSInteger subfieldCodeLength;
@property (nonatomic, assign, readonly) NSInteger dataBaseAddress;
@property (nonatomic, copy, readonly) NSString *threeCharacterField;
@property (nonatomic, copy, readonly) NSString *entryMap;

/// Create a valid leader for a MARC 21 record.
/// \param stringValue The raw string representation of the leader data.
/// \returns Returns a new record leader backed by the given string value.
/// \pre The given string must contain well-formed leader data according to the official specifications.
/// \discussion More information about the MARC 21 leader can be found in the Library of Congress's
/// documentation on MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader.
- (nullable instancetype)initWithString:(NSString *)stringValue NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(rawValue:));

/// Create a valid leader for a MARC 21 record.
/// \param stringValue The raw string representation of the leader data.
/// \returns Returns a new record leader backed by the given string value.
/// \pre The given string must contain well-formed leader data according to the official specifications.
/// \discussion More information about the MARC 21 leader can be found in the Library of Congress's
/// documentation on MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html#leader.
+ (nullable instancetype)leaderWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(rawValue:)");

/// Determine whether or not the given leader describes the same MARC 21 record as the receiver.
/// \param leader The leader with which the receiver should be compared.
/// \returns Returns \c YES if the given leader and the receiver describe the same MARC 21 record.
- (BOOL)isEqualToLeader:(BibMarcRecordLeader *)leader;

@end

NS_ASSUME_NONNULL_END
