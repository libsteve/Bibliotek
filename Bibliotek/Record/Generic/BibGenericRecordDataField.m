//
//  BibGenericRecordDataField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibGenericRecordDataField.h"
#import "BibRecordSubfield.h"

@implementation BibGenericRecordDataField {
    BibRecordFieldTag _tag;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithData:(NSData *)data {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithIndicators:(NSArray<NSString *> *)indicators
                         subfields:(NSArray<BibRecordSubfield *> *)subfields {
    if (_tag == nil) {
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    }
    return [self initWithTag:_tag indicators:indicators subfields:subfields];
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag data:(NSData *)data {
    _tag = tag;
    return [super initWithData:data];
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag
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
    BibGenericRecordDataField *other = (id)dataField;
    return [other isKindOfClass:[BibGenericRecordDataField class]]
        && [_tag isEqualToString:[other tag]]
        && [_indicators isEqualToArray:[other indicators]]
        && [_subfields isEqualToArray:[other subfields]];
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_indicators hash] ^ [_subfields hash];
}

@end
