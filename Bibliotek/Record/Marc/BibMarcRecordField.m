//
//  BibMarcRecordField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordField.h"

@interface BibMarcRecordField ()
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end

@implementation BibMarcRecordField {
    NSDictionary<NSString *, NSString *> *_subfields;
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithFieldTag:(_BibMarcRecordFieldTag)fieldTag firstIndicator:(BibMarcRecordFieldIndicator)firstIndicator secondIndicator:(BibMarcRecordFieldIndicator)secondIndicator subfields:(NSDictionary<NSString *, NSString *> *)subfields {
    if (self = [super init]) {
        _fieldTag = fieldTag;
        _firstIndicator = firstIndicator;
        _secondIndicator = secondIndicator;
        _subfields = [subfields copy];
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary<NSString *,id> *)json {
    _BibMarcRecordFieldTag const tag = [[json allKeys] firstObject];
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _fieldTag = [aDecoder decodeObjectForKey:@"fieldTag"];
        _firstIndicator = [[aDecoder decodeObjectForKey:@"firstIndicator"] characterAtIndex:0];
        _secondIndicator = [[aDecoder decodeObjectForKey:@"secondIndicator"] characterAtIndex:0];
        _subfields = [aDecoder decodeObjectForKey:@"subfields"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSString *const first = [NSString stringWithFormat:@"%c", _firstIndicator];
    NSString *const second = [NSString stringWithFormat:@"%c", _secondIndicator];
    [aCoder encodeObject:_fieldTag forKey:@"fieldTag"];
    [aCoder encodeObject:first forKey:@"firstIndicator"];
    [aCoder encodeObject:second forKey:@"secondIndicator"];
    [aCoder encodeObject:_subfields forKey:@"subfields"];
}

- (NSString *)objectAtIndexedSubscript:(BibMarcRecordFieldCode)subfieldCode {
    return _subfields[[NSString stringWithFormat:@"%c", subfieldCode]];
}

- (NSString *)description {
    NSMutableString *entry = [NSMutableString string];
    for (NSString *key in [[_subfields allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        if (![entry isEqualToString:@""]) { [entry appendString:@" "]; }
        NSString *const value = _subfields[key];
        char const code = [key characterAtIndex:0];
        [entry appendFormat:@"(%c: %@)", code, value];
    }
    char const first = (_firstIndicator == ' ') ? '#' : _firstIndicator;
    char const second = (_secondIndicator == ' ') ? '#' : _secondIndicator;
    return [NSString stringWithFormat:@"%@: %c%c %@", BibMarcRecordFieldTagDescription(_fieldTag), first, second, entry];
}

- (NSString *)debugDescription {
    NSMutableString *entry = [NSMutableString string];
    for (NSString *key in [[_subfields allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSString *const value = _subfields[key];
        char const code = [key characterAtIndex:0];
        [entry appendFormat:@"%@%@", BibMarcRecordFieldCodeDescription(code), value];
    }
    return [NSString stringWithFormat:@"%@ %c%c %@", _fieldTag, _firstIndicator, _secondIndicator, entry];
}

@end
