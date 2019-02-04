//
//  BibMarcRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecord.h"
#import "BibMarcControlField.h"
#import "BibMarcDataField.h"
#import "BibMarcLeader.h"

@implementation BibMarcRecord {
@protected
    BibMarcLeader *_leader;
    NSArray<BibMarcControlField *> *_controlFields;
    NSArray<BibMarcDataField *> *_dataFields;
}

@synthesize leader = _leader;
@synthesize controlFields = _controlFields;
@synthesize dataFields = _dataFields;

- (instancetype)init {
    return [self initWithLeader:[BibMarcLeader new] controlFields:[NSArray array] dataFields:[NSArray array]];
}

- (instancetype)initWithLeader:(BibMarcLeader *)leader
                 controlFields:(NSArray<BibMarcControlField *> *)controlFields
                    dataFields:(NSArray<BibMarcDataField *> *)dataFields {
    if (self = [super init]) {
        _leader = [leader copy];
        _controlFields = [controlFields copy];
        _dataFields = [dataFields copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithLeader:[aDecoder decodeObjectForKey:@"leader"]
                  controlFields:[aDecoder decodeObjectForKey:@"controlfields"]
                     dataFields:[aDecoder decodeObjectForKey:@"datafields"]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMarcRecord allocWithZone:zone] initWithLeader:_leader
                                                 controlFields:_controlFields
                                                    dataFields:_dataFields];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableMarcRecord allocWithZone:zone] initWithLeader:_leader
                                                        controlFields:_controlFields
                                                           dataFields:_dataFields];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_leader forKey:@"leader"];
    [aCoder encodeObject:_controlFields forKey:@"controlfields"];
    [aCoder encodeObject:_dataFields forKey:@"datafields"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToRecord:(BibMarcRecord *)other {
    return [_leader isEqualToLeader:[other leader]]
        && [_controlFields isEqualToArray:[other controlFields]]
        && [_dataFields isEqualToArray:[other dataFields]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecord class]] && [self isEqualToRecord:other]);
}

- (NSUInteger)hash {
    return [_leader hash] ^ [_controlFields hash] ^ [_dataFields hash];
}

@end

@implementation BibMutableMarcRecord

@dynamic leader;
+ (BOOL)automaticallyNotifiesObserversOfLeader { return NO; }
- (void)setLeader:(BibMarcLeader *)leader {
    if (_leader == leader) {
        return;
    }
    [self willChangeValueForKey:@"leader"];
    _leader = [leader copy];
    [self didChangeValueForKey:@"leader"];
}

@dynamic controlFields;
+ (BOOL)automaticallyNotifiesObserversOfControlFields { return NO; }
- (void)setControlFields:(NSArray<BibMarcControlField *> *)controlFields {
    if (_controlFields == controlFields) {
        return;
    }
    [self willChangeValueForKey:@"controlFields"];
    _controlFields = [controlFields copy];
    [self didChangeValueForKey:@"controlFields"];
}

@dynamic dataFields;
+ (BOOL)automaticallyNotifiesObserversOfDataFields { return NO; }
- (void)setDataFields:(NSArray<BibMarcDataField *> *)dataFields {
    if (_dataFields == dataFields) {
        return;
    }
    [self willChangeValueForKey:@"dataFields"];
    _dataFields = [dataFields copy];
    [self didChangeValueForKey:@"dataFields"];
}

@end
