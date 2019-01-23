//
//  BibMarcRecordControlField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibMarcRecordControlField : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, readonly, copy) NSString *tag;
@property (nonatomic, readonly, copy) NSString *content;

- (instancetype)initWithTag:(NSString *)tag content:(NSString *)content NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToControlField:(BibMarcRecordControlField *)other;

@end

@interface BibMarcRecordMutableControlField : BibMarcRecordControlField

@property (nonatomic, readwrite, copy) NSString *tag;
@property (nonatomic, readwrite, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
