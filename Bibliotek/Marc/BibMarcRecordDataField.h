//
//  BibMarcRecordDataField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcRecordSubfield;

NS_ASSUME_NONNULL_BEGIN

@interface BibMarcRecordDataField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, readonly, copy) NSString *tag;
@property (nonatomic, readonly, copy, nullable) NSString *firstIndicator;
@property (nonatomic, readonly, copy, nullable) NSString *secondIndicator;
@property (nonatomic, readonly, copy) NSArray<BibMarcRecordSubfield *> *subfields;

- (instancetype)initWithTag:(NSString *)tag
             firstIndicator:(nullable NSString *)firstIndicator
            secondIndicator:(nullable NSString *)secondIndicator
                  subfields:(NSArray<BibMarcRecordSubfield *> *)subfields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDataField:(BibMarcRecordDataField *)other;

@end

@interface BibMarcRecordMutableDataField : BibMarcRecordDataField

@property (nonatomic, readwrite, copy) NSString *tag;
@property (nonatomic, readwrite, copy, nullable) NSString *firstIndicator;
@property (nonatomic, readwrite, copy, nullable) NSString *secondIndicator;
@property (nonatomic, readwrite, copy) NSArray<BibMarcRecordSubfield *> *subfields;

@end

NS_ASSUME_NONNULL_END
