//
//  BibClassificationSystem.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

@class BibCallNumber;
@class BibMarcRecordField;

NS_ASSUME_NONNULL_BEGIN

/// The guiding process by which items are organized and categorized by subject and topic.
NS_SWIFT_NAME(ClassificationSystem)
@interface BibClassificationSystem : NSObject <NSSecureCoding>

/// An acronym representing the classification system.
/// For example, \c LCC is the acronym for the Library of Congress Classification System.
@property(nonatomic, readonly, copy) NSString *acronym;

/// The MARC record field tag commonly used to store call numbers within this system.
@property(nonatomic, readonly, copy) _BibMarcRecordFieldTag fieldTag;

/// The Library of Congress Classification System.
@property(nonatomic, readonly, class) BibClassificationSystem *libraryOfCongress;

/// The Dewey Decimal System.
@property(nonatomic, readonly, class) BibClassificationSystem *deweyDecimal;

/// \param acronym The abbreviated representation of the system.
/// \param description The name of the classification system.
/// \param fieldTag The MACR record field tag where call numbers in this system are commonly stored.
- (instancetype)initWithAcronym:(NSString *)acronym
                    description:(NSString *)description
                       fieldTag:(_BibMarcRecordFieldTag)fieldTag NS_DESIGNATED_INITIALIZER;

/// Determine if this classification system is equivalen to the one provided.
- (BOOL)isEqualToSystem:(BibClassificationSystem *)system;

@end

NS_ASSUME_NONNULL_END
