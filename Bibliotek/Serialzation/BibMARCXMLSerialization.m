//
//  BibMARCXMLSerialization.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/6/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import "BibMARCXMLSerialization.h"
#import <Bibliotek/Bibliotek.h>

@implementation BibMARCXMLSerialization

+ (NSArray<BibRecord *> *)recordsFromData:(NSData *)data error:(out NSError * _Nullable __autoreleasing *)error {
    BibRecordInputStream *inputStream = [[[BibMARCXMLInputStream alloc] initWithData:data] open];
    if ([inputStream streamStatus] == NSStreamStatusError) {
        if (error != NULL) {
            *error = [inputStream streamError];
        }
        return nil;
    }
    BOOL success = YES;
    BibRecord *record = nil;
    NSMutableArray *collection = [NSMutableArray new];
    while ((success = [inputStream readRecord:&record error:error]) && record != nil) {
        [collection addObject:record];
    }
    return (success) ? [collection copy] : nil;
}

+ (BibRecord *)recordFromStream:(NSInputStream *)inputStream error:(NSError *__autoreleasing *)error {
    BibMARCXMLInputStream *stream = [[[BibMARCXMLInputStream alloc] initWithInputStream:inputStream] open];
    if ([stream streamStatus] == NSStreamStatusError) {
        if (error != NULL) {
            *error = [stream streamError];
        }
        return nil;
    }
    BibRecord *record = nil;
    if (![stream readRecord:&record error:error]) {
        return nil;
    }
    return record;
}

@end
