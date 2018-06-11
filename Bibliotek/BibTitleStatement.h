//
//  BibTitleStatement.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/11/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecordField;

NS_ASSUME_NONNULL_BEGIN

/// A collection of information pertaining to the title of the item represented in a record.
NS_SWIFT_NAME(TitleStatement)
@interface BibTitleStatement : NSObject

/// The title of the item represented.
@property(nonatomic, readonly, copy) NSString *title;

/// A list of subtitles for the item represented.
@property(nonatomic, readonly, copy) NSArray<NSString *> *subtitles;

/// A list of authors and contributors, possibly including their respective roles.
@property(nonatomic, readonly, copy) NSArray<NSString *> *responsibilities;

/// Create a title statement from the given field representation.
/// \param field A record field which may or may not contain title statement information.
- (nullable instancetype)initWithField:(BibRecordField *)field;

/// Create a title statement from the given field representation.
/// \param field A record field which may or may not contain title statement information.
+ (nullable instancetype)statementWithField:(BibRecordField *)field NS_SWIFT_UNAVAILABLE("Use init(field:)");

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
