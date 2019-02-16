//
//  BibJSONDecoder.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDecodable.h"
#import "BibDecoderError.h"
#import "BibJSONDecoder.h"
#import "BibJSONKeyedValueDecodingContainer.h"
#import "BibJSONUnkeyedValueDecodingContainer.h"
#import "BibJSONSingleValueDecodingContainer.h"

#define guard(predicate) if (!((predicate)))

#pragma mark -

@implementation BibJSONDecoder {
    NSString *_keyPath;
}

@synthesize jsonRepresentation = _jsonRepresentation;

- (NSString *)keyPath {
    return _keyPath;
}

- (NSString *)mimeType {
    return @"application/json; charset=utf-8";
}

- (instancetype)init {
    return [self initWithKeyPath:@"" jsonRepresentation:[NSDictionary dictionary]];
}

- (instancetype)initWithJsonRepresentation:(id)jsonRepresentation {
    return [self initWithKeyPath:@"" jsonRepresentation:jsonRepresentation];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath jsonRepresentation:(id)jsonRepresentation {
    if (self = [super init]) {
        _keyPath = [keyPath copy];
        _jsonRepresentation = [jsonRepresentation copy];
    }
    return self;
}

- (nullable instancetype)initWithData:(NSData *)data error:(NSError *_Nullable __autoreleasing *_Nullable)error {
    id jsonRepresentation = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    return [self initWithJsonRepresentation:jsonRepresentation];
}

- (BibKeyedValueDecodingContainer *)keyedValueContainer:(NSError *__autoreleasing *)error {
    guard ([_jsonRepresentation isKindOfClass:[NSDictionary class]]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidData
                                 userInfo:@{ BibDecoderErrorInvalidDataKey : _jsonRepresentation,
                                             BibDecoderErrorExpectedClassKey : [NSDictionary class],
                                             BibDecoderErrorKeyPathKey: _keyPath }];
        return nil;
    }
    return [[BibJSONKeyedValueDecodingContainer alloc] initWithKeyPath:[self keyPath] jsonRepresentation:_jsonRepresentation];
}

- (BibUnkeyedValueDecodingContainer *)unkeyedValueContainer:(NSError *__autoreleasing *)error {
    guard ([_jsonRepresentation isKindOfClass:[NSArray class]]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:BibDecoderErrorDomain
                                     code:BibDecoderErrorInvalidData
                                 userInfo:@{ BibDecoderErrorInvalidDataKey : _jsonRepresentation,
                                             BibDecoderErrorExpectedClassKey : [NSArray class],
                                             BibDecoderErrorKeyPathKey: _keyPath }];
        return nil;
    }
    return [[BibJSONUnkeyedValueDecodingContainer alloc] initWithKeyPath:[self keyPath] jsonRepresentation:_jsonRepresentation];
}

- (BibSingleValueDecodingContainer *)singleValueContainer:(NSError *__autoreleasing *)error {
    return [[BibJSONSingleValueDecodingContainer alloc] initWithKeyPath:[self keyPath] jsonRepresentation:_jsonRepresentation];
}

@end
