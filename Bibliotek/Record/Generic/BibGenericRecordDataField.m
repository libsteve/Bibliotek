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

- (BibRecordFieldTag)tag { return _tag; }

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
    if (self = [super initWithIndicators:indicators subfields:subfields]) {
        _tag = [tag copy];
    }
    return self;
}

@end
