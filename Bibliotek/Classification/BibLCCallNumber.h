//
//  BibLCCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibLCCallNumber : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *stringValue;

- (nullable instancetype)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)callNumberWithString:(NSString *)string NS_SWIFT_UNAVAILABLE("Use init(string:)");

- (NSComparisonResult)compare:(BibLCCallNumber *)other;

- (BOOL)isEqualToCallNumber:(BibLCCallNumber *)other;

/// Does the subject matter represented by this call number include that of the given call number?
///
/// For example, the calssification \c QA76 encompasses the more specific classifications \c QA76.76 and \c QA76.75 but
/// does not include the classification \c QA70 nor its parent classification \c QA
///
/// \param callNumber The call number whose subject matter may be a subset of the receiver's.
/// \returns \c YES when the given call number belongs within the receiver's domain.
- (BOOL)includesCallNumber:(BibLCCallNumber *)callNumber NS_SWIFT_NAME(includes(_:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
