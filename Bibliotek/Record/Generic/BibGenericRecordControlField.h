//
//  BibGenericRecordControlField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordControlField.h"

NS_ASSUME_NONNULL_BEGIN

/// \brief A control field contains information and metadata pertaining to the processing of a record's data.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record.GenericControlField)
@interface BibGenericRecordControlField : BibRecordControlField

- (instancetype)initWithData:(NSData *)data NS_UNAVAILABLE;

- (instancetype)initWithContent:(NSString *)content NS_UNAVAILABLE;

- (instancetype)initWithTag:(BibRecordFieldTag)tag data:(NSData *)data NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTag:(BibRecordFieldTag)tag content:(NSString *)content NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
