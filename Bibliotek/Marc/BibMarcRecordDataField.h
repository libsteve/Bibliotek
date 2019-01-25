//
//  BibMarcRecordDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcRecordFieldTag;
@class BibMarcRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord.DataField)
@interface BibMarcRecordDataField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, strong, readonly) BibMarcRecordFieldTag *tag;
@property (nonatomic, copy, readonly, nullable) NSString *firstIndicator;
@property (nonatomic, copy, readonly, nullable) NSString *secondIndicator;
@property (nonatomic, copy, readonly) NSArray<BibMarcRecordSubfield *> *subfields;

- (instancetype)initWithTag:(BibMarcRecordFieldTag *)tag
             firstIndicator:(nullable NSString *)firstIndicator
            secondIndicator:(nullable NSString *)secondIndicator
                  subfields:(NSArray<BibMarcRecordSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibMarcRecordDataField *)other;

@end

NS_SWIFT_NAME(MarcRecord.MutableDataField)
@interface BibMarcRecordMutableDataField : BibMarcRecordDataField

@property (nonatomic, strong, readwrite) BibMarcRecordFieldTag *tag;
@property (nonatomic, copy, readwrite, nullable) NSString *firstIndicator;
@property (nonatomic, copy, readwrite, nullable) NSString *secondIndicator;
@property (nonatomic, copy, readwrite) NSArray<BibMarcRecordSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
