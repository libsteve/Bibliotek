//
//  BibRecordDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

/// \brief A data field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html.
NS_SWIFT_NAME(Record.DataFeild)
@interface BibRecordDataField : NSObject

@property (nonatomic, copy, readonly) NSString *tag;

@property (nonatomic, copy, readonly) NSArray<NSString *> *indicators;

@property (nonatomic, copy, readonly) NSArray<BibRecordSubfield *> *subfields;

- (instancetype)initWithTag:(NSString *)tag data:(NSData *)data;

- (instancetype)initWithTag:(NSString *)tag
                 indicators:(NSArray<NSString *> *)indicators
                  subfields:(NSArray<BibRecordSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField;

@end

NS_ASSUME_NONNULL_END
