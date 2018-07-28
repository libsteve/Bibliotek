//
//  BibLibraryOfCongressCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibCallNumber.h"

NS_ASSUME_NONNULL_BEGIN

/// A Library of Congress call number identifies a specific item within the
/// Library of Congress Classification System.
/// @code QA 76.76 .E5 C45 2007e @endcode
NS_SWIFT_NAME(LibraryOfCongressCallNumber)
@interface BibLibraryOfCongressCallNumber : NSObject <BibCallNumber>

/// The broad subject area in which the item belongs.
@property(nonatomic, readonly, copy) NSString *subjectArea;

/// The specific topic appropriate for the item within the subject area.
@property(nonatomic, readonly, copy) NSString *topic;

/// A sequence of identifiers representing subtopics and/or the author of the item.
@property(nonatomic, readonly, copy) NSArray<NSString *> *cutters;

/// The relevant publication year for the item.
@property(nonatomic, readonly, copy) NSString *date;

/// A single character which may denote the specific format of the item.
/// \discussion For example, @c e generally signifies the digital e-book format.
@property(nonatomic, readonly, copy, nullable) NSString *work;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
