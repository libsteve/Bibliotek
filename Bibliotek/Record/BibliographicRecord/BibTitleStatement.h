//
//  BibTitleStatement.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// http://www.loc.gov/marc/bibliographic/bd245.html
@interface BibTitleStatement : NSObject <NSCopying, NSMutableCopying>

/// The proper title of the represented work.
@property (nonatomic, copy, readonly) NSString *title;

/// The amount of initial characters in the @c title that should be ingored for sorting purposes.
@property (nonatomic, assign, readonly) NSUInteger nonfillingCharacterCount;

/// The subtitles, alternate titles, and other title-like information of the represented work,
@property (nonatomic, copy, readonly, nullable) NSString *subtitle;

/// A description of the people or entities involved in the creation of the represented work.
@property (nonatomic, copy, readonly, nullable) NSString *authorStatement;

/// A value indicating the represented work's location within a sequential collection of other works.
///
/// For example: "Part 1", "Section A", "Book 1", etc.
@property (nonatomic, copy, readonly, nullable) NSString *sectionIndex;

/// A value indentifying the represented work within a non-sequential collection of other works.
///
/// For example: "Teacher's Edition", "Remastered Edition", "Workbook", etc.
@property (nonatomic, copy, readonly, nullable) NSString *sectionName;

- (instancetype)initWithTitle:(NSString *)title
     nonfillingCharacterCount:(NSUInteger)nonfillingCharacterCount
                     subtitle:(nullable NSString *)subtitle
              authorStatement:(nullable NSString *)authorStatement
                 sectionIndex:(nullable NSString *)sectionIndex
                  sectionName:(nullable NSString *)sectionName NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface BibTitleStatement (Equality)

- (BOOL)isEqualToTitleStatement:(BibTitleStatement *)titleStatement;

@end

#pragma mark - Mutable

@interface BibMutableTitleStatement : BibTitleStatement

/// The proper title of the represented work.
@property (nonatomic, copy, readwrite) NSString *title;

/// The amount of initial characters in the @c title that should be ingored for sorting purposes.
@property (nonatomic, assign, readwrite) NSUInteger nonfillingCharacterCount;

/// The subtitles, alternate titles, and other title-like information of the represented work,
@property (nonatomic, copy, readwrite, nullable) NSString *subtitle;

/// A description of the people or entities involved in the creation of the represented work.
@property (nonatomic, copy, readwrite, nullable) NSString *authorStatement;

/// A value indicating the represented work's location within a sequential collection of other works.
///
/// For example: "Part 1", "Section A", "Book 1", etc.
@property (nonatomic, copy, readwrite, nullable) NSString *sectionIndex;

/// A value indentifying the represented work within a non-sequential collection of other works.
///
/// For example: "Teacher's Edition", "Remastered Edition", "Workbook", etc.
@property (nonatomic, copy, readwrite, nullable) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END
