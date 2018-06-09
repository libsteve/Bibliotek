//
//  BibClassification.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassification.h"
#import "BibClassification.Private.h"

@implementation BibClassification

- (instancetype)initWithClassification:(NSString *)classification item:(NSString *)item system:(BibClassificationSystem)system {
    if (self = [super init]) {
        _classification = [classification copy];
        _item = [item copy];
        _system = system;
    }
    return self;
}

- (instancetype)initFromField:(NSDictionary *)field {
    NSDictionary<NSString *, NSDictionary *> *subfields = nil;
    NSString *system = nil;
    NSString *classification = nil;
    NSString *item = nil;
    if ((subfields = (NSDictionary *)field[@"050"])) {
        system = BibClassificationSystemLCC;
    } else if ((subfields = (NSDictionary *)field[@"082"])) {
        system = BibClassificationSystemDDC;
    } else {
        return nil;
    }
    _official = [subfields[@"ind1"] isEqual:@"0"];
    for (NSDictionary *subfield in (NSDictionary *)subfields[@"subfields"]) {
        classification = classification ?: subfield[@"a"];
        item = item ?: subfield[@"b"];
    }
    if (classification == nil) {
        return nil;
    }
    return [self initWithClassification:classification item:item system:system];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibClassification allocWithZone:zone] initWithClassification:_classification item:_item system:_system];
}

- (BOOL)isEqual:(id)object {
    return [[self class] isKindOfClass:[object class]] && [self isEqualToClassification:object];
}

- (NSUInteger)hash {
    return [_classification hash] ^ [_item hash] ^ [_system hash];
}

- (BOOL)isEqualToClassification:(BibClassification *)classification {
    return ((_item == nil && classification->_item == nil) || [classification->_item isEqualToString:_item]) && [self isSimilarToClassification:classification];
}

- (BOOL)isSimilarToClassification:(BibClassification *)classification {
    return [_system isEqualToString:_system] && [_classification isEqualToString:_classification];
}

- (NSString *)description {
    if (_item == nil) {
        return [_classification copy];
    }
    return [NSString stringWithFormat:@"%@ %@", _classification, _item];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: classificiation: '%@' item: '%@' system: %@>", [self className], _classification, _item, _system];
}

@end

BibClassificationSystem const BibClassificationSystemLCC = @".lcc";
BibClassificationSystem const BibClassificationSystemDDC = @".ddc";
