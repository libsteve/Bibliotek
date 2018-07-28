//
//  BibDeweyDecimalCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibCallNumber.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DeweyDecimalCallNumber)
@interface BibDeweyDecimalCallNumber : NSObject <BibCallNumber>

@property(nonatomic, readonly, copy) NSString *abridged;

@property(nonatomic, readonly, copy) NSString *expanded;

@property(nonatomic, readonly, copy) NSString *qualification;

@property(nonatomic, readonly, copy) NSArray<NSString *> *itemComponents;

@end

NS_ASSUME_NONNULL_END
