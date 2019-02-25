//
//  BibClassificationRecordMetadata.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibClassificationRecordKind) {
    BibClassificationRecordKindSchedule = 'a',
    BibClassificationRecordKindTable = 'b',
    BibClassificationRecordKindIndexTerm = 'c'
} NS_SWIFT_NAME(ClassificationRecord.Kind);

typedef NS_ENUM(NSUInteger, BibClassificationRecordNumberKind) {
    BibClassificationRecordNumberKindSingle = 'a',
    BibClassificationRecordNumberKindDefinedSpan = 'b',
    BibClassificationRecordNumberKindSummarySpan = 'c',
    BibClassificationRecordNumberKindNone = 'n'
} NS_SWIFT_NAME(ClassificationRecord.NumberKind);

typedef NS_ENUM(NSUInteger, BibClassificationRecordValidity) {
    BibClassificationRecordValidityValid = 'a',
    BibClassificationRecordValidityFirstSpanNumberInvalid = 'b',
    BibClassificationRecordValidityLastSpanNumberInvalid = 'c',
    BibClassificationRecordValidityInvalid = 'd',
    BibClassificationRecordValidityObsolete = 'e',
    BibClassificationRecordValidityNone = 'n'
} NS_SWIFT_NAME(ClassificationRecord.Validity);

typedef NS_ENUM(NSUInteger, BibClassificationRecordStandardization) {
    BibClassificationRecordStandardizationEstablished = 'a',
    BibClassificationRecordStandardizationProvisional = 'c'
} NS_SWIFT_NAME(ClassificationRecord.Standardization);

/// http://www.loc.gov/marc/classification/cd008.html
NS_SWIFT_NAME(ClassificationRecord.Metadata)
@interface BibClassificationRecordMetadata : NSObject

@property (nonatomic, strong, readonly) NSDate *creationDate;

@property (nonatomic, assign, readonly) BibClassificationRecordKind recordKind;

@property (nonatomic, assign, readonly) BibClassificationRecordNumberKind classificationNumberKind;

@property (nonatomic, assign, readonly) BibClassificationRecordValidity recordValidity;

@property (nonatomic, assign, readonly) BibClassificationRecordStandardization standardization;

@property (class, nonatomic, strong, readonly) BibRecordFieldTag recordFieldTag;

- (instancetype)initWithContent:(NSString *)content NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
