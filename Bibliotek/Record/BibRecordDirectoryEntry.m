//
//  BibRecordDirectoryEntry.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordDirectoryEntry.h"

static NSNumberFormatter *sNumberFormatter;

static NSRange const kFieldTagRange      = {0, 3};
static NSRange const kFieldLengthRange   = {3, 4};
static NSRange const kFieldLocationRange = {7, 5};

@implementation BibRecordDirectoryEntry

+ (void)initialize {
    sNumberFormatter = [NSNumberFormatter new];
}

- (instancetype)init {
    return [self initWithFieldTag:@"000" length:0 location:0];
}

- (instancetype)initWithData:(NSData *)data {
    NSString *const fieldTag = [[NSString alloc] initWithData:[data subdataWithRange:kFieldTagRange]
                                                     encoding:NSASCIIStringEncoding];
    NSString *const fieldLengthString = [[NSString alloc] initWithData:[data subdataWithRange:kFieldLengthRange]
                                                              encoding:NSASCIIStringEncoding];
    NSString *const fieldLocationString = [[NSString alloc] initWithData:[data subdataWithRange:kFieldLocationRange]
                                                                encoding:NSASCIIStringEncoding];
    return [self initWithFieldTag:fieldTag
                           length:[[sNumberFormatter numberFromString:fieldLengthString] unsignedIntegerValue]
                         location:[[sNumberFormatter numberFromString:fieldLocationString] unsignedIntegerValue]];
}

- (instancetype)initWithFieldTag:(NSString *)fieldTag length:(NSUInteger)fieldLength location:(NSUInteger)fieldLocation {
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        _fieldLength = fieldLength;
        _fieldLocation = fieldLocation;
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToEntry:(BibRecordDirectoryEntry *)entry {
    return [_fieldTag isEqualToString:[entry fieldTag]]
        && _fieldLength == [entry fieldLength]
        && _fieldLocation == [entry fieldLocation];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordDirectoryEntry class]] && [self isEqualToEntry:other]);
}

- (NSUInteger)hash {
    return [_fieldTag hash] ^ _fieldLength ^ _fieldLocation;
}

@end
