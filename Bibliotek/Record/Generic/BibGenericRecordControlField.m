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

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
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
        _content = [content copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", _tag, _content];
}

#pragma mark - Equality

- (BOOL)isEqualToControlField:(BibRecordControlField *)controlField {
    return [controlField isKindOfClass:[BibGenericRecordControlField class]]
        && [_tag isEqualToString:[controlField tag]] && [_content isEqualToString:[(id)controlField content]];
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_content hash];
}

@end
