//
//  BibCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibClassificationSystem;
@class BibMarcRecordField;

NS_ASSUME_NONNULL_BEGIN

/// A call number is the identifier assigned to an item within a classification system.
/// It is generally composed of two parts: the classification and item.
NS_SWIFT_NAME(CallNumber)
@protocol BibCallNumber <NSObject, NSCopying, NSSecureCoding>

/// The system of classification used to catolog this item.
@property(nonatomic, readonly, strong) BibClassificationSystem *system;

/// Components of the call number which identify the subject area and topic of an item.
@property(nonatomic, readonly, copy) NSString *classification;

/// Components of the call number which differentiates an item from others in the same class.
@property(nonatomic, readonly, copy) NSString *item;

/// Determine whether or not the given call number is equivalent to this one.
/// \param callNumber The call number with which equality should be determined.
- (BOOL)isEqualToCallNumber:(id<BibCallNumber>)callNumber NS_SWIFT_NAME(isEqual(to:));

/// Determine whether or not the given call number has the same classification as this one.
/// \param callNumber The call number with which similarity should be determined.
- (BOOL)isSimilarToCallNumber:(id<BibCallNumber>)callNumber NS_SWIFT_NAME(isEqual(to:));

/// Given a wellformed string representation, create a call number instance.
/// \note Malformed representations for the classification system will not produce a call number.
- (nullable instancetype)initWithString:(NSString *)string;

/// Create a call number from the contents of a MARC field.
/// \note Fields without relevant for the classification system will not produce a call number.
- (nullable instancetype)initWithField:(BibMarcRecordField *)field;

@end

NS_ASSUME_NONNULL_END
