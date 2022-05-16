//
//  BibRecordOutputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/8/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import "BibRecordOutputStream.h"
#import "Bibliotek+Internal.h"

@implementation BibRecordOutputStream

@dynamic streamStatus;
- (NSStreamStatus)streamStatus {
    BibUnimplementedPropertyFrom(BibRecordOutputStream);
}

@dynamic streamError;
- (NSError *)streamError {
    BibUnimplementedPropertyFrom(BibRecordOutputStream);
}

@dynamic hasSpaceAvailable;
- (BOOL)hasSpaceAvailable {
    BibUnimplementedPropertyFrom(BibRecordOutputStream);
}

@dynamic data;
- (NSData *)data {
    BibUnimplementedPropertyFrom(BibRecordOutputStream);
}

#pragma mark -

//- (instancetype)init {
//    return [self initToMemory];
//}

- (instancetype)initToMemory {
    return [self initWithOutputStream:[NSOutputStream outputStreamToMemory]];
}

- (instancetype)initWithURL:(NSURL *)url append:(BOOL)shouldAppend {
    return [self initWithOutputStream:[NSOutputStream outputStreamWithURL:url append:shouldAppend]];
}

- (nullable instancetype)initWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
    NSOutputStream *const outputStream = [NSOutputStream outputStreamToFileAtPath:path append:shouldAppend];
    return (outputStream) ? [self initWithOutputStream:outputStream] : nil;
}

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream {
    BibUnimplementedInitializerFrom(BibRecordOutputStream);
}

#pragma mark -

+ (instancetype)outputStreamToMemory {
    return [[self alloc] initToMemory];
}

+ (instancetype)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend {
    return [[self alloc] initWithURL:url append:shouldAppend];
}

+ (instancetype)outputStreamWithFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
    return [[self alloc] initWithFileAtPath:path append:shouldAppend];
}

+ (instancetype)outputStreamWithOutputStream:(NSOutputStream *)outputStream {
    return [[self alloc] initWithOutputStream:outputStream];
}

#pragma mark -

- (instancetype)open {
    BibUnimplementedMethodFrom(BibRecordOutputStream);
}

- (instancetype)close {
    BibUnimplementedMethodFrom(BibRecordOutputStream);
}

- (BOOL)writeRecord:(BibRecord *)record error:(out NSError * _Nullable __autoreleasing *)error {
    BibUnimplementedMethodFrom(BibRecordOutputStream);
}

@end
