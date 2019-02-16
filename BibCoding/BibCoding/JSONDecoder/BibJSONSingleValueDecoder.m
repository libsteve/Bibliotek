//
//  BibJSONSingleValueDecodingContainer.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/14/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDecodable.h"
#import "BibDecoder.h"
#import "BibDecoderError.h"
#import "BibJSONDecoder.h"
#import "BibJSONSingleValueDecodingContainer.h"

#define guard(predicate) if (!((predicate)))

@implementation BibJSONSingleValueDecodingContainer {
    id _jsonRepresentation;
    NSString *_keyPath;
}

- (instancetype)init {
    return [self initWithKeyPath:@"" jsonRepresentation:[NSDictionary dictionary]];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(id)jsonRepresentation {
    if (self = [super init]) {
        _jsonRepresentation = [jsonRepresentation copy];
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

- (BibDecoder *)containerDecoder:(NSError *__autoreleasing *)error {
    return [[BibJSONDecoder alloc] initWithKeyPath:_keyPath jsonRepresentation:_jsonRepresentation];
}

#pragma mark -

- (id)jsonObjectOfClass:(Class)objectClass error:(NSError *__autoreleasing *)error {
    guard ([_jsonRepresentation isKindOfClass:objectClass]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidData
                                 userInfo:@{ BibDecoderErrorInvalidDataKey : _jsonRepresentation,
                                             BibDecoderErrorExpectedClassKey : objectClass,
                                             BibDecoderErrorKeyPathKey : _keyPath }];
        return nil;
    }
    return _jsonRepresentation;
}

@end
