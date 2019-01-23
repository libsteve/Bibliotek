//
//  BibMarcRecordSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibMarcRecordSubfield : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, readonly, copy) NSString *code;
@property (nonatomic, readonly, copy) NSString *content;

- (instancetype)initWithCode:(NSString *)code content:(NSString *)content NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToSubfield:(BibMarcRecordSubfield *)other;

@end

@interface BibMarcRecordMutableSubfield : BibMarcRecordSubfield

@property (nonatomic, readwrite, copy) NSString *code;
@property (nonatomic, readwrite, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
