//
//  BibMarcRecordControlField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcRecordFieldTag;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord.ControlField)
@interface BibMarcRecordControlField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, copy, readonly) NSString *tag;
@property (nonatomic, copy, readonly) NSString *content;

- (nullable instancetype)initWithTag:(NSString *)tag
                             content:(NSString *)content
                               error:(NSError *__autoreleasing *)error NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)controlFieldWithTag:(NSString *)tag
                                     content:(NSString *)content
                                       error:(NSError *__autoreleasing *)error NS_SWIFT_UNAVAILABLE("Use init(tag:content:)");

- (BOOL)isEqualToControlField:(BibMarcRecordControlField *)other;

@end

NS_SWIFT_NAME(MarcRecord.MutableControlField)
@interface BibMarcRecordMutableControlField : BibMarcRecordControlField

@property (nonatomic, copy, readwrite) NSString *tag;
@property (nonatomic, copy, readwrite) NSString *content;

@end

NS_ASSUME_NONNULL_END
