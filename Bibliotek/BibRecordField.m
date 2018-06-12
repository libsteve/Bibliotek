//
//  BibRecordField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibRecordField.h"

@implementation BibRecordField {
    NSDictionary<NSString *, NSString *> *_subfields;
}

- (instancetype)initWithFieldTag:(BibRecordFieldTag)fieldTag firstIndicator:(BibRecordFieldIndicator)firstIndicator secondIndicator:(BibRecordFieldIndicator)secondIndicator subfields:(NSDictionary<NSString *, NSString *> *)subfields {
    if (self = [super init]) {
        _fieldTag = fieldTag;
        _firstIndicator = firstIndicator;
        _secondIndicator = secondIndicator;
        _subfields = [subfields copy];
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary<NSString *,id> *)json {
    BibRecordFieldTag const tag = [[json allKeys] firstObject];
    if (tag == nil) { return nil; }
    NSDictionary *const content = json[tag];
    if (content == nil || ![content isKindOfClass:[NSDictionary class]]) { return nil; }
    NSString *const first = content[@"ind1"];
    if (first == nil || first.length != 1) { return nil; }
    NSString *const second = content[@"ind2"];
    if (second == nil || second.length != 1) { return nil; }
    NSMutableDictionary *const dictionary = [NSMutableDictionary new];
    id const subfields = content[@"subfields"];
    if ([subfields isKindOfClass:[NSArray class]]) {
        for (NSDictionary *subfield in [(NSArray *)subfields reverseObjectEnumerator]) {
            [dictionary addEntriesFromDictionary:subfield];
        }
    } else if ([subfields isKindOfClass:[NSDictionary class]]) {
        [dictionary addEntriesFromDictionary:subfields];
    }
    return [self initWithFieldTag:tag firstIndicator:[first characterAtIndex:0] secondIndicator:[second characterAtIndex:0] subfields:[dictionary copy]];
}

- (NSString *)objectAtIndexedSubscript:(BibRecordFieldCode)subfieldCode {
    return _subfields[[NSString stringWithFormat:@"%c", subfieldCode]];
}

- (NSString *)description {
    NSMutableString *entry = [NSMutableString string];
    for (NSString *key in [[_subfields allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        if (![entry isEqualToString:@""]) { [entry appendString:@", "]; }
        NSString *const value = _subfields[key];
        char const code = [key characterAtIndex:0];
        [entry appendFormat:@"%@ : “%@”", BibRecordFieldCodeDescription(code), value];
    }
    return [NSString stringWithFormat:@"[%@: %c%c [%@]]", BibRecordFieldTagDescription(_fieldTag), _firstIndicator, _secondIndicator, entry];
}

- (NSString *)debugDescription {
    NSMutableString *entry = [NSMutableString string];
    for (NSString *key in [[_subfields allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSString *const value = _subfields[key];
        char const code = [key characterAtIndex:0];
        [entry appendFormat:@"%@%@", BibRecordFieldCodeDescription(code), value];
    }
    return [NSString stringWithFormat:@"%@ %c%c %@", _fieldTag, _firstIndicator, _secondIndicator, entry];
}

@end
