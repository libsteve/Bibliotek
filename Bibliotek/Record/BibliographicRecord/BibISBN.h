//
//  BibISBN.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibContentField;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibISBNKind) {
    BibISBNKindISBN10 NS_SWIFT_NAME(isbn10) = 10,
    BibISBNKindISBN13 NS_SWIFT_NAME(isbn13) = 13
} NS_SWIFT_NAME(ISBNKind);

/// http://www.loc.gov/marc/bibliographic/bd020.html
@interface BibISBN : NSObject

@property (nonatomic, copy, readonly) NSString *stringValue;

@property (nonatomic, assign, readonly) BibISBNKind kind;

- (nullable instancetype)initWithStringValue:(NSString *)stringValue NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)isbnWithStringValue:(NSString *)stringValue NS_SWIFT_UNAVAILABLE("Use init(stringValue:)");

- (nullable instancetype)initWithContentField:(BibContentField *)contentField;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface BibISBN (Equality)

- (BOOL)isEqualToISBN:(BibISBN *)isbn;

@end

NS_ASSUME_NONNULL_END
