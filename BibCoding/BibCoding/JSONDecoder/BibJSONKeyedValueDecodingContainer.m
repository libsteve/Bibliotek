//
//  BibJSONKeyedValueDecodingContainer.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/14/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDecodable.h"
#import "BibDecoder.h"
#import "BibDecoderError.h"
#import "BibJSONDecoder.h"
#import "BibJSONKeyedValueDecodingContainer.h"

#define guard(predicate) if (!((predicate)))

@implementation BibJSONKeyedValueDecodingContainer {
    NSDictionary *_jsonDictionary;
    NSString *_keyPath;
}

- (NSString *)keyPath {
    return _keyPath;
}

- (instancetype)init {
    return [self initWithKeyPath:@"" jsonRepresentation:[NSDictionary dictionary]];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(NSDictionary *)jsonRepresentation {
    if (self = [super init]) {
        _keyPath = [keyPath copy];
        _jsonDictionary = [jsonRepresentation copy];
    }
    return self;
}

#pragma mark -

- (NSArray *)decodeArrayForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSArray class] forKey:key error:error];
}

- (NSDictionary *)decodeDictionaryForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSDictionary class] forKey:key error:error];
}

- (NSNumber *)decodeNumberForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSNumber class] forKey:key error:error];
}

- (NSString *)decodeStringForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [self jsonObjectOfClass:[NSString class] forKey:key error:error];
}

- (BibDecoder *)containerDecoderForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    id const object = [self jsonObjectForKey:key error:error];
    guard (object) { return nil; }
    return [[BibJSONDecoder alloc] initWithKeyPath:[self keyPathByAppendingKey:key] jsonRepresentation:object];
}

#pragma mark -

- (NSString *)keyPathByAppendingKey:(NSString *)key {
    return ([_keyPath length] == 0) ? key : [NSString stringWithFormat:@"%@.%@", _keyPath, key];
}

- (id)jsonObjectForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    id const object = [_jsonDictionary objectForKey:key];
    guard (object) {
        guard (error) { return nil; }
        NSString *const keyPath = [self keyPathByAppendingKey:key];
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorMissingKeyedValue
                                 userInfo:@{ BibDecoderErrorKeyPathKey : keyPath }];
        return nil;
    }
    return object;
}

- (id)jsonObjectOfClass:(Class)objectClass forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    id const object = [self jsonObjectForKey:key error:error];
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
                                 userInfo:@{ BibDecoderErrorKeyPathKey : key,
                                             BibDecoderErrorInvalidDataKey : object,
                                             BibDecoderErrorExpectedClassKey : objectClass }];
        return nil;
    }
    return object;
}

@end
