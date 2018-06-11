//
//  BibTitleStatement.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/11/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConstants.h"
#import "BibRecordField.h"
#import "BibTitleStatement.h"

@implementation BibTitleStatement {
    BibRecordField *_field;
}

- (instancetype)initWithField:(BibRecordField *)field {
    if ([field.fieldTag isEqualToString:BibRecordFieldTagTitle] && (self = [super init])) {
        _field = field;
    }
    return self;
}

+ (instancetype)statementWithField:(BibRecordField *)field {
    return [[self alloc] initWithField:field];
}

- (NSString *)title {
    NSMutableString *raw = [_field['a'] mutableCopy];
    if ([raw hasSuffix:@" :"] || [raw hasSuffix:@" /"]) {
        [raw replaceCharactersInRange:NSMakeRange(raw.length - 2, 2) withString:@""];
    } else if ([raw hasSuffix:@"."]) {
        [raw replaceCharactersInRange:NSMakeRange(raw.length - 1, 1) withString:@""];
    }
    return [raw copy] ?: @"";
}

- (NSArray<NSString *> *)subtitles {
    NSMutableString *raw = [_field['b'] mutableCopy];
    if ([raw hasSuffix:@" /"]) {
        [raw replaceCharactersInRange:NSMakeRange(raw.length - 2, 2) withString:@""];
    } else if ([raw hasSuffix:@"."]) {
        [raw replaceCharactersInRange:NSMakeRange(raw.length - 1, 1) withString:@""];
    }
    return [raw componentsSeparatedByString:@" : "];
}

- (NSArray<NSString *> *)responsibilities {
    NSMutableString *raw = [_field['c'] mutableCopy];
    if ([raw hasSuffix:@"."]) {
        [raw replaceCharactersInRange:NSMakeRange(raw.length - 1, 1) withString:@""];
    }
    return [raw componentsSeparatedByString:@" ; "];
}

@end
