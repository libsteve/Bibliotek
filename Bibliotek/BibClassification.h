//
//  BibClassification.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConnection.h"

@class BibMarcRecordField;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Classification)
@interface BibClassification : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

/// The system of classification used to catolog this item.
@property(nonatomic, readonly, strong) BibClassificationSystem system;

/// The base classification number for the item.
@property(nonatomic, readonly, copy) NSString *classification;

/// The item number differentiating this entry from others.
@property(nonatomic, readonly, copy, nullable) NSString *item;

/// Is this classification the official one used by the Library of Congress?
@property(nonatomic, readonly, assign, getter=isOfficial) BOOL official;

- (instancetype)initWithClassification:(NSString *)classification item:(nullable NSString *)item system:(BibClassificationSystem)system NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(_:item:system:));

- (nullable instancetype)initWithField:(BibMarcRecordField *)field NS_SWIFT_NAME(init(field:));

+ (nullable instancetype)classificationWithField:(BibMarcRecordField *)field NS_SWIFT_UNAVAILABLE("Use init(field:)");

/// Determine whether or not the given classification is equivalent to this classification.
/// \param classification The classification with which equality should be determined.
- (BOOL)isEqualToClassification:(BibClassification *)classification NS_SWIFT_NAME(isEqual(to:));

/// Determine whether or not the given classification is similar to this classification,
/// i.e. whether or not the systems and base classifications are the same.
/// \param classification The classification with which similarity should be determined.
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
