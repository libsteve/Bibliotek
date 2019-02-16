//
//  BibJSONKeyedValueDecodingContainer.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/14/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface BibJSONKeyedValueDecodingContainer : BibKeyedValueDecodingContainer

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(NSDictionary *)jsonRepresentation NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
