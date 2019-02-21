//
//  BibRecordSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordSubfield.h"

static NSRange const kIdentifierRange = {1, 1};

@implementation BibRecordSubfield

- (instancetype)init {
    return [self initWithIdentifier:@"a" content:@""];
}

- (instancetype)initWithData:(NSData *)data {
    NSString *const identifier = [[NSString alloc] initWithData:[data subdataWithRange:kIdentifierRange]
                                                       encoding:NSASCIIStringEncoding];
    NSUInteger const contentLocation = NSMaxRange(kIdentifierRange);
    NSRange const contentRange = NSMakeRange(contentLocation, [data length] - contentLocation);
    NSString *const content = [[NSString alloc] initWithData:[data subdataWithRange:contentRange]
                                                    encoding:NSUTF8StringEncoding];
    return [self initWithIdentifier:identifier content:content];
}

- (instancetype)initWithIdentifier:(NSString *)identifier content:(NSString *)content {
    if (self = [super init]) {
        _identifier = [identifier copy];
        _content = [content copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"$%@%@", _identifier, _content];
}

#pragma mark - Equality

- (BOOL)isEqualToSubfield:(BibRecordSubfield *)subfield {
    return [_identifier isEqualToString:[subfield identifier]] && [_content isEqualToString:[subfield content]];
}

- (BOOL)isEqual:(id)other {
    return self == other
        || ([other isKindOfClass:[BibRecordSubfield class]] && [self isEqualToSubfield:other]);
}

- (NSUInteger)hash {
    return [_identifier hash] ^ [_content hash];
}

@end
