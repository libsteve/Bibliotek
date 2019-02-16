//
//  BibDecoder.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/15/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibKeyedValueDecodingContainer;
@class BibUnkeyedValueDecodingContainer;
@class BibSingleValueDecodingContainer;

NS_ASSUME_NONNULL_BEGIN

@interface BibDecoder : NSObject

@property (nonatomic, copy, readonly) NSString *keyPath;

@property (nonatomic, copy, readonly) NSString *mimeType;

- (nullable BibKeyedValueDecodingContainer *)keyedValueContainer:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibUnkeyedValueDecodingContainer *)unkeyedValueContainer:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibSingleValueDecodingContainer *)singleValueContainer:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark -

@interface BibKeyedValueDecodingContainer : NSObject

#pragma mark Required

@property (nonatomic, copy, readonly) NSString *keyPath;

- (nullable NSArray *)decodeArrayForKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSDictionary *)decodeDictionaryForKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSNumber *)decodeNumberForKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSString *)decodeStringForKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibDecoder *)nestedDecoderForKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

#pragma mark Optional

- (nullable id)decodeObjectOfClass:(Class)objectClass forKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass forKey:(NSString *)key error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark -

@interface BibUnkeyedValueDecodingContainer : NSObject

#pragma mark Required

@property (nonatomic, copy, readonly) NSString *keyPath;

@property (nonatomic, assign, readonly) NSUInteger count;

- (nullable NSArray *)decodeArray:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSDictionary *)decodeDictionary:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSNumber *)decodeNumber:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSString *)decodeString:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibDecoder *)nestedDecoder:(NSError *_Nullable __autoreleasing *_Nullable)error;

#pragma mark Optional

- (nullable id)decodeObjectOfClass:(Class)objectClass error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark -

@interface BibSingleValueDecodingContainer : NSObject

#pragma mark Required

@property (nonatomic, copy, readonly) NSString *keyPath;

- (nullable NSArray *)decodeArray:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSDictionary *)decodeDictionary:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSNumber *)decodeNumber:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSString *)decodeString:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibDecoder *)nestedDecoder:(NSError *_Nullable __autoreleasing *_Nullable)error;

#pragma mark Optional

- (nullable id)decodeObjectOfClass:(Class)objectClass error:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
