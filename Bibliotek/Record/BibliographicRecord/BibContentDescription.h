//
//  BibContentDescription.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BibContentDescriptionKind) {
    BibContentDescriptionKindContents = '0',
    BibContentDescriptionKindIncomplete = '1',
    BibContentDescriptionKindPartial = '2',
    BibContentDescriptionKindOther = '8'
} NS_SWIFT_NAME(BibContentDescription.Kind);

typedef NS_ENUM(NSUInteger, BibContentDescriptionLevel) {
    BibContentDescriptionLevelBasic = ' ',
    BibContentDescriptionLevelEnhanced = '0'
} NS_SWIFT_NAME(BibContentDescription.Level);

/// http://www.loc.gov/marc/bibliographic/bd505.html
@interface BibContentDescription : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, assign, readonly) BibContentDescriptionKind kind;

@property (nonatomic, assign, readonly) BibContentDescriptionLevel level;

@property (nonatomic, copy, readonly) NSString *note;

@property (nonatomic, copy, readonly) NSArray<NSURL *> *urls;

@property (nonatomic, copy, readonly) NSArray<NSString *> *contents;

- (instancetype)initWithKind:(BibContentDescriptionKind)kind
                       level:(BibContentDescriptionLevel)level
                        note:(NSString *)note
                        urls:(NSArray<NSURL *> *)urls
                    contents:(NSArray<NSString *> *)contents NS_DESIGNATED_INITIALIZER;

@end

@interface BibContentDescription (Equality)

- (BOOL)isEqualToContentDescription:(BibContentDescription *)contentDescription;

@end

#pragma mark - Mutable

@interface BibMutableContentDescription : BibContentDescription

@property (nonatomic, assign, readwrite) BibContentDescriptionKind kind;

@property (nonatomic, assign, readwrite) BibContentDescriptionLevel level;

@property (nonatomic, copy, readwrite) NSString *note;

@property (nonatomic, copy, readwrite) NSArray<NSURL *> *urls;

@property (nonatomic, copy, readwrite) NSArray<NSString *> *contents;

@end

NS_ASSUME_NONNULL_END
