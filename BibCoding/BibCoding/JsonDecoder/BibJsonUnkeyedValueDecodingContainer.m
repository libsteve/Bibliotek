//
//  BibJsonUnkeyedValueDecodingContainer.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/14/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDecodable.h"
#import "BibDecoder.h"
#import "BibDecoderError.h"
#import "BibJsonDecoder.h"
#import "BibJsonUnkeyedValueDecodingContainer.h"

#define guard(predicate) if (!((predicate)))

@implementation BibJsonUnkeyedValueDecodingContainer {
    NSArray *_jsonArray;
    NSUInteger _nextIndex;
    NSString *_keyPath;
}

- (NSString *)keyPath {
    return _keyPath;
}

- (NSUInteger)count {
    return [_jsonArray count] - _nextIndex;
}

- (instancetype)init {
    return [self initWithKeyPath:@"" jsonRepresentation:[NSArray array]];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(NSArray *)jsonRepresentation {
    if (self = [super init]) {
        _jsonArray = [jsonRepresentation copy];
        _nextIndex = 0;
        _keyPath = [keyPath copy];
    }
    return self;
}

- (NSArray *)decodeArray:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSArray class] error:error];
}

- (NSDictionary *)decodeDictionary:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSDictionary class] error:error];
}

- (NSNumber *)decodeNumber:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSNumber class] error:error];
}

- (NSString *)decodeString:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSString class] error:error];
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
    BibDecoder *const decoder = [self containerDecoder:error];
    guard (decoder) {
        guard (error) { return nil; }
        NSMutableDictionary *const userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:objectClass forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    id object = [objectClass alloc];
    guard ([object conformsToProtocol:@protocol(BibDecodable)]) {
        guard(error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidClass
                                 userInfo:@{ BibDecoderErrorExpectedClassKey : objectClass }];
        return nil;
    }
    object = [object initWithDecoder:decoder error:error];
    guard (object) {
        guard (error) { return nil; }
        NSMutableDictionary *const userInfo = [[*error userInfo] mutableCopy];
        NSString *const keyPath = [userInfo objectForKey:BibDecoderErrorKeyPathKey];
        NSString *const key = [NSString stringWithFormat:@"[%lu]", (unsigned long)_nextIndex];
        NSString *fullKeyPath = nil;
        if ([keyPath hasPrefix:@"["]) {
            fullKeyPath = [NSString stringWithFormat:@"%@%@", key, keyPath];
        } else {
            fullKeyPath = keyPath ? [NSString stringWithFormat:@"%@.%@", key, keyPath] : key;
        }
        [userInfo setObject:fullKeyPath forKey:BibDecoderErrorKeyPathKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    _nextIndex += 1;
    return object;
}

- (NSArray *)decodeArrayWithObjectsOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    BibUnkeyedValueDecodingContainer *const decoder = [[self containerDecoder:error] unkeyedValueContainer:error];
    guard (decoder) {
        guard (error) { return nil; }
        NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:[NSArray class] forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    NSMutableArray *const array = [NSMutableArray array];
    while ([decoder count] > 0) {
        id const object = [decoder decodeObjectOfClass:objectClass error:error];
        guard (object) { return nil; }
        [array addObject:object];
    }
    return [array copy];
}

- (BibDecoder *)containerDecoder:(NSError *__autoreleasing *)error {
    id const object = [self jsonObject:error];
    guard (object) { return nil; }
    return [[BibJsonDecoder alloc] initWithKeyPath:[self keyPathByAppendingIndex:_nextIndex] jsonRepresentation:object];
}

#pragma mark -

- (NSString *)keyPathByAppendingIndex:(NSUInteger)index {
    return ([_keyPath length] == 0) ? [NSString stringWithFormat:@"[%lu]", (unsigned long)index]
                                    : [NSString stringWithFormat:@"%@[%lu]", _keyPath, (unsigned long)index];
}

- (id)jsonObject:(NSError *__autoreleasing *)error {
    guard ([self count] > 0) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorOutOfBounds
                                 userInfo:@{ BibDecoderErrorKeyPathKey : [self keyPathByAppendingIndex:_nextIndex] }];
        return nil;
    }
    return [_jsonArray objectAtIndex:_nextIndex];
}

- (id)jsonObjectOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    id const object = [self jsonObject:error];
    guard (object) {
        guard (error) { return nil; }
        NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
        [userInfo setObject:objectClass forKey:BibDecoderErrorExpectedClassKey];
        *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:[userInfo copy]];
        return nil;
    }
    guard ([object isKindOfClass:objectClass]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidData
                                 userInfo:@{ BibDecoderErrorKeyPathKey : [self keyPathByAppendingIndex:_nextIndex],
                                             BibDecoderErrorInvalidDataKey : object,
                                             BibDecoderErrorExpectedClassKey : objectClass }];
        return nil;
    }
    _nextIndex += 1;
    return object;
}

@end
