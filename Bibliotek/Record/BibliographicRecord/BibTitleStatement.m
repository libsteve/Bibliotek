//
//  BibTitleStatement.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibTitleStatement.h"

@implementation BibTitleStatement {
@protected
    NSString *_title;
    NSUInteger _nonfillingCharacterCount;
    NSString *_subtitle;
    NSString *_authorStatement;
    NSString *_sectionIndex;
    NSString *_sectionName;
}

@synthesize title = _title;
@synthesize nonfillingCharacterCount = _nonfillingCharacterCount;
@synthesize subtitle = _subtitle;
@synthesize authorStatement = _authorStatement;
@synthesize sectionIndex = _sectionIndex;
@synthesize sectionName = _sectionName;

- (instancetype)initWithTitle:(NSString *)title
     nonfillingCharacterCount:(NSUInteger)nonfillingCharacterCount
                     subtitle:(nullable NSString *)subtitle
              authorStatement:(nullable NSString *)authorStatement
                 sectionIndex:(nullable NSString *)sectionIndex
                  sectionName:(nullable NSString *)sectionName {
    if (self = [super init]) {
        _title = [title copy];
        _nonfillingCharacterCount = nonfillingCharacterCount;
        _subtitle = [subtitle copy];
        _authorStatement = [authorStatement copy];
        _sectionIndex = [sectionIndex copy];
        _sectionName = [sectionName copy];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title nonfillingCharacterCount:0
                      subtitle:nil
               authorStatement:nil
                  sectionIndex:nil
                   sectionName:nil];
}

- (instancetype)init {
    return nil;
}

+ (instancetype)new {
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableTitleStatement alloc] initWithTitle:[self title]
                                  nonfillingCharacterCount:[self nonfillingCharacterCount]
                                                  subtitle:[self subtitle]
                                           authorStatement:[self authorStatement]
                                              sectionIndex:[self sectionIndex]
                                               sectionName:[self sectionName]];
}

@end

@implementation BibTitleStatement (Equality)

inline static BOOL sNullableStringsEqual(NSString *const first, NSString *const second) {
    return first == second
        || (first && second && [first isEqualToString:second]);
}

- (BOOL)isEqualToTitleStatement:(BibTitleStatement *)titleStatement {
    if (self == titleStatement) {
        return YES;
    }
    return [[self title] isEqualToString:[titleStatement title]]
        && [self nonfillingCharacterCount] == [titleStatement nonfillingCharacterCount]
        && sNullableStringsEqual([self subtitle], [titleStatement subtitle])
        && sNullableStringsEqual([self authorStatement], [titleStatement authorStatement])
        && sNullableStringsEqual([self sectionIndex], [titleStatement sectionIndex])
        && sNullableStringsEqual([self sectionName], [titleStatement sectionName]);
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibTitleStatement class]] && [self isEqualToTitleStatement:object]);
}

inline static NSUInteger sRotateUnsignedInteger(NSUInteger const value, NSUInteger const rotation) {
    static NSUInteger const bitCount = CHAR_BIT * sizeof(NSUInteger);
    NSUInteger const amount = bitCount / rotation;
    return (value << amount) | (value >> (bitCount - amount));
}

- (NSUInteger)hash {
    return [self nonfillingCharacterCount]
         ^ sRotateUnsignedInteger([[self title] hash], 2)
         ^ sRotateUnsignedInteger([[self subtitle] hash], 3)
         ^ sRotateUnsignedInteger([[self authorStatement] hash], 4)
         ^ sRotateUnsignedInteger([[self sectionIndex] hash], 5)
         ^ sRotateUnsignedInteger([[self sectionName] hash], 6);
}

@end

#pragma mark - Mutable

@implementation BibMutableTitleStatement

- (id)copyWithZone:(NSZone *)zone {
    return [[BibTitleStatement alloc] initWithTitle:[self title]
                           nonfillingCharacterCount:[self nonfillingCharacterCount]
                                           subtitle:[self subtitle]
                                    authorStatement:[self authorStatement]
                                       sectionIndex:[self sectionIndex]
                                        sectionName:[self sectionName]];
}

@dynamic title;
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = [title copy];
    }
}

@dynamic nonfillingCharacterCount;
- (void)setNonfillingCharacterCount:(NSUInteger)nonfillingCharacterCount {
    _nonfillingCharacterCount = nonfillingCharacterCount;
}

@dynamic subtitle;
- (void)setSubtitle:(NSString *)subtitle {
    if (_subtitle != subtitle) {
        _subtitle = [subtitle copy];
    }
}

@dynamic authorStatement;
- (void)setAuthorStatement:(NSString *)authorStatement {
    if (_authorStatement != authorStatement) {
        _authorStatement = [authorStatement copy];
    }
}

@dynamic sectionIndex;
- (void)setSectionIndex:(NSString *)sectionIndex {
    if (_sectionIndex != sectionIndex) {
        _sectionIndex = [sectionIndex copy];
    }
}

@dynamic sectionName;
- (void)setSectionName:(NSString *)sectionName {
    if (_sectionName != sectionName) {
        _sectionName = [sectionName copy];
    }
}


@end
