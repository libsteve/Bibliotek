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

NS_SWIFT_NAME(CallNumber)
@interface BibCallNumber : NSObject <NSCopying, NSSecureCoding>

/// The system of classification used to catolog this item.
@property(nonatomic, readonly, strong) BibClassificationSystem *system;

@property(nonatomic, readonly, copy) NSArray<NSString *> *components;

/// The string representation of this call number as it appears on a book spine label.
@property(nonatomic, readonly, copy) NSString *spineDescription;

- (instancetype)initWithString:(NSString *)string system:(BibClassificationSystem *)system;

- (instancetype)initWithComponents:(NSArray<NSString *> *)components system:(BibClassificationSystem *)system NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithField:(BibMarcRecordField *)field;

- (instancetype)initWithCallNumber:(BibCallNumber *)callNumber NS_SWIFT_NAME(init(_:));

/// Determine whether or not the given call number is equivalent to this one.
/// \param callNumber The call number with which equality should be determined.
- (BOOL)isEqualToCallNumber:(BibCallNumber *)callNumber NS_SWIFT_NAME(isEqual(to:));

@end

NS_ASSUME_NONNULL_END
