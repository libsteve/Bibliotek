//
//  BibClassificationRecordClassificationNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"
#import "BibRecordDataField.h"

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/classification/cdx53.html
NS_SWIFT_NAME(ClassificationRecord.ClassificationNumber)
@interface BibClassificationRecordClassificationNumber : BibRecordDataField

@property (nonatomic, copy, readonly, nullable) NSString *tableIdentifier;

@property (nonatomic, copy, readonly) NSArray<NSString *> *classificationNumbers;

@property (nonatomic, copy, readonly) NSArray<NSString *> *captions;

@property (class, nonatomic, strong, readonly) BibRecordFieldTag recordFieldTag;

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
