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

/// A Dewey Decimal call number identifies a specific item within the
/// Dewey Decimal Classification System.
NS_SWIFT_NAME(DeweyDecimalCallNumber)
@interface BibDeweyDecimalCallNumber : NSObject <BibCallNumber>

/// The short form of the item's Dewey Decimal classification.
@property(nonatomic, readonly, copy) NSString *abridged;

/// The full form of the item's Dewey Decimal classification.
@property(nonatomic, readonly, copy) NSString *expanded;

/// The truncated segment that was removed to create the abridged form.
@property(nonatomic, readonly, copy) NSString *qualification;

/// Any trailing components following the classification.
/// This can be anything from the author's name to the year of publication.
@property(nonatomic, readonly, copy) NSArray<NSString *> *itemComponents;

@end

NS_ASSUME_NONNULL_END
