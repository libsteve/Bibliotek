//
//  BibDecodable.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibDecoder;

NS_ASSUME_NONNULL_BEGIN

@protocol BibDecodable <NSObject>

- (nullable instancetype)initWithDecoder:(BibDecoder *)decoder error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
