//
//  BibRecordField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordField.h"
#import "BibRecordSubfield.h"

static uint8_t const kSubfieldDelimiter = 0x1F;
static uint8_t const kFieldTerminator = 0x1E;

@implementation BibRecordControlField

- (BibRecordFieldTag)tag {
    [NSException raise:NSInternalInconsistencyException
                format:@"A subclass must override the abstract method %@", NSStringFromSelector(_cmd)];
    return nil;
}

- (instancetype)initWithData:(NSData *)data {
    NSRange const contentRange = NSMakeRange(0, [data length] - 1);
    NSString *const content = [[NSString alloc] initWithData:[data subdataWithRange:contentRange]
                                                    encoding:NSASCIIStringEncoding];
    return [self initWithContent:content];
}

- (instancetype)initWithContent:(NSString *)content {
    if ([[self class] isEqual:[BibRecordControlField class]]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"A subclass must override the abstract method %@", NSStringFromSelector(_cmd)];
        return nil;
    }
    return [super init];
}

- (BOOL)isEqualToControlField:(BibRecordControlField *)controlField {
    return [super isEqual:controlField];
}

- (BOOL)isEqual:(id)object {
    return (self == object)
        || ([object isKindOfClass:[BibRecordControlField class]] && [self isEqualToControlField:object]);
}

@end

@implementation BibRecordDataField

- (BibRecordFieldTag)tag {
    [NSException raise:NSInternalInconsistencyException
                format:@"A subclass must override the abstract method %@", NSStringFromSelector(_cmd)];
    return nil;
}

- (instancetype)initWithData:(NSData *)data {
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
            currentRange.location = NSMaxRange(subfieldRange);
            currentRange.length = 1;
        }
    }
    return [self initWithIndicators:indicators subfields:subfields];
}

- (instancetype)initWithIndicators:(NSArray<BibRecordFieldIndicator> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if ([[self class] isEqual:[BibRecordDataField class]]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"A subclass must override the abstract method %@", NSStringFromSelector(_cmd)];
        return nil;
    }
    return [super init];
}

- (BOOL)isEqualToDataField:(BibRecordDataField *)dataField {
    return [super isEqual:dataField];
}

- (BOOL)isEqual:(id)object {
    return (self == object)
        || ([object isKindOfClass:[BibRecordDataField class]] && [self isEqualToDataField:object]);
}

@end
