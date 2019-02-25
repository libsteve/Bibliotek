//
//  BibRecordSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordSubfield.h"

static NSRange const kCodeRange = {1, 1};

@implementation BibRecordSubfield

- (instancetype)init {
    return [self initWithCode:@"a" content:@""];
}

- (instancetype)initWithData:(NSData *)data {
    NSString *const code = [[NSString alloc] initWithData:[data subdataWithRange:kCodeRange]
                                                 encoding:NSASCIIStringEncoding];
    NSUInteger const contentLocation = NSMaxRange(kCodeRange);
    NSRange const contentRange = NSMakeRange(contentLocation, [data length] - contentLocation);
    NSString *const content = [[NSString alloc] initWithData:[data subdataWithRange:contentRange]
                                                    encoding:NSUTF8StringEncoding];
    return [self initWithCode:code content:content];
}

- (instancetype)initWithCode:(BibRecordSubfieldCode)code content:(NSString *)content {
    if (self = [super init]) {
        _code = [code copy];
        _content = [content copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"$%@%@", _code, _content];
}

#pragma mark - Equality

- (BOOL)isEqualToSubfield:(BibRecordSubfield *)subfield {
    return [_code isEqualToString:[subfield code]] && [_content isEqualToString:[subfield content]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordSubfield class]] && [self isEqualToSubfield:other]);
}

- (NSUInteger)hash {
    return [_code hash] ^ [_content hash];
}

@end
