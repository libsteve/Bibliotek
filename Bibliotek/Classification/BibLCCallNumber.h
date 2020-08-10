//
//  BibLCCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BibClassificationComparisonResult) {
    BibClassificationOrderedDescending NS_SWIFT_NAME(descending) = -1L,
    BibClassificationOrderedSame       NS_SWIFT_NAME(same)       =  0L,
    BibClassificationOrderedAscending  NS_SWIFT_NAME(ascending)  =  1L,
    BibClassificationOrderedSpecifying NS_SWIFT_NAME(specifying) =  2L
} NS_SWIFT_NAME(ClassificationComparisonResult);

NS_ASSUME_NONNULL_BEGIN

/// More information about Library of Congress Classification can be found at
/// https://www.librarianshipstudies.com/2017/11/library-of-congress-classification.html
@interface BibLCCallNumber : NSObject <NSCopying>

/// A string representation of the call number.
@property (nonatomic, readonly, copy) NSString *stringValue;

/// Create a Library of Congress call number with the given string representation.
/// \param string The string value of the call number.
- (nullable instancetype)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;

/// Create a Library of Congress call number with the given string representation.
/// \param string The string value of the call number.
+ (nullable instancetype)callNumberWithString:(NSString *)string NS_SWIFT_UNAVAILABLE("Use init(string:)");

/// Determine the linear ordering relationship between two call numbers.
///
/// \b Examples
///
/// The classification \c HQ76 is ordered before \c QA76
///
/// The classification \c QA76 is ordered before \c QA76.76
///
/// The classification \c QA76.76 is ordered before \c QA76.9
///
/// The classification \c P35 is ordered before \c P112
///
/// The classification \c P327 is ordered before \c PC5615
///
/// \param callNumber The call number being comparied with the receiver.
/// \returns \c NSOrderedDescending when the given call number is ordered before the receiver.
/// \returns \c NSOrderedSame when the given call number is equivalent to the receiver.
/// \returns \c NSOrderedAscending when the given call number is ordered after the receiver.
- (NSComparisonResult)compare:(BibLCCallNumber *)callNumber;

/// Determine the ordering relationship between the subject matters represented by two call numbers.
///
/// The classification \c HQ76 is ordered before \c QA76
///
/// The classification \c QA76.76 is ordered before \c QA76.9
///
/// The classification \c P35 is ordered before \c P112
///
/// The classification \c P327 is ordered before \c PC5615
///
/// The calssification \c QA76 encompasses the more specific classifications \c QA76.76 and \c QA76.75 but
/// does not include the classification \c QA70 nor its parent classification \c QA
///
/// \param callNumber The call number being compaired with the receiver.
/// \returns \c BibClassificationOrderedDescending when the given call number is ordered before the receiver.
/// \returns \c BibClassificationOrderedSame when the given call number is euqivalent to the receiver.
/// \returns \c BibClassificationOrderedAscending when the given call number is ordered after the receiver.
/// \returns \c BibClassificationOrderedSpecifying when the given call number's represented subject matter is included
///          in that represented by the receiver. The given call number, being a specialization of the receiver, is
///          necessarily ordered linearly after the receiver.
- (BibClassificationComparisonResult)compareWithCallNumber:(BibLCCallNumber *)callNumber;

/// Does the given call number represent the same subject matter as the receiver?
/// \param callNumber The call number being compaired with the receiver.
/// \returns \c YES when the given call number is equivalent to the receiver.
- (BOOL)isEqualToCallNumber:(BibLCCallNumber *)callNumber;

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
