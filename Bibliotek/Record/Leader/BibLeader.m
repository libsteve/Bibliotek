//
//  BibLeader.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibLeader.h"
#import "BibRecordKind.h"

#import "Bibliotek+Internal.h"

NSUInteger const BibLeaderRawDataLength = 24;

static NSRange const kRecordLengthRange   = { 0, 5};
static NSRange const kRecordStatusRange   = { 5, 1};
static NSRange const kRecordKindRange     = { 6, 1};
static NSRange const kRecordEncodingRange = { 9, 1};
static NSRange const kRecordLocationRange = {12, 5};

static NSRange const kNumberOfIndicatorsRange    = {10, 1};
static NSRange const kLengthOfSubfieldCodeRange  = {11, 1};

static NSRange const kLengthOfLengthOfFieldRange = {20, 1};
static NSRange const kLengthOfFieldLocationRange = {21, 1};

static NSUInteger const kRecordBufferSizeMax = 99999;

@implementation BibLeader {
@protected
    NSData *_rawData;
}

@synthesize rawData = _rawData;

static BOOL sVerifyNumericValuesInRange(NSData *data, NSRange range) {
    char bytes[range.length];
    [data getBytes:bytes range:range];
    for (int i = 0; i < range.length; i += 1) {
        if (!isnumber(bytes[i])) {
            return NO;
        }
    }
    return YES;
}

static BOOL sVerifyValueInRange(NSData *data, NSRange range, char const *value) {
    char bytes[range.length];
    [data getBytes:bytes range:range];
    return memcmp(bytes, value, range.length) == 0;
}

static BOOL sVerifyLeaderValuesInData(NSData *data) {
    if ([data length] != BibLeaderRawDataLength) {
        return NO;
    }
    char bytes[BibLeaderRawDataLength];
    [data getBytes:bytes length:BibLeaderRawDataLength];
    for (int i = 0; i < BibLeaderRawDataLength; i += 1) {
        if (bytes[i] < 0x20 || bytes[i] > 0x7E) {
            return NO;
        }
    }
    return sVerifyNumericValuesInRange(data, kRecordLocationRange)
        && sVerifyNumericValuesInRange(data, kRecordLengthRange)
        && sVerifyValueInRange(data, kNumberOfIndicatorsRange, "2")
        && sVerifyValueInRange(data, kLengthOfSubfieldCodeRange, "2")
        && sVerifyValueInRange(data, kLengthOfLengthOfFieldRange, "4500");
}

- (instancetype)initWithData:(NSData *)data {
//    NSAssert([data length] == BibLeaderRawDataLength,
//             @"Leader must contain exactly %lu bytes of data.", BibLeaderRawDataLength);
    if (!sVerifyLeaderValuesInData(data)) {
        return nil;
    }
    if (self = [super init]) {
        _rawData = [data copy];
        if (self.recordKind == 0) {
//            [NSException raise:NSInvalidArgumentException
//                        format:@"*** MARC 21 Leader data contains an invalid record kind."];
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string {
    NSData *const data = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSRange const range = NSMakeRange(0, MIN([data length], BibLeaderRawDataLength));
    NSData *const rawData = (range.length == BibLeaderRawDataLength) ? [data subdataWithRange:range] : nil;
    return (rawData != NULL) ? [self initWithData:rawData] : nil;
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
    buffer[kRecordKindRange.location] = BibRecordKindLanguageMaterial;
    buffer[kRecordStatusRange.location] = BibRecordStatusNew;
    buffer[kRecordEncodingRange.location] = BibUTF8Encoding;
    buffer[kNumberOfIndicatorsRange.location]   = '2';
    buffer[kLengthOfSubfieldCodeRange.location] = '2';
    memcpy(buffer + kLengthOfLengthOfFieldRange.location * sizeof(uint8_t), "4500", 4); // entry map
    return [self initWithData:[NSData dataWithBytesNoCopy:buffer length:BibLeaderRawDataLength]];
}

- (NSString *)description {
    return [[NSString alloc] initWithData:[self rawData] encoding:NSUTF8StringEncoding];
}

- (BibLeaderValue)leaderValueAtLocation:(BibLeaderLocation)location {
    BibLeaderValue byte;
    [[self rawData] getBytes:&byte range:NSMakeRange(location, sizeof(byte))];
    return byte;
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

- (void)setLeaderValue:(BibLeaderValue)value atLocation:(BibLeaderLocation)location {
    if (value < 0x20 || value > 0x7E) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Leader value must be a printable ASCII character."];
    }
    NSMutableData *data = [[self rawData] mutableCopy];
    [data replaceBytesInRange:NSMakeRange(location, sizeof(value)) withBytes:&value];
    [self setRawData:data];
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
    return NSMakeRange(loc, len - loc);
}

- (BibRecordStatus)recordStatus {
    return [self leaderValueAtLocation:BibLeaderLocationRecordStatus];
}

- (BibRecordKind)recordKind {
    return [self leaderValueAtLocation:BibLeaderLocationRecordKind];
}

- (BibEncoding)recordEncoding {
    return [self leaderValueAtLocation:BibLeaderLocationCharacterEncoding];
}

- (BibBibliographicLevel)bibliographicLevel {
    if (BibRecordKindFormat([self recordKind]) == BibRecordFormatBibliographic) {
        return [self leaderValueAtLocation:BibLeaderLocationBibliographicLevel];
    }
    return 0;
}

- (BibBibliographicControlType)bibliographicControlType {
    if (BibRecordKindFormat([self recordKind]) == BibRecordFormatBibliographic) {
        return [self leaderValueAtLocation:BibLeaderLocationBibliographicControlType];
    }
    return 0;
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

@implementation BibLeader (ContentField)

- (NSUInteger)numberOfIndicators {
    return sReadUnsignedInteger([self rawData], kNumberOfIndicatorsRange);
}

- (NSUInteger)lengthOfSubfieldCode {
    return sReadUnsignedInteger([self rawData], kLengthOfSubfieldCodeRange);
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
    NSMutableData *const data = [[self rawData] mutableCopy];
    sWriteUnsignedInteger(data, kRecordLocationRange, recordRange.location);
    sWriteUnsignedInteger(data, kRecordLengthRange, NSMaxRange(recordRange) + 1);
    [self setRawData:data];
}

- (void)setRecordStatus:(BibRecordStatus)recordStatus {
    [self setLeaderValue:recordStatus atLocation:BibLeaderLocationRecordStatus];
}

- (void)setRecordKind:(BibRecordKind)recordKind {
    [self setLeaderValue:recordKind atLocation:BibLeaderLocationRecordKind];
}

- (void)setRecordEncoding:(BibEncoding)recordEncoding {
    [self setLeaderValue:recordEncoding atLocation:BibLeaderLocationCharacterEncoding];
}

- (void)setBibliographicLevel:(BibBibliographicLevel)bibliographicLevel {
    if (BibRecordKindFormat([self recordKind]) == BibRecordFormatBibliographic) {
        bibliographicLevel = bibliographicLevel ?: ' ';
        [self setLeaderValue:bibliographicLevel atLocation:BibLeaderLocationBibliographicLevel];
    }
}

- (void)setBibliographicControlType:(BibBibliographicControlType)bibliographicControlType {
    if (BibRecordKindFormat([self recordKind]) == BibRecordFormatBibliographic) {
        NSMutableData *const data = [[self rawData] mutableCopy];
        bibliographicControlType = (bibliographicControlType ?: BibBibliographicControlTypeNone);
        [self setLeaderValue:bibliographicControlType atLocation:BibLeaderLocationBibliographicControlType];
    }
}

@end
