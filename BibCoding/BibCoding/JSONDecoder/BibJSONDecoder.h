//
//  BibJsonDecoder.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface BibJSONDecoder : BibDecoder

@property (nonatomic, copy, readonly) id jsonRepresentation;

- (instancetype)initWithJsonRepresentation:(id)jsonRepresentation;

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(id)jsonRepresentation;

- (nullable instancetype)initWithData:(NSData *)data error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
