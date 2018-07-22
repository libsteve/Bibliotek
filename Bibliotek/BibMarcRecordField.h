//
//  BibMarcRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord.Field)
@interface BibMarcRecordField : NSObject <NSSecureCoding>

@property (nonatomic, readonly, strong) BibMarcRecordFieldTag fieldTag NS_SWIFT_NAME(tag);
@property (nonatomic, readonly, assign) BibMarcRecordFieldIndicator firstIndicator NS_REFINED_FOR_SWIFT;
@property (nonatomic, readonly, assign) BibMarcRecordFieldIndicator secondIndicator NS_REFINED_FOR_SWIFT;

- (instancetype)initWithFieldTag:(BibMarcRecordFieldTag)fieldTag firstIndicator:(BibMarcRecordFieldIndicator)firstIndicator secondIndicator:(BibMarcRecordFieldIndicator)secondIndicator subfields:(NSDictionary<NSString *, NSString *> *)subfields NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(tag:first:second:subfields:));

- (nullable instancetype)initWithJson:(NSDictionary<NSString *, id> *)json NS_SWIFT_NAME(init(json:));

- (nullable NSString *)objectAtIndexedSubscript:(BibMarcRecordFieldCode)subfieldCode;

#pragma mark - Unavailable

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
