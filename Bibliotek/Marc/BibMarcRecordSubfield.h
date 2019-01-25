//
//  BibMarcRecordSubfield.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord.Subfield)
@interface BibMarcRecordSubfield : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *content;

- (instancetype)initWithCode:(NSString *)code content:(NSString *)content NS_DESIGNATED_INITIALIZER;

+ (instancetype)subfieldWithCode:(NSString *)code content:(NSString *)content NS_SWIFT_UNAVAILABLE("Use init(code:content:)");

- (BOOL)isEqualToSubfield:(BibMarcRecordSubfield *)other;

@end

NS_SWIFT_NAME(MarcRecord.MutableSubfield)
@interface BibMarcRecordMutableSubfield : BibMarcRecordSubfield

@property (nonatomic, copy, readwrite) NSString *code;
@property (nonatomic, copy, readwrite) NSString *content;

@end

NS_ASSUME_NONNULL_END
