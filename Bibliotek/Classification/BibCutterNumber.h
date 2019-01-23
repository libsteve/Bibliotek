//
//  BibCutterNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/28/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibCutterDigit;

NS_ASSUME_NONNULL_BEGIN

@interface BibCutterNumber : NSObject

@property (nonatomic, readonly, copy) NSString *reference;

@property (nonatomic, readonly, copy) NSArray<BibCutterDigit *> *digits;

@property (nonatomic, readonly, assign, getter=isWellDefined) BOOL wellDefined;

- (instancetype)initWithString:(NSString *)string;

@end

#pragma mark -

@interface BibCutterDigit : NSObject

@property (nonatomic, readonly, copy) NSString *reference;

@property (nonatomic, readonly, assign, getter=isWellDefined) BOOL wellDefined;

- (instancetype)initWithNormalizedReference:(NSString *)reference stringRepresentation:(nullable NSString *)representation;

+ (instancetype)digitWithNormalizedReference:(NSString *)reference stringRepresentation:(nullable NSString *)representation;

- (NSComparisonResult)compare:(BibCutterDigit *)digit;

@end

NS_ASSUME_NONNULL_END
