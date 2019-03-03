//
//  BibClassificationRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecord.h"
#import "BibRecordConstants.h"

@class BibClassificationRecordMetadata;
@class BibClassificationRecordClassificationNumber;
@class BibClassificationRecordClassificationScheme;

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/classification/
NS_SWIFT_NAME(ClassificationRecord)
@interface BibClassificationRecord : BibRecord

@property (nonatomic, strong, readonly) BibClassificationRecordMetadata *metadata;

@property (nonatomic, strong, readonly) BibClassificationRecordClassificationNumber *classificationNumber;

@property (nonatomic, strong, readonly) BibClassificationRecordClassificationScheme *classificationScheme;

@end

NS_ASSUME_NONNULL_END
