//
//  BibRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordControlField.h"

@implementation BibRecordControlField

- (BibRecordFieldTag)tag {
    [NSException raise:NSInternalInconsistencyException
                format:@"A subclass must override the abstract method %@", NSStringFromSelector(_cmd)];
    return nil;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
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
    if (self = [super init]) {
        _content = [content copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", [self tag], _content];
}

- (BOOL)isEqualToControlField:(BibRecordControlField *)controlField {
    return [[self tag] isEqualToString:[controlField tag]] && [_content isEqualToString:[controlField content]];
}

- (NSUInteger)hash {
    return [[self tag] hash] ^ [_content hash];
}
@end
