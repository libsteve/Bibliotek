//
//  BibTitleStatement.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/11/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConstants.h"
#import "BibMarcRecordField.h"
#import "BibTitleStatement.h"

@implementation BibTitleStatement {
    BibMarcRecordField *_field;
}

- (instancetype)initWithField:(BibMarcRecordField *)field {
    if ([field.fieldTag isEqualToString:BibRecordFieldTagTitle] && (self = [super init])) {
        _field = field;
    } else {
        return nil;
    }
    return self;
}

+ (instancetype)statementWithField:(BibMarcRecordField *)field {
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

- (NSArray<NSString *> *)people {
    NSMutableString *raw = [_field['c'] mutableCopy];
    if ([raw hasSuffix:@"."]) {
        [raw replaceCharactersInRange:NSMakeRange(raw.length - 1, 1) withString:@""];
    }
    return [raw componentsSeparatedByString:@" ; "];
}

- (NSString *)description {
    NSMutableString *const subtitles = [NSMutableString new];
    for (NSString *subtitle in [self subtitles]) {
        if (![subtitles isEqualToString:@""]) { [subtitles appendString:@" "]; }
        [subtitles appendString:[NSString stringWithFormat:@"(%@)", subtitle]];
    }
    NSMutableString *const people = [NSMutableString new];
    for (NSString *person in [self people]) {
        if (![people isEqualToString:@""]) { [people appendString:@" "]; }
        [people appendString:[NSString stringWithFormat:@"(%@)", person]];
    }
    return [NSString stringWithFormat:@"Title: (%@); Subtitles: %@; People: %@", [self title], subtitles, people];
}

- (NSString *)debugDescription {
    NSMutableString *const description = [NSMutableString stringWithFormat:@"%@    $a%@", BibRecordFieldTagTitle, [self title]];
    NSMutableString *const subtitles = [NSMutableString new];
    for (NSString *subtitle in [self subtitles]) {
        if (![subtitles isEqualToString:@""]) { [subtitles appendString:@" : "]; }
        [subtitles appendString:[NSString stringWithFormat:@"\"%@\"", subtitle]];
    }
    if (![subtitles isEqualToString:@""]) {
        [description appendString:[NSString stringWithFormat:@" :$b%@", subtitles]];
    }
    NSMutableString *const people = [NSMutableString new];
    for (NSString *person in [self people]) {
        if (![people isEqualToString:@""]) { [people appendString:@" ; "]; }
        [subtitles appendString:[NSString stringWithFormat:@"\"%@\"", person]];
    }
    if (![people isEqualToString:@""]) {
        [description appendString:[NSString stringWithFormat:@" /$c%@", people]];
    }
    return [NSMutableString stringWithFormat:@"%@    $a%@%@%@.", BibRecordFieldTagTitle, [self title], subtitles, people];
}

@end
