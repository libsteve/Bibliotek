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
    [sNumberFormatter setNumberStyle:NSNumberFormatterNoStyle];
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithData:(NSData *)data {
    NSString *const fieldTag = [[NSString alloc] initWithData:[data subdataWithRange:kFieldTagRange]
                                                     encoding:NSASCIIStringEncoding];
    NSString *const fieldLengthString = [[NSString alloc] initWithData:[data subdataWithRange:kFieldLengthRange]
                                                              encoding:NSASCIIStringEncoding];
    NSString *const fieldLocationString = [[NSString alloc] initWithData:[data subdataWithRange:kFieldLocationRange]
                                                                encoding:NSASCIIStringEncoding];
    NSUInteger const fieldLength = [[sNumberFormatter numberFromString:fieldLengthString] unsignedIntegerValue];
    NSUInteger const fieldLocation = [[sNumberFormatter numberFromString:fieldLocationString] unsignedIntegerValue];
    NSRange const fieldRange = NSMakeRange(fieldLocation, fieldLength);
    return [self initWithFieldTag:fieldTag range:fieldRange];
}

- (instancetype)initWithFieldTag:(NSString *)fieldTag range:(NSRange)fieldRange {
    if (self = [super init]) {
        _fieldTag = [fieldTag copy];
        _fieldRange = fieldRange;
        _fieldKind = [_fieldTag hasPrefix:@"00"] ? BibRecordFieldKindControlField : BibRecordFieldKindDatField;
    }
    return self;
}

- (NSString *)description {
    unsigned long location = _fieldRange.location;
    unsigned long length = _fieldRange.length;
    return [NSString stringWithFormat:@"[tag: %@, location: %lu, length: %lu]", _fieldTag, location, length];
}

#pragma mark - Equality

- (BOOL)isEqualToEntry:(BibRecordDirectoryEntry *)entry {
    return [_fieldTag isEqualToString:[entry fieldTag]]
        && NSEqualRanges(_fieldRange, [entry fieldRange]);
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordDirectoryEntry class]] && [self isEqualToEntry:other]);
}

- (NSUInteger)hash {
    return [_fieldTag hash] ^ _fieldRange.location ^ _fieldRange.length;
}

@end
