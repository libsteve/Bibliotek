//
//  BibMarcRecordTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibMarcRecordTag : NSObject

@property (nonatomic, readonly, copy) NSString *stringValue;

- (nullable instancetype)initWithString:(NSString *)stringValue;

- (nullable instancetype)initWithString:(NSString *)stringValue
                                  error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
