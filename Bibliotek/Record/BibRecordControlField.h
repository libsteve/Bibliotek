//
//  BibRecordControlField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordField.h"

NS_ASSUME_NONNULL_BEGIN

/// \brief A control field contains information and metadata pertaining to the processing of a record's data.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record.ControlField)
@interface BibRecordControlField : NSObject <BibRecordField>

@property (nonatomic, copy, readonly) NSString *content;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithContent:(NSString *)content;

/// Determine whether or not the given control field represents the same data as the receiver.
/// \param controlField The control field with which the receiver should be compared.
/// \returns Returns \c YES if the given control field and the receiver have the same tag and content data.
- (BOOL)isEqualToControlField:(BibRecordControlField *)controlField;

@end

NS_ASSUME_NONNULL_END
