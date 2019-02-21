//
//  BibRecordDataField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordDataField.h"
#import "BibRecordSubfield.h"

static uint8_t const kSubfieldDelimiter = 0x1F;
static uint8_t const kFieldTerminator = 0x1E;

@implementation BibRecordDataField

- (instancetype)init {
    return [self initWithTag:@"000" indicators:@[] subfields:@[]];
}

- (instancetype)initWithTag:(NSString *)tag data:(NSData *)data {
    NSMutableArray *const indicators = [NSMutableArray array];
    for (NSUInteger index = 0; index < 2; index += 1) {
        NSString *const indicator =  [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(index, 1)]
                                                           encoding:NSASCIIStringEncoding];
        [indicators addObject:indicator];
    }
    NSMutableArray *const subfields = [NSMutableArray array];
    NSUInteger const dataLength = [data length];
    uint8_t const *const bytes = [data bytes];
    for (NSRange currentRange = NSMakeRange(2, 1); NSMaxRange(currentRange) < dataLength; currentRange.length += 1) {
        uint8_t const currentByte = bytes[NSMaxRange(currentRange)];
        if (currentByte == kSubfieldDelimiter || currentByte == kFieldTerminator) {
            NSRange const subfieldRange = NSMakeRange(currentRange.location, currentRange.length);
            NSData *const subfieldData = [data subdataWithRange:subfieldRange];
            BibRecordSubfield *const subfield = [[BibRecordSubfield alloc] initWithData:subfieldData];
            [subfields addObject:subfield];
            currentRange.location = NSMaxRange(subfieldRange) - 1;
            currentRange.length = 1;
        }
    }
    return [self initWithTag:tag indicators:indicators subfields:subfields];
}

- (instancetype)initWithTag:(NSString *)tag
                 indicators:(NSArray<NSString *> *)indicators
                  subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (self = [super init]) {
        _tag = [tag copy];
        _indicators = [indicators copy];
        _subfields = [subfields copy];
    }
    return self;
}

- (NSString *)description {
    NSMutableArray *indicators = [NSMutableArray arrayWithCapacity:[_indicators count]];
    for (NSString *indicator in _indicators) {
        [indicators addObject:([indicator isEqualToString:@" "] ? @"#" : indicator)];
    }
    NSString *const subfields = [_subfields componentsJoinedByString:@""];
    return [NSString stringWithFormat:@"%@ %@ %@", _tag, [indicators componentsJoinedByString:@""], subfields];
}

#pragma mark - Equality

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField {
    return [_tag isEqualToString:[dataField tag]]
        && [_indicators isEqualToArray:[dataField indicators]]
        && [_subfields isEqualToArray:[dataField subfields]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordDataField class]] && [self isEqualToDataField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_indicators hash] ^ [_subfields hash];
}

@end
