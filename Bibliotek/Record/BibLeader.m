//
//  BibLeader.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibLeader.h"

NSUInteger const BibLeaderRawDataLength = 24;

static NSRange const kRecordLengthRange   = { 0, 5};
static NSRange const kRecordStatusRange   = { 5, 1};
static NSRange const kRecordKindRange     = { 6, 1};
static NSRange const kRecordEncodingRange = { 9, 1};
static NSRange const kRecordLocationRange = {12, 5};

static NSRange const kLengthOfLengthOfFieldRange = {20, 1};
static NSRange const kLengthOfFieldLocationRange = {21, 1};

static NSUInteger const kRecordBufferSizeMax = 99999;

@implementation BibLeader {
@protected
    NSData *_rawData;
}

@synthesize rawData = _rawData;

- (instancetype)initWithData:(NSData *)data {
    NSAssert([data length] == BibLeaderRawDataLength,
             @"Leader must contain exactly %lu bytes of data.", BibLeaderRawDataLength);
    if (self = [super init]) {
        _rawData = [data copy];
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string {
    NSData *const data = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSRange const range = NSMakeRange(0, [data length] - 1);
    NSData *const rawData = [data subdataWithRange:range];
    return ([rawData length] != BibLeaderRawDataLength) ? [self initWithData:rawData] : nil;

}

static void sWriteRepeatValueToBuffer(uint8_t *const buffer, NSRange const range, uint8_t const value) {
    size_t const endIndex = (size_t)NSMaxRange(range);
    for (size_t index = (size_t)range.location; index < endIndex; index += 1) {
        buffer[index] = value;
    }
}

- (instancetype)init {
    uint8_t *const buffer = calloc(BibLeaderRawDataLength, sizeof(uint8_t));
    sWriteRepeatValueToBuffer(buffer, NSMakeRange(0, BibLeaderRawDataLength), ' ');
    sWriteRepeatValueToBuffer(buffer, kRecordLengthRange, '0');
    sWriteRepeatValueToBuffer(buffer, kRecordLocationRange, '0');
    buffer[10] = '2'; // number of indicators
    buffer[11] = '1'; // length of subfield code
    memcpy(buffer + 20 * sizeof(uint8_t), "4500", 4); // entry map
    return [self initWithData:[NSData dataWithBytesNoCopy:buffer length:BibLeaderRawDataLength]];
}

- (NSString *)description {
    return [[NSString alloc] initWithData:[self rawData] encoding:NSUTF8StringEncoding];
}

@end

#pragma mark - Copying

@implementation BibLeader (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableLeader allocWithZone:zone] initWithData:[self rawData]];
}

@end

#pragma mark - Equality

@implementation BibLeader (Equality)

- (BOOL)isEqualToLeader:(BibLeader *)leader {
    return [[self rawData] isEqualToData:[leader rawData]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibLeader class]] && [self isEqualToLeader:other]);
}

- (NSUInteger)hash {
    return [[self rawData] hash];
}

@end

#pragma mark - Mutable

@implementation BibMutableLeader

- (id)copyWithZone:(NSZone *)zone {
    return [[BibLeader allocWithZone:zone] initWithData:[self rawData]];
}

@dynamic rawData;
- (void)setRawData:(NSData *)rawData {
    if (self->_rawData != rawData) {
        self->_rawData = [rawData copy];
    }
}

@end

#pragma mark - Metadata

@implementation BibLeader (Metadata)

static NSUInteger sReadUnsignedInteger(NSData *const data, NSRange const range) {
    NSUInteger value = 0;
    NSUInteger const endIndex = NSMaxRange(range);
    for (NSUInteger power = 0; power < range.length; power += 1) {
        NSUInteger const index = endIndex - 1 - power;
        int8_t digit;
        [data getBytes:&digit range:NSMakeRange(index, 1)];
        digit -= '0';
        if (digit < 0 || digit > 9) {
            return NSNotFound;
        }
        value += (NSUInteger)digit * (NSUInteger)pow(10, (double)power);
    }
    return value;
}

- (NSRange)recordRange {
    NSData *const data = [self rawData];
    NSUInteger const loc = sReadUnsignedInteger(data, kRecordLocationRange);
    NSUInteger const len = sReadUnsignedInteger(data, kRecordLengthRange);
    return NSMakeRange(loc, len - loc - 1);
}

- (BibRecordStatus)recordStatus {
    BibRecordStatus buffer[kRecordStatusRange.length];
    [[self rawData] getBytes:buffer range:kRecordStatusRange];
    return buffer[0];
}

- (BibRecordKind)recordKind {
    BibRecordKind buffer[kRecordKindRange.length];
    [[self rawData] getBytes:buffer range:kRecordKindRange];
    return buffer[0];
}

- (BibEncoding)recordEncoding {
    BibEncoding buffer[kRecordEncodingRange.length];
    [[self rawData] getBytes:buffer range:kRecordEncodingRange];
    return buffer[0];
}

- (char)implementationDefinedValueAtIndex:(BibImplementationDefinedValueIndex)index {
    uint8_t byte;
    [[self rawData] getBytes:&byte range:NSMakeRange(index, 1)];
    return byte;
}

@end

@implementation BibLeader (EntryMap)

- (NSUInteger)lengthOfLengthOfField {
    return sReadUnsignedInteger([self rawData], kLengthOfLengthOfFieldRange);
}

- (NSUInteger)lengthOfFieldLocation {
    return sReadUnsignedInteger([self rawData], kLengthOfFieldLocationRange);
}

@end

#pragma mark - Mutable Metadata

@implementation BibMutableLeader (Metadata)

static void sWriteUnsignedInteger(NSMutableData *const data, NSRange const range, NSUInteger value) {
    NSUInteger const endIndex = NSMaxRange(range);
    for (NSUInteger index = range.location; index < endIndex; index += 1, value /= 10) {
        uint8_t const digit = (uint8_t)(value % 10) + '0';
        [data replaceBytesInRange:NSMakeRange(index, 1) withBytes:&digit];
    }
}

- (void)setRecordRange:(NSRange)recordRange {
    NSAssert(recordRange.location != NSNotFound, @"Range not found.");
    NSAssert(recordRange.location <= kRecordBufferSizeMax && recordRange.length <= kRecordBufferSizeMax,
             @"Records cannot be encoded into data larger than %lu.", kRecordBufferSizeMax);
    NSString *const key = NSStringFromSelector(@selector(recordRange));
    [self willChangeValueForKey:key];
    NSMutableData *const data = [[self rawData] mutableCopy];
    sWriteUnsignedInteger(data, kRecordLocationRange, recordRange.location);
    sWriteUnsignedInteger(data, kRecordLengthRange, NSMaxRange(recordRange) + 1);
    [self setRawData:data];
    [self didChangeValueForKey:key];
}

- (void)setRecordStatus:(BibRecordStatus)recordStatus {
    NSString *const key = NSStringFromSelector(@selector(recordStatus));
    [self willChangeValueForKey:key];
    NSMutableData *const data = [[self rawData] mutableCopy];
    [data replaceBytesInRange:kRecordStatusRange withBytes:&recordStatus];
    [self setRawData:data];
    [self didChangeValueForKey:key];
}

- (void)setRecordKind:(BibRecordKind)recordKind {
    NSString *const key = NSStringFromSelector(@selector(recordKind));
    [self willChangeValueForKey:key];
    NSMutableData *const data = [[self rawData] mutableCopy];
    [data replaceBytesInRange:kRecordKindRange withBytes:&recordKind];
    [self setRawData:data];
    [self didChangeValueForKey:key];
}

- (void)setRecordEncoding:(BibEncoding)recordEncoding {
    NSString *const key = NSStringFromSelector(@selector(recordEncoding));
    [self willChangeValueForKey:key];
    NSMutableData *const data = [[self rawData] mutableCopy];
    [data replaceBytesInRange:kRecordEncodingRange withBytes:&recordEncoding];
    [self setRawData:data];
    [self didChangeValueForKey:key];
}

- (void)setImplementationDefinedValue:(char)value atIndex:(BibImplementationDefinedValueIndex)index {
    NSString *const key = NSStringFromSelector(@selector(recordEncoding));
    [self willChangeValueForKey:key];
    NSMutableData *const data = [[self rawData] mutableCopy];
    [data replaceBytesInRange:NSMakeRange(index, 1) withBytes:&value];
    [self setRawData:data];
    [self didChangeValueForKey:key];
}

@end
