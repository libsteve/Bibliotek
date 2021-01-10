//
//  BibLCCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The ordering relationship between classification numbers.
typedef NS_CLOSED_ENUM(NSInteger, BibClassificationComparisonResult) {
    /// The leading value is contained within the trailing value's classification.
    BibClassificationOrderedGeneralizing NS_SWIFT_NAME(generalizing) = -2L,

    /// The leading value is ordered after the trailing value.
    BibClassificationOrderedDescending   NS_SWIFT_NAME(descending)   = -1L,

    /// The values are equivalent.
    BibClassificationOrderedSame         NS_SWIFT_NAME(same)         =  0L,

    /// The leading value is ordered before the trailing value.
    BibClassificationOrderedAscending    NS_SWIFT_NAME(ascending)    =  1L,

    /// The leading value's classification contains the trailing value.
    BibClassificationOrderedSpecifying   NS_SWIFT_NAME(specifying)   =  2L
} NS_SWIFT_NAME(ClassificationComparisonResult);

typedef NS_OPTIONS(NSInteger, BibLCCallNumberFormatOptions);

#pragma mark -

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

/// Create a string representation of the call number using the given style attributes.
/// \param options Attributes describing the format of the resulting string value.
/// \returns A string representation of the call number in a format described by the given attributes.
- (NSString *)stringWithFormatOptions:(BibLCCallNumberFormatOptions)options;

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
/// \returns \c BibClassificationOrderedGeneralizing when the given call number's represented subject matter includes
///          that represented by the receiver. The given call number, being a generalization of the receiver, is
///          necessarily ordered linearly before the receiver.
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

#pragma mark -

/// Attributes describing the format of a string value representing a Library of Congress call number.
typedef NS_OPTIONS(NSInteger, BibLCCallNumberFormatOptions) {
    /// A compact single-line call number.
    ///
    /// \example QA76.76.C65A37 \c 1986
    BibLCCallNumberFormatOptionsDefault NS_SWIFT_NAME(default) = 0,

    /// Insert a space between the class letters and the subclass number.
    ///
    /// \example \c QA \c 76.76.C65A37 \c 1986
    BibLCCallNumberFormatOptionsExpandSubject = 1 << 1,

    /// Insert a space between adjacent cutter numbers.
    ///
    /// \example \c QA76.76.C65 \c A37 \c 1986
    BibLCCallNumberFormatOptionsExpandCutters = 1 << 2,

    /// Insert a space before the period marking a cutter section.
    ///
    /// \example \c QA76.76 \c .C65A37 \c 1986
    BibLCCallNumberFormatOptionsExpandCutterMarks = 1 << 3,

    /// Separate components of the call numner with a newline instead of a space.
    BibLCCallNumberFormatOptionsMultiline     = 1 << 4,

    /// Insert a period before any cutter numner that appears after a date or ordinal number.
    ///
    /// \example \c JZ33.D4 \c 1999.E37
    BibLCCallNumberFormatOptionsMarkCutterAfterDate = 1 << 5

} NS_SWIFT_NAME(BibLCCallNumber.FormatOptions);

/// The format for a call number appearing on a book's pocket label.
///
/// \example \c QA \c 76.76 \c .C65 \c A37 \c 1986
extern BibLCCallNumberFormatOptions const BibLCCallNumberFormatOptionsPocket
NS_SWIFT_NAME(BibLCCallNumberFormatOptions.pocket);

/// The format for a call number appearing on a book's spine label.
///
/// \example
///
/// \c QA
///
/// \c 76.76
///
/// \c .C65
///
/// \c A37
///
/// \c 1986
extern BibLCCallNumberFormatOptions const BibLCCallNumberFormatOptionsSpine
NS_SWIFT_NAME(BibLCCallNumberFormatOptions.spine);

NS_ASSUME_NONNULL_END
