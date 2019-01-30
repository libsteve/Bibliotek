//
//  BibMarcRecordDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcRecordFieldTag;
@class BibMarcRecordFieldIndicator;
@class BibMarcRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord.DataField)
@interface BibMarcRecordDataField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, strong, readonly) BibMarcRecordFieldTag *tag;
@property (nonatomic, strong, readonly) BibMarcRecordFieldIndicator *firstIndicator;
@property (nonatomic, strong, readonly) BibMarcRecordFieldIndicator *secondIndicator;
@property (nonatomic, copy, readonly) NSArray<BibMarcRecordSubfield *> *subfields;

- (nullable instancetype)initWithTag:(BibMarcRecordFieldTag *)tag
                      firstIndicator:(BibMarcRecordFieldIndicator *)firstIndicator
                     secondIndicator:(BibMarcRecordFieldIndicator *)secondIndicator
                           subfields:(NSArray<BibMarcRecordSubfield *> *)subfields
                               error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibMarcRecordDataField *)other;

@end

NS_SWIFT_NAME(MarcRecord.MutableDataField)
@interface BibMarcRecordMutableDataField : BibMarcRecordDataField

@property (nonatomic, strong, readwrite) BibMarcRecordFieldTag *tag;
@property (nonatomic, strong, readwrite) BibMarcRecordFieldIndicator *firstIndicator;
@property (nonatomic, strong, readwrite) BibMarcRecordFieldIndicator *secondIndicator;
@property (nonatomic, copy, readwrite) NSArray<BibMarcRecordSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
