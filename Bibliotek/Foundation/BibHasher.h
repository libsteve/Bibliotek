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

/// Update \c hash to include the given value.
/// \param hash An integer value that should be included in the hash value.
- (void)combineWithHash:(NSUInteger)hash;

/// Update \c hash to include the hash value of the given object.
/// \param object The object that should be included in the hash value.
///
/// If \c object conforms to the \c BibHashable protocol, \c -hashWithHasher: will be called.
/// Otherwise, the value returned from its \c -hash method will be combined with this hasher.
- (void)combineWithObject:(id)object;

/// Update \c hash to include the given hashable object.
/// \param hashable The receiver of the \c -hashWithHasher: method.
- (void)combineWithHashable:(id<BibHashable>)hashable;

/// An indexable value that can be used to represent an object.
@property (nonatomic, readonly) NSUInteger hash;

@end

#pragma mark - Hashable Protocol

/// An object whose hash value can be calculated with any arbitrary hashing algorithm.
///
/// Implementers of this protocol should override \c -hash to use the default \c BibHasher object.
///
/// \code
/// - (NSUInteger)hash {
///     BibHasher *hasher = [BibHasher new];
///     [hasher combineWithHashable:self];
///     return [hasher hash];
/// }
/// \endcode
@protocol BibHashable

/// Use the given \c BibHasher object to calculate a hash value.
/// \param hasher The \c BibHasher object.
- (void)hashWithHasher:(BibHasher *)hasher;

@end

#pragma mark - Nullable Equality

/// Determine if two nullable objects are equal.
/// \param receiver The receiver of the \c -isEqual: method.
/// \param object The object passed into the receiver's \c -isEqual: method.
/// \returns \c YES when both objects are \c nil or the return value from the receiver's \c -isEqual: method.
///
/// \c -isEqual: will return \c NO when both \c receiver and \c object are \c nil
/// even though they are equivalent. This function first checks for the case where
/// both objects are \c nil before using \c -isEqual: to account for this case.
extern BOOL BibNullableObjectEqual(id _Nullable receiver, id _Nullable object);

/// Determine if two nullable strings are equal.
/// \param receiver The receiver of the \c -isEqual: method.
/// \param string The string passed into the receiver's \c -isEqual: method.
/// \returns \c YES when both strings are \c nil or the return value from the receiver's \c -isEquaToString: method.
///
/// \c -isEqualToString: will return \c NO when both \c receiver and \c string are \c nil
/// even though they are equivalent. This function first checks for the case where both
/// strings are \c nil before using \c -isEqualToString: to account for this case.
extern BOOL BibNullableStringEqual(NSString *_Nullable receiver, NSString *_Nullable string);

NS_ASSUME_NONNULL_END
