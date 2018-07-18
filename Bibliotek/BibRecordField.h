//
//  BibRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Record.Field)
@interface BibRecordField : NSObject <NSSecureCoding>

@property (nonatomic, readonly, strong) BibRecordFieldTag fieldTag NS_SWIFT_NAME(tag);
@property (nonatomic, readonly, assign) BibRecordFieldIndicator firstIndicator NS_REFINED_FOR_SWIFT;
@property (nonatomic, readonly, assign) BibRecordFieldIndicator secondIndicator NS_REFINED_FOR_SWIFT;

- (instancetype)initWithFieldTag:(BibRecordFieldTag)fieldTag firstIndicator:(BibRecordFieldIndicator)firstIndicator secondIndicator:(BibRecordFieldIndicator)secondIndicator subfields:(NSDictionary<NSString *, NSString *> *)subfields NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(tag:first:second:subfields:));

- (nullable instancetype)initWithJson:(NSDictionary<NSString *, id> *)json NS_SWIFT_NAME(init(json:));

- (nullable NSString *)objectAtIndexedSubscript:(BibRecordFieldCode)subfieldCode;

#pragma mark - Unavailable

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
