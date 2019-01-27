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

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIICharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIControlCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIPrintableCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIExtendedCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIGraphicCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIINumericCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIAlphabetCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIExtendedAlphabetCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIILowercaseCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIUppercaseCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIIAlphanumericCharacterSet;
@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_ASCIILowercaseAlphanumericCharacterSet;

#pragma mark -

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_westernNumeralCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_lowercaseEnglishCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_lowercaseAlphanumericCharacterSet;

@property (class, nonatomic, strong, readonly) NSCharacterSet *bib_blankIndicatorCharacterSet;

@end

NS_ASSUME_NONNULL_END
