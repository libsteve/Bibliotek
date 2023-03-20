//
//  BibHasher.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/12/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibHasher;
@protocol BibHashable;

NS_ASSUME_NONNULL_BEGIN

/// An object that encapsulates a hashing algorithm.
@interface BibHasher : NSObject

/// Update `hash` to include the given value.
/// - parameter hash: An integer value that should be included in the hash value.
- (void)combineWithHash:(NSUInteger)hash;

/// Update `hash` to include the hash value of the given object.
/// - parameter object: The object that should be included in the hash value.
///
/// If `object` conforms to the `BibHashable` protocol, `-hashWithHasher:` will be called.
/// Otherwise, the value returned from its `-hash` method will be combined with this hasher.
- (void)combineWithObject:(id)object;

/// Update `hash` to include the given hashable object.
/// - parameter hashable: The receiver of the `-hashWithHasher:` method.
- (void)combineWithHashable:(id<BibHashable>)hashable;

/// An indexable value that can be used to represent an object.
@property (nonatomic, readonly) NSUInteger hash;

@end

#pragma mark - Hashable Protocol

/// An object whose hash value can be calculated with any arbitrary hashing algorithm.
///
/// Implementers of this protocol should override `-hash` to use the default `BibHasher` object.
///
/// ```objc
/// - (NSUInteger)hash {
///     BibHasher *hasher = [BibHasher new];
///     [hasher combineWithHashable:self];
///     return [hasher hash];
/// }
/// ```
@protocol BibHashable

/// Use the given `BibHasher` object to calculate a hash value.
/// - parameter hasher: The `BibHasher` object.
- (void)hashWithHasher:(BibHasher *)hasher;

@end

#pragma mark - Nullable Equality

/// Determine if two nullable objects are equal.
/// - parameter receiver: The receiver of the `-isEqual:` method.
/// - parameter object: The object passed into the receiver's `-isEqual:` method.
/// - returns: `YES` when both objects are `nil` or the return value from the receiver's `-isEqual:` method.
///
/// `-isEqual:` will return `NO` when both `receiver` and `object` are `nil`
/// even though they are equivalent. This function first checks for the case where
/// both objects are `nil` before using `-isEqual:` to account for this case.
extern BOOL BibNullableObjectEqual(id _Nullable receiver, id _Nullable object);

/// Determine if two nullable strings are equal.
/// - parameter receiver: The receiver of the `-isEqual:` method.
/// - parameter string: The string passed into the receiver's `-isEqual:` method.
/// - returns: `YES` when both strings are `nil` or the return value from the receiver's `-isEquaToString:` method.
///
/// `-isEqualToString:` will return `NO` when both `receiver` and `string` are `nil`
/// even though they are equivalent. This function first checks for the case where both
/// strings are `nil` before using `-isEqualToString:` to account for this case.
extern BOOL BibNullableStringEqual(NSString *_Nullable receiver, NSString *_Nullable string);

NS_ASSUME_NONNULL_END
