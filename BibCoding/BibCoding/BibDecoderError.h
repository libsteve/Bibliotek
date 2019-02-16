//
//  BibDecoderError.h
//  BibCoding
//
//  Created by Steve Brunwasser on 2/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const BibDecoderErrorDomain NS_REFINED_FOR_SWIFT;

extern NSErrorUserInfoKey const BibDecoderErrorKeyPathKey;
extern NSErrorUserInfoKey const BibDecoderErrorInvalidDataKey;
extern NSErrorUserInfoKey const BibDecoderErrorInvalidClassKey;
extern NSErrorUserInfoKey const BibDecoderErrorExpectedClassKey;

typedef NS_ERROR_ENUM(BibDecoderErrorDomain, BibDecoderError) {
    BibDecoderErrorMissingKeyedValue = 1,
    BibDecoderErrorInvalidClass = 2,
    BibDecoderErrorInvalidData = 4,
    BibDecoderErrorOutOfBounds = 3
} NS_SWIFT_NAME(DecoderError);

NS_ASSUME_NONNULL_END
