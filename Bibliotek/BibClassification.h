//
//  BibClassification.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *BibClassificationSystem NS_STRING_ENUM NS_SWIFT_NAME(Classification.System);

NS_SWIFT_NAME(Classification)
@interface BibClassification : NSObject <NSCopying>

@property(nonatomic, readwrite, assign) BibClassificationSystem system;
@property(nonatomic, readwrite, copy) NSString *classification;
@property(nonatomic, readwrite, copy, nullable) NSString *item;
@property(nonatomic, readwrite, assign, getter=isOfficial) BOOL official;

- (instancetype)initWithClassification:(NSString *)classification item:(nullable NSString *)item system:(BibClassificationSystem)system NS_SWIFT_NAME(init(_:item:system:));

- (BOOL)isEqualToClassification:(BibClassification *)classification NS_SWIFT_NAME(isEqual(to:));
- (BOOL)isSimilarToClassification:(BibClassification *)classification NS_SWIFT_NAME(isSimilar(to:));

@end

extern BibClassificationSystem const BibClassificationSystemLCC NS_SWIFT_NAME(lcc);
extern BibClassificationSystem const BibClassificationSystemDDC NS_SWIFT_NAME(ddc);

NS_ASSUME_NONNULL_END
