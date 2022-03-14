//
//  BibMARCXMLSerialization.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/6/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibMARCXMLSerialization : NSObject

+ (nullable NSArray<BibRecord *> *)recordsFromData:(NSData *)data
                                             error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

+ (nullable BibRecord *)recordFromStream:(NSInputStream *)inputStream
                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
