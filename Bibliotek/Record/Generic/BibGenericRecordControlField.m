//
//  BibGenericRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibGenericRecordControlField.h"

@implementation BibGenericRecordControlField {
    BibRecordFieldTag _tag;
}

- (BibRecordFieldTag)tag { return _tag; }

- (instancetype)initWithData:(NSData *)data {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithContent:(NSString *)content {
    if (_tag == nil) {
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    }
    return [self initWithTag:_tag content:content];
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag data:(NSData *)data {
    _tag = tag;
    return [super initWithData:data];
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag content:(NSString *)content {
    if (self = [super initWithContent:content]) {
        _tag = [tag copy];
    }
    return self;
}

@end
