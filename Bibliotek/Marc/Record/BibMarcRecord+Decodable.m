//
//  BibMarcRecord+Decodable.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibConstants.h"
#import "BibMarcControlField.h"
#import "BibMarcDataField.h"
#import "BibMarcLeader.h"
#import "BibMarcRecord+Decodable.h"

#define guard(predicate) if (!((predicate)))

static NSString *const kLeaderKey = @"leader";
static NSString *const kFieldsKey = @"fields";

@implementation BibMarcRecord (Decodable)

static NSArray *decodeObjectsOfClassFromDecoder(Class objectClass, BibDecoder *decoder) {
    BibUnkeyedValueDecodingContainer *const container = [decoder unkeyedValueContainer:NULL];
    NSMutableArray *const array = [NSMutableArray array];
    for (NSUInteger index = 0; index < [container count]; index += 1) {
        id const object = [container decodeObjectOfClass:objectClass error:NULL];
        guard (object) { continue; }
        [array addObject:object];
    }
    return [array copy];
}

- (instancetype)initWithDecoder:(BibDecoder *)decoder error:(NSError *__autoreleasing *)error {
    guard ([[decoder mimeType] containsString:@"application/json"]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:@"brun.steve.bibliotek.marc-record.decoder" code:1 userInfo:nil];
        return nil;
    }
    BibKeyedValueDecodingContainer *const container = [decoder keyedValueContainer:error];
    BibMarcLeader *const leader = [container decodeObjectOfClass:[BibMarcLeader class] forKey:kLeaderKey error:error];
    guard (leader) { return nil; }
    BibDecoder *nestedDecoder = [container nestedDecoderForKey:kFieldsKey error:error];
    guard (nestedDecoder) { return nil; }
    NSArray *controlFields = decodeObjectsOfClassFromDecoder([BibMarcControlField class], nestedDecoder);
    NSArray *dataFields = decodeObjectsOfClassFromDecoder([BibMarcDataField class], nestedDecoder);
    return [self initWithLeader:leader controlFields:controlFields dataFields:dataFields];
}

@end
