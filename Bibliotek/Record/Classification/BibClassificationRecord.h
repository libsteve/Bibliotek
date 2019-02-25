//
//  BibClassificationRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"
#import "BibRecord.h"

@class BibClassificationRecordMetadata;
@class BibClassificationRecordClassificationNumber;
@class BibClassificationRecordClassificationScheme;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ClassificationRecord)
@interface BibClassificationRecord : BibRecord

@property (nonatomic, strong, readonly) BibClassificationRecordMetadata *metadata;

@property (nonatomic, strong, readonly) BibClassificationRecordClassificationNumber *classificationNumber;

@property (nonatomic, strong, readonly) BibClassificationRecordClassificationScheme *classificationScheme;

@end

extern BibRecordFieldTag const BibRecordFieldTagClassificationRecordMetadata;
extern BibRecordFieldTag const BibRecordFieldTagClassificationRecordClassificationScheme;
extern BibRecordFieldTag const BibRecordFieldTagClassificationRecordClassificationNumber;

NS_ASSUME_NONNULL_END
