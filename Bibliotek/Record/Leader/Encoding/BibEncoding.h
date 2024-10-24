//
//  BibEncoding.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/20/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The character encoding used to represent textual data in a MARC record.
typedef NS_ENUM(char, BibEncoding) {
    /// MARC8 Encoding
    ///
    /// String data is encoded using the ASCII standard.
    BibMARC8Encoding NS_SWIFT_NAME(marc8) = ' ',

    /// UTF-8 Encoding
    ///
    /// String data is encoded using the UTF-8 standard.
    BibUTF8Encoding  NS_SWIFT_NAME(utf8)  = 'a'
} NS_SWIFT_NAME(Encoding);

/// A human-readable description of the encoding.
///
/// - parameter encoding: The string encoding used to represent textual data.
/// - returns: A human-readable description of `encoding`.
FOUNDATION_EXTERN NSString *BibEncodingDescription(BibEncoding encoding) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
