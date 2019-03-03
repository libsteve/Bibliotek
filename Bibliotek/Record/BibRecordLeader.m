//
//  BibRecordLeader.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordLeader.h"

static NSNumberFormatter *sNumberFormatter;

static NSRange const kRecordLengthRange       = { 0, 5};
static NSRange const kRecordStatusRange       = { 5, 1};
static NSRange const kRecordTypeRange         = { 6, 1};
static NSRange const kCharacterCodingRange    = { 9, 1};
static NSRange const kRecordBodyLocationRange = {12, 5};

@implementation BibRecordLeader

+ (void)initialize {
    sNumberFormatter = [NSNumberFormatter new];
    [sNumberFormatter setNumberStyle:NSNumberFormatterNoStyle];
}

- (BibRecordStatus)recordStatus { return [_stringValue substringWithRange:kRecordStatusRange]; }

- (BibRecordKind)recordType { return [_stringValue substringWithRange:kRecordTypeRange]; }

- (BibRecordCharacterCodingScheme)characterCodingScheme {
    return [_stringValue substringWithRange:kCharacterCodingRange];
}

- (instancetype)init {
    return [self initWithString:@"00024aa  a0000024   4500"];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
}

- (instancetype)initWithString:(NSString *)stringValue {
    if (self = [super init]) {
        _stringValue = [stringValue copy];
        NSString *const recordLengthString = [stringValue substringWithRange:kRecordLengthRange];
        NSString *const recordBodyLocationString = [stringValue substringWithRange:kRecordBodyLocationRange];
        _recordLength = [[sNumberFormatter numberFromString:recordLengthString] unsignedIntegerValue];
        _recordBodyLocation = [[sNumberFormatter numberFromString:recordBodyLocationString] unsignedIntegerValue];
    }
    return self;
}

- (NSString *)description {
    return _stringValue;
}

#pragma mark - Equality

- (BOOL)isEqualToLeader:(BibRecordLeader *)leader {
    return [_stringValue isEqualToString:[leader stringValue]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordLeader class]] && [self isEqualToLeader:other]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

@end
