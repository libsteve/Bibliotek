//
//  BibMarcRecordLeader.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// \brief A required field positioned at the beginning of each record.
/// \discussion The record leader provides information about the layout of data within each record.
/// Such information includes the total size in memory of the record, the layout of fields' tags and indicators,
/// and other miscellaneous metadata.
///
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
@interface BibMarcRecordLeader : NSObject <NSSecureCoding>

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

- (nullable instancetype)initWithString:(NSString *)stringValue NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(rawValue:));

+ (nullable instancetype)leaderWithString:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(rawValue:)");

@end

NS_ASSUME_NONNULL_END
