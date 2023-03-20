//
//  BibLCCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The ordering relationship between classification numbers.
///
/// Comparison between classification numbers can be tricky. Since classification systems model a
/// hierarchical structure, classification numbers can be compared by their direct parentage as well
/// as their canonical order. This introduces the "specifies" and "generalizes" relations, analogous
/// to the "less than" and "greater than" relations respectively, that compare ancestors with their
/// descendants. A classification number that "specifies" another is a direct descendant of the latter,
/// whereas a classification number that "generalizes" another is a direct ancestor.
///
/// Although any two numbers are guaranteed to have a linear, canonical ordering, not all numbers can
/// share a parentage relation. For example, `QA76` (Electronic computers. Computer science) contains
/// within it `QA76.76` (Computer software) and is therefore its direct ancestor. However, `HQ76.13`
/// (Gay fathers) and `HQ76.5` (Gay rights movement. Gay liberation movement) are mutually exclusive
/// exclusive classifications that don't share a parentage relation even they share a common ancestor.
///
/// ``BibClassificationComparisonResult`` provides ``BibClassificationOrderedSpecifying`` and
/// ``BibClassificationOrderedGeneralizing`` to let comparisons between classification numbers express
/// the parentage relationships possible in hierarchical classification systems.
typedef NS_CLOSED_ENUM(NSInteger, BibClassificationComparisonResult) {
    /// The leading classification includes the trailing value's subject matter.
    ///
    /// For example, the following equation represents the "specifying" relation:
    ///
    ///     QA76 ∋ QA76.76
    ///
    /// The classification `QA76` (Electronic computers. Computer science) includes `QA76.76`
    /// (Computer software), so they're ordered  "specifying" when `QA76` appears before `QA76.76.
    ///
    /// The leading classification is linearly ordered `NSOrderedAscending` with the trailing
    /// classification. That is, it appears before the trailing classification when sorted linearly.
    BibClassificationOrderedSpecifying   NS_SWIFT_NAME(specifying)   = NSOrderedAscending - 1,

    /// The leading value is ordered before the trailing value.
    ///
    /// For example, the following equation represents the "ascending" relation:
    ///
    ///     HQ76.13 < HQ76.5
    ///
    /// The classification `HQ76.13` (Gay fathers) is ordered before `HQ76.5` (Gay rights movement.
    /// Gay liberation movement.) on the shelf. Neither classification is a superset of the other,
    /// with their first common ancestor being `HQ76` (Homosexuality. Lesbianism).
    BibClassificationOrderedAscending    NS_SWIFT_NAME(ascending)    = NSOrderedAscending,

    /// The leading and trailing values are equivalent.
    ///
    /// For example, the following equation represents the "same" relation:
    ///
    ///     PM8001 = PM8001
    ///
    /// The classification `PM8001` (Artificial languages. Universal languages) is equal to itself.
    ///
    /// - note: Although both `PM8001` and `PM8008` identify the same classification caption hierarchy,
    ///         they are not the same classification number, and would therefore be ordered as either
    ///         ``BibClassificationOrderedAscending`` or ``BibClassificationOrderedDescending``,
    ///         depending on their order.
    BibClassificationOrderedSame         NS_SWIFT_NAME(same)         = NSOrderedSame,

    /// The leading value is ordered after the trailing value.
    ///
    /// For example, the following equation represents the "descending" relation:
    ///
    ///     HQ76.5 > HQ76.13
    ///
    /// The classification `HQ76.5` (Gay rights movement. Gay liberation movement.) is ordered
    /// after `HQ76.13` (Gay fathers) on the shelf. Neither classification is a superset of the
    /// other, with their first common ancestor being `HQ76` (Homosexuality. Lesbianism).
    BibClassificationOrderedDescending   NS_SWIFT_NAME(descending)   = NSOrderedDescending,

    /// The leading value's subject matter is included in the tailing classification.
    ///
    /// For example, the following equation demonstrates the "generalizing" relation:
    ///
    ///     QA76.76 ∈ QA76
    ///
    /// The classification `QA76.76` (Computer software) is a member of `QA76` (Electronic computers.
    /// Computer science), so they're ordered  "generalizing" when `QA76.76 appears before `QA76`.
    ///
    /// The leading subject matter is linearly ordered `NSOrderedDescending` with the trailing
    /// classification. That is, it appears after the trailing classification when sorted linearly.
    BibClassificationOrderedGeneralizing NS_SWIFT_NAME(generalizing) = NSOrderedDescending + 1
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
/// - parameter string: The string value of the call number.
- (nullable instancetype)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;

/// Create a Library of Congress call number with the given string representation.
/// - parameter string: The string value of the call number.
+ (nullable instancetype)callNumberWithString:(NSString *)string NS_SWIFT_UNAVAILABLE("Use init(string:)");

/// Create a string representation of the call number using the given style attributes.
/// - parameter options: Attributes describing the format of the resulting string value.
/// - returns: A string representation of the call number in a format described by the given attributes.
- (NSString *)stringWithFormatOptions:(BibLCCallNumberFormatOptions)options;

/// Determine the linear ordering relationship between two call numbers.
///
/// ## Examples
///
/// The classification `HQ76` is ordered before `QA76`
///
/// The classification `QA76` is ordered before `QA76.76`
///
/// The classification `QA76.76` is ordered before `QA76.9`
///
/// The classification `P35` is ordered before `P112`
///
/// The classification `P327` is ordered before `PC5615`
///
/// - parameter callNumber: The call number being compared with the receiver.
/// - returns: `NSOrderedDescending` when the given call number is ordered before the receiver.
///            `NSOrderedSame` when the given call number is equivalent to the receiver.
///            `NSOrderedAscending` when the given call number is ordered after the receiver.
///
/// - seealso: ``compareWithCallNumber:``
/// - seealso: ``isEqualToCallNumber:``
/// - seealso: ``includesCallNumber:``
- (NSComparisonResult)compare:(BibLCCallNumber *)callNumber;

/// Determine the ordering relationship between the subject matters represented by two call numbers.
///
/// The classification `HQ76` is ordered before `QA76`
///
/// The classification `QA76.76` is ordered before `QA76.9`
///
/// The classification `P35` is ordered before `P112`
///
/// The classification `P327` is ordered before `PC5615`
///
/// The classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75` but
/// does not include the classification `QA70` nor its parent classification `QA`
///
/// - parameter callNumber: The call number being compared with the receiver.
/// - returns: ``BibClassificationOrderedSpecifying`` when the given call number's represented subject matter is
///            included in that represented by the receiver.
///            ``BibClassificationOrderedAscending`` when the given call number is ordered after the receiver.
///            ``BibClassificationOrderedSame`` when the given call number is equivalent to the receiver.
///            ``BibClassificationOrderedDescending`` when the given call number is ordered before the receiver.
///            ``BibClassificationOrderedGeneralizing`` when the given call number's represented subject matter
///            includes that represented by the receiver.
- (BibClassificationComparisonResult)compareWithCallNumber:(BibLCCallNumber *)callNumber;

/// Does the given call number represent the same subject matter as the receiver?
/// - parameter callNumber: The call number being compared with the receiver.
/// - returns: `YES` when the given call number is equivalent to the receiver.
- (BOOL)isEqualToCallNumber:(BibLCCallNumber *)callNumber;

/// Does the subject matter represented by this call number include that of the given call number?
///
/// For example, the classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`
/// but does not include the classification `QA70` nor its parent classification `QA`.
///
/// - parameter callNumber: The call number whose subject matter may be a subset of the receiver's.
/// - returns: `YES` when the given call number belongs within the receiver's domain.
- (BOOL)includesCallNumber:(BibLCCallNumber *)callNumber NS_SWIFT_NAME(includes(_:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

#pragma mark -

/// Attributes describing the format of a string value representing a Library of Congress call number.
typedef NS_OPTIONS(NSInteger, BibLCCallNumberFormatOptions) {
    /// A compact single-line call number.
    ///
    /// ## Example
    ///
    ///     QA76.76.C65A37 1986
    BibLCCallNumberFormatOptionsDefault NS_SWIFT_NAME(default) = 0,

    /// Insert a space between the class letters and the subclass number.
    ///
    /// ## Example
    ///
    ///     QA 76.76.C65A37 1986
    BibLCCallNumberFormatOptionsExpandSubject = 1 << 1,

    /// Insert a space between adjacent cutter numbers.
    ///
    /// ## Example
    ///
    ///     QA76.76.C65 A37 1986
    BibLCCallNumberFormatOptionsExpandCutters = 1 << 2,

    /// Insert a space before the period marking a cutter section.
    ///
    /// ## Example
    ///
    ///     QA76.76 .C65A37 1986
    BibLCCallNumberFormatOptionsExpandCutterMarks = 1 << 3,

    /// Separate components of the call number with a newline instead of a space.
    BibLCCallNumberFormatOptionsMultiline     = 1 << 4,

    /// Insert a period before any cutter number that appears after a date or ordinal number.
    ///
    /// ## Example
    ///
    ///     JZ33.D4 1999.E37
    BibLCCallNumberFormatOptionsMarkCutterAfterDate = 1 << 5

} NS_SWIFT_NAME(BibLCCallNumber.FormatOptions);

/// The format for a call number appearing on a book's pocket label.
///
/// ## Example
///
///     QA 76.76 .C65 A37 1986
extern BibLCCallNumberFormatOptions const BibLCCallNumberFormatOptionsPocket
NS_SWIFT_NAME(BibLCCallNumberFormatOptions.pocket);

/// The format for a call number appearing on a book's spine label.
///
/// ## Example
///
///     QA
///     76.76
///     .C65
///     A37
///     1986
extern BibLCCallNumberFormatOptions const BibLCCallNumberFormatOptionsSpine
NS_SWIFT_NAME(BibLCCallNumberFormatOptions.spine);

NS_ASSUME_NONNULL_END
