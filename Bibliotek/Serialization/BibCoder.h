//
//  BibCoder.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/6/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BibDecoder <NSObject>

- (id)decodeObjectOfClass:(Class)class
                   forKey:(NSString *)key
                    error:(NSError *_Nullable __autoreleasing *_nullable)error;

- (id)decodeUnkeyedObjectOfClass:(Class)class error:(NSError *_Nullable __autoreleasing *_nullable)error;

@end

@protocol BibEncoder <NSObject>

- (void)encodeObject:(id)object forKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (void)encodeObjecy:(id)object error:(NSError *_Nullable __autoreleasing (_Nullable))error;

@end

NS_ASSUME_NONNULL_END
