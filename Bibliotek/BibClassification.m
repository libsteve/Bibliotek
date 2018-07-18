//
//  BibClassification.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassification.h"
#import "BibRecordField.h"

@interface BibClassification ()
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end

@implementation BibClassification {
@protected
    BibClassificationSystem _system;
    NSString *_classification;
    NSString *_item;
    BOOL _official;
}

+ (BOOL)supportsSecureCoding { return YES; }

@synthesize system = _system;
@synthesize classification = _classification;
@synthesize item = _item;
@synthesize official = _official;

- (instancetype)initWithClassification:(NSString *)classification item:(NSString *)item system:(BibClassificationSystem)system {
    if (self = [super init]) {
        _classification = [classification copy];
        _item = [item copy];
        _system = system;
    }
    return self;
}

- (instancetype)initWithField:(BibRecordField *)field {
    BibClassificationSystem system = nil;
    NSString *classification = nil;
    NSString *item = nil;
    if ([field.fieldTag isEqualToString:BibRecordFieldTagLCC]) {
        system = BibClassificationSystemLCC;
        classification = field['a'];
        item = field['b'];
    } else if ([field.fieldTag isEqualToString:BibRecordFieldTagDDC]) {
        system = BibClassificationSystemDDC;
        classification = field['a'];
        item = field['2'];
    } else {
        return nil;
    }
    if (self = [self initWithClassification:classification item:item system:system]) {
        _official = (field.secondIndicator == '0');
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _classification = [aDecoder decodeObjectForKey:@"classification"];
        _item = [aDecoder decodeObjectForKey: @"item"];
        _system = [aDecoder decodeObjectForKey:@"system"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_classification forKey:@"classification"];
    [aCoder encodeObject:_item forKey:@"item"];
    [aCoder encodeObject:_system forKey:@"system"];
}

+ (instancetype)classificationWithField:(BibRecordField *)field {
    return [[BibClassification alloc] initWithField:field];
}

- (id)copyWithZone:(NSZone *)zone {
    BibClassification *copy = [[BibClassification allocWithZone:zone] initWithClassification:_classification item:_item system:_system];
    if (copy != nil) { copy->_official = _official; }
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    BibMutableClassification *copy = [[BibMutableClassification allocWithZone:zone] initWithClassification:_classification item:_item system:_system];
    copy.official = _official;
    return copy;
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
        return [NSString stringWithFormat:@"%@: %@", BibClassificationSystemDescription(_system), _classification];
    }
    return [NSString stringWithFormat:@"%@: %@ %@", BibClassificationSystemDescription(_system), _classification, _item];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@: '%@' '%@'", _system, _classification, _item];
}

@end

#pragma mark - Mutable Classification

@implementation BibMutableClassification
@dynamic classification;
@dynamic item;
@dynamic system;
@dynamic official;

- (void)setClassification:(NSString *)classification {
    _classification = [classification copy];
}

- (void)setItem:(NSString *)item {
    _item = [item copy];
}

- (void)setSystem:(BibClassificationSystem)system {
    _system = system;
}

- (void)setOfficial:(BOOL)official {
    _official = official;
}

@end
