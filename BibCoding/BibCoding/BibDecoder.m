//
//  BibDecoder.m
//  BibCoding
//
//  Created by Steve Brunwasser on 2/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#include "BibDecodable.h"
#include "BibDecoder.h"
#include "BibDecoderError.h"

#define BIB_UNIMPLEMENTED                               \
    [NSException raise:NSInternalInconsistencyException \
                format:@"-[%@ %@] is unimplemented", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]

#define guard(predicate) if (!((predicate)))

#pragma mark -

@implementation BibDecoder

- (NSString *)keyPath {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSString *)mimeType {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (BibKeyedValueDecodingContainer *)keyedValueContainer:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (BibUnkeyedValueDecodingContainer *)unkeyedValueContainer:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (BibSingleValueDecodingContainer *)singleValueContainer:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

@end

#pragma mark -

@implementation BibKeyedValueDecodingContainer : NSObject

- (NSString *)keyPath {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSArray *)decodeArrayForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSDictionary *)decodeDictionaryForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSNumber *)decodeNumberForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSString *)decodeStringForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (BibDecoder *)nestedDecoderForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (id)decodeObjectOfClass:(Class)objectClass forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    guard ([objectClass conformsToProtocol:@protocol(BibDecodable)]) {
        guard(error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidClass
                                 userInfo:@{ BibDecoderErrorKeyPathKey : [self keyPath],
                                             BibDecoderErrorInvalidClassKey : objectClass }];
        return nil;
    }
    BibDecoder *const decoder = [self nestedDecoderForKey:key error:error];
    BibSingleValueDecodingContainer *const container = [decoder singleValueContainer:error];
    guard (container) {
        guard (error) { return nil; }
        NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:objectClass forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    return [container decodeObjectOfClass:objectClass error:error];
}

- (NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    BibDecoder *const decoder = [self nestedDecoderForKey:key error:error];
    BibSingleValueDecodingContainer *const container = [decoder singleValueContainer:error];
    guard (container) {
        guard (error) { return nil; }
        NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:[NSArray class] forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    return [container decodeArrayWithObjectsOfClass:objectClass error:error];
}

@end

#pragma mark -

@implementation BibUnkeyedValueDecodingContainer : NSObject

- (NSString *)keyPath {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSUInteger)count {
    BIB_UNIMPLEMENTED;
    return NSNotFound;
}

- (NSArray *)decodeArray:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSDictionary *)decodeDictionary:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSNumber *)decodeNumber:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSString *)decodeString:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (BibDecoder *)nestedDecoder:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (id)decodeObjectOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

@end

#pragma mark -

@implementation BibSingleValueDecodingContainer : NSObject

- (NSString *)keyPath {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSArray *)decodeArray:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSDictionary *)decodeDictionary:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSNumber *)decodeNumber:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (NSString *)decodeString:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (BibDecoder *)nestedDecoder:(NSError *__autoreleasing *)error {
    BIB_UNIMPLEMENTED;
    return nil;
}

- (id)decodeObjectOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    if ([objectClass isEqual:[NSArray class]]) {
        return [self decodeArray:error];
    } else if ([objectClass isEqual:[NSDictionary class]]) {
        return [self decodeDictionary:error];
    } else if ([objectClass isEqual:[NSNumber class]]) {
        return [self decodeNumber:error];
    } else if ([objectClass isEqual:[NSString class]]) {
        return [self decodeString:error];
    }
    guard ([objectClass conformsToProtocol:@protocol(BibDecodable)]) {
        guard(error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidClass
                                 userInfo:@{ BibDecoderErrorKeyPathKey : [self keyPath],
                                             BibDecoderErrorInvalidClassKey : objectClass }];
        return nil;
    }
    BibDecoder *const decoder = [self nestedDecoder:error];
    guard (decoder) {
        guard (error) { return nil; }
        NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:objectClass forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    return [[objectClass alloc] initWithDecoder:decoder error:error];
}

- (NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    BibDecoder *const decoder = [self nestedDecoder:error];
    BibUnkeyedValueDecodingContainer *const container = [decoder unkeyedValueContainer:error];
    guard (decoder) {
        guard (error) { return nil; }
        NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:[NSArray class] forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    NSMutableArray *const array = [NSMutableArray arrayWithCapacity:[container count]];
    while ([container count] > 0) {
        id const object = [container decodeObjectOfClass:objectClass error:error];
        guard (object) { return nil; }
        [array addObject:object];
    }
    return [array copy];
}

@end
