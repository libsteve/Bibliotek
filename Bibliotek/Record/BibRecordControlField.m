//
//  BibRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordControlField.h"

@implementation BibRecordControlField

- (instancetype)init {
    return [self initWithTag:@"000" content:@""];
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag data:(NSData *)data {
    NSRange const contentRange = NSMakeRange(0, [data length] - 1);
    NSString *const content = [[NSString alloc] initWithData:[data subdataWithRange:contentRange]
                                                   encoding:NSASCIIStringEncoding];
    return [self initWithTag:tag content:content];
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag content:(NSString *)content {
    if (self = [super init]) {
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
    return [_tag isEqualToString:[controlField tag]] && [_content isEqualToString:[controlField content]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordControlField class]] && [self isEqualToControlField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_content hash];
}

@end
