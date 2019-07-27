//
//  BibContentField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibSubfield;
@class BibFieldTag;
@class BibContentIndicators;

NS_ASSUME_NONNULL_BEGIN

/// \brief A content field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
@interface BibContentField : NSObject

/// A value indicating the semantic purpose of the control field.
@property (nonatomic, strong, readonly) BibFieldTag *tag;

@property (nonatomic, copy, readonly) BibContentIndicators *indicators;

@property (nonatomic, copy, readonly) NSArray<BibSubfield *> *subfields;

- (instancetype)initWithTag:(BibFieldTag *)tag
                 indicators:(BibContentIndicators *)indicators
                  subfields:(NSArray<BibSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Copying

@interface BibContentField (Copying) <NSCopying, NSMutableCopying>
@end

#pragma mark - Equality

@interface BibContentField (Equality)

/// Determine whether or not the given content field represents the same data as the receiver.
///
/// \param contentField The content field with which the receiver should be compared.
/// \returns Returns \c YES if the given content field and the receiver have the same tag and subfields.
- (BOOL)isEqualToContentField:(BibContentField *)contentField;

@end

#pragma mark - Mutable

/// \brief A content field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
@interface BibMutableContentField : BibContentField

/// A value indicating the semantic purpose of the control field.
@property (nonatomic, strong, readwrite) BibFieldTag *tag;

@property (nonatomic, copy, readwrite) BibContentIndicators *indicators;

@property (nonatomic, copy, readwrite) NSArray<BibSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
