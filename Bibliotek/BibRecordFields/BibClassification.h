//
//  BibClassification.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConnection.h"

@class BibRecordField;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Classification)
@interface BibClassification : NSObject <NSMutableCopying>

@property(nonatomic, readonly, strong) BibClassificationSystem system;
@property(nonatomic, readonly, copy) NSString *classification;
@property(nonatomic, readonly, copy, nullable) NSString *item;
@property(nonatomic, readonly, assign, getter=isOfficial) BOOL official;

- (instancetype)initWithClassification:(NSString *)classification item:(nullable NSString *)item system:(BibClassificationSystem)system NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(_:item:system:));

- (nullable instancetype)initWithField:(BibRecordField *)field NS_SWIFT_NAME(init(field:));

+ (nullable instancetype)classificationWithField:(BibRecordField *)field NS_SWIFT_UNAVAILABLE("Use init(field:)");

- (BOOL)isEqualToClassification:(BibClassification *)classification NS_SWIFT_NAME(isEqual(to:));
- (BOOL)isSimilarToClassification:(BibClassification *)classification NS_SWIFT_NAME(isSimilar(to:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Mutable Classification

NS_SWIFT_NAME(MutableClassification)
@interface BibMutableClassification : BibClassification

@property(nonatomic, readwrite, strong) BibClassificationSystem system;
@property(nonatomic, readwrite, copy) NSString *classification;
@property(nonatomic, readwrite, copy, nullable) NSString *item;
@property(nonatomic, readwrite, assign, getter=isOfficial) BOOL official;

@end

NS_ASSUME_NONNULL_END
