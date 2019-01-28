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

@property (nonatomic, copy, readonly) NSString *tag;
@property (nonatomic, copy, readonly) NSString *firstIndicator;
@property (nonatomic, copy, readonly) NSString *secondIndicator;
@property (nonatomic, copy, readonly) NSArray<BibMarcRecordSubfield *> *subfields;

- (nullable instancetype)initWithTag:(NSString *)tag
                      firstIndicator:(NSString *)firstIndicator
                     secondIndicator:(NSString *)secondIndicator
                           subfields:(NSArray<BibMarcRecordSubfield *> *)subfields
                               error:(NSError *_Nullable __autoreleasing *_Nullable)error NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibMarcRecordDataField *)other;

@end

NS_SWIFT_NAME(MarcRecord.MutableDataField)
@interface BibMarcRecordMutableDataField : BibMarcRecordDataField

@property (nonatomic, copy, readwrite) NSString *tag;
@property (nonatomic, copy, readwrite, nullable) NSString *firstIndicator;
@property (nonatomic, copy, readwrite, nullable) NSString *secondIndicator;
@property (nonatomic, copy, readwrite) NSArray<BibMarcRecordSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
