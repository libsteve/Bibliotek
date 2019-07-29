//
//  BibItemDescription.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibItemDescriptionKind) {
    BibItemDescriptionKindSummary = ' ',
    BibItemDescriptionKindSubject = '0',
    BibItemDescriptionKindReview = '1',
    BibItemDescriptionKindScopeAndContent = '2',
    BibItemDescriptionKindAbstract = '3',
    BibItemDescriptionKindContentAdvice = '4',
    BibItemDescriptionKindOther = '8'
} NS_SWIFT_NAME(BibItemDescription.Kind);

/// http://www.loc.gov/marc/bibliographic/bd520.html
@interface BibItemDescription : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, assign, readonly) BibItemDescriptionKind kind;

@property (nonatomic, copy, readonly) NSString *content;

@property (nonatomic, copy, readonly, nullable) NSString *detail;

@property (nonatomic, copy, readonly, nullable) NSString *source;

@property (nonatomic, copy, readonly) NSArray<NSURL *> *urls;

- (instancetype)initWithKind:(BibItemDescriptionKind)kind
                     content:(NSString *)content
                      detail:(nullable NSString *)detail
                      source:(nullable NSString *)source
                        urls:(NSArray<NSURL *> *)urls NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithKind:(BibItemDescriptionKind)kind content:(NSString *)content;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

@interface BibItemDescription (Equality)

- (BOOL)isEqualToItemDescription:(BibItemDescription *)itemDescription;

@end

#pragma mark - Mutable

@interface BibMutableItemDescription : BibItemDescription

@property (nonatomic, assign, readwrite) BibItemDescriptionKind kind;

@property (nonatomic, copy, readwrite) NSString *content;

@property (nonatomic, copy, readwrite, nullable) NSString *detail;

@property (nonatomic, copy, readwrite, nullable) NSString *source;

@property (nonatomic, copy, readwrite) NSArray<NSURL *> *urls;

@end

NS_ASSUME_NONNULL_END
