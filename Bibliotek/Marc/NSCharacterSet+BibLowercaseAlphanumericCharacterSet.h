//
//  NSCharacterSet+BibLowercaseAlphanumericCharacterSet.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCharacterSet (BibLowercaseAlphanumericCharacterSet)

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_westernNumeralCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_lowercaseEnglishCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_lowercaseAlphanumericCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_blankIndicatorCharacterSet;

@end

NS_ASSUME_NONNULL_END
