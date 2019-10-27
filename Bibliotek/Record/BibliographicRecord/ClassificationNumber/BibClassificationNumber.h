//
//  BibClassificationCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibClassificationNumberSource) {
    BibClassificationNumberSourceLibraryOfCongress = '0',
    BibClassificationNumberSourceOther = '4'
} NS_SWIFT_NAME(LCClassificationNumber.Source);

NS_SWIFT_NAME(ClassificationNumber)
@protocol BibClassificationNumber <NSObject>

@property (nonatomic, copy, readonly) NSString *classification;

@property (nonatomic, copy, readonly, nullable) NSString *item;

@property (nonatomic, copy, readonly) NSArray<NSString *> *alternatives;

@property (nonatomic, assign, readonly) BibClassificationNumberSource source;

@end

NS_SWIFT_NAME(MutableClassificationNumber)
@protocol BibMutableClassificationNumber <BibClassificationNumber>

@property (nonatomic, copy, readwrite) NSString *classification;

@property (nonatomic, copy, readwrite, nullable) NSString *item;

@property (nonatomic, copy, readwrite) NSArray<NSString *> *alternatives;

@property (nonatomic, assign, readwrite) BibClassificationNumberSource source;

@end

NS_ASSUME_NONNULL_END
