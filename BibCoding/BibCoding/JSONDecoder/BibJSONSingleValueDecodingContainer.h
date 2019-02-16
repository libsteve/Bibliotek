//
//  BibJSONSingleValueDecodingContainer.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/14/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface BibJSONSingleValueDecodingContainer : BibSingleValueDecodingContainer

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(id)jsonRepresentation;

@end

NS_ASSUME_NONNULL_END
