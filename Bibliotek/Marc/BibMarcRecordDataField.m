//
//  BibMarcRecordDataField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordDataField.h"
#import "BibMarcRecordSubfield.h"

@implementation BibMarcRecordDataField {
@protected
    NSString *_tag;
    NSString *_firstIndicator;
    NSString *_secondIndicator;
    NSArray<BibMarcRecordSubfield *> *_subfields;
}

@synthesize tag = _tag;
@synthesize firstIndicator = _firstIndicator;
@synthesize secondIndicator = _secondIndicator;
@synthesize subfields = _subfields;

- (instancetype)init {
    return [self initWithTag:@"000" firstIndicator:nil secondIndicator:nil subfields:[NSArray array]];
}

- (instancetype)initWithTag:(NSString *)tag firstIndicator:(NSString *)firstIndicator secondIndicator:(NSString *)secondIndicator subfields:(NSArray<BibMarcRecordSubfield *> *)subfields {
    if (self = [super init]) {
        _tag = [tag copy];
        _firstIndicator = [firstIndicator isEqualToString:@" "] ? nil : [firstIndicator copy];
        _secondIndicator = [secondIndicator isEqualToString:@" "] ? nil : [secondIndicator copy];
        _subfields = [[NSArray alloc] initWithArray:subfields copyItems:YES];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTag:[aDecoder decodeObjectForKey:@"tag"]
              firstIndicator:[aDecoder decodeObjectForKey:@"ind1"]
             secondIndicator:[aDecoder decodeObjectForKey:@"ind2"]
                   subfields:[aDecoder decodeObjectForKey:@"subfields"]];
}

- (id)copyWithZone:(NSZone *)zone {
    if (zone == nil && [[self class] isEqualTo:[BibMarcRecordSubfield class]]) {
        return self;
    }
    return [[BibMarcRecordDataField allocWithZone:zone] initWithTag:_tag
                                                     firstIndicator:_firstIndicator
                                                    secondIndicator:_secondIndicator
                                                          subfields:_subfields];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableDataField allocWithZone:zone] initWithTag:_tag
                                                            firstIndicator:_firstIndicator
                                                           secondIndicator:_secondIndicator
                                                                 subfields:_subfields];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:@"tag"];
    [aCoder encodeObject:(_firstIndicator ?: @" ") forKey:@"ind1"];
    [aCoder encodeObject:(_secondIndicator ?: @" ") forKey:@"ind2"];
    [aCoder encodeObject:_subfields forKey:@"subfields"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToDataField:(BibMarcRecordDataField *)other {
    return [_tag isEqualToString:[other tag]]
        && (_firstIndicator == [other firstIndicator] || [_firstIndicator isEqualToString:[other firstIndicator]])
        && (_secondIndicator == [other secondIndicator] || [_secondIndicator isEqualToString:[other secondIndicator]])
        && [_subfields isEqualToArray:[other subfields]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordDataField class]] && [self isEqualToDataField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_firstIndicator hash] ^ [_secondIndicator hash] ^ [_subfields hash];
}

@end

@implementation BibMarcRecordMutableDataField

@dynamic tag;
- (void)setTag:(NSString *)tag {
    if (_tag == tag) {
        return;
    }
    [self willChangeValueForKey:@"tag"];
    _tag = [tag copy];
    [self didChangeValueForKey:@"tag"];
}

@dynamic firstIndicator;
- (void)setFirstIndicator:(NSString *)firstIndicator {
    if (_firstIndicator == firstIndicator) {
        return;
    }
    [self willChangeValueForKey:@"firstIndicator"];
    _firstIndicator = [firstIndicator isEqualToString:@" "] ? nil : [firstIndicator copy];
    [self didChangeValueForKey:@"firstIndicator"];
}

@dynamic secondIndicator;
- (void)setSecondIndicator:(NSString *)secondIndicator {
    if (_secondIndicator == secondIndicator) {
        return;
    }
    [self willChangeValueForKey:@"secondIndicator"];
    _secondIndicator = [secondIndicator isEqualToString:@" "] ? nil : [secondIndicator copy];
    [self didChangeValueForKey:@"secondIndicator"];
}

@dynamic subfields;
- (void)setSubfields:(NSArray<BibMarcRecordSubfield *> *)subfields {
    if (_subfields == subfields) {
        return;
    }
    [self willChangeValueForKey:@"subfields"];
    _subfields = [[NSArray alloc] initWithArray:subfields copyItems:YES];
    [self didChangeValueForKey:@"subfields"];
}

@end
