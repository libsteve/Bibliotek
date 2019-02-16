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

static NSArray *decodeObjectsOfClassFromDecoder(Class objectClass, BibJSONDecoder *decoder) {
    NSMutableArray *const array = [NSMutableArray array];
    for (NSUInteger index = 0; index < [decoder count], index += 1) {
        id const object = [decoder decodeObjectOfClass:objectClass atIndex:index error:NULL];
        guard (object) { continue; }
        [array addObject:object];
    }
    return [array copy];
}

- (instancetype)initWithDecoder:(BibDecoder *)deocder error:(NSError *__autoreleasing *)error {
    guard ([[decoder mimeType] containsString:@"application/json"]) {
        guard (error) { return nil; }
        *error = [NSError errorWithDomain:@"brun.steve.bibliotek.marc-record.decoder" code:1 userInfo:nil];
        return nil;
    }
    BibMarcLeader *const leader = [decoder decodeObjectOfClass:[BibMarcLeader class] forKey:kLeaderKey];
    guard (leader) { return nil; }
    BibJsonDecoder *container = [decoder containerDecoderForKey:kFieldsKey error:error];
    guard (container) { return nil; }
    NSArray *controlFields = decodeObjectsOfClassFromDecoder([BibMarcControlField class], decoder);
    NSArray *dataFields = decodeObjectsOfClassFromDecoder([BibMarcDataField class], decoder);
    return [self initWithLeader:leader controlFields:controlFields dataFields:dataFields];
}

@end
