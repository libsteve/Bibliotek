//
//  _BibMarcRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "_BibMarcRecord.h"
#import "BibMarcRecordControlField.h"
#import "BibMarcRecordDataField.h"

@implementation _BibMarcRecord {
@protected
    NSString *_leader;
    NSArray<BibMarcRecordControlField *> *_controlFields;
    NSArray<BibMarcRecordDataField *> *_dataFields;
}

@synthesize leader = _leader;
@synthesize controlFields = _controlFields;
@synthesize dataFields = _dataFields;

- (instancetype)init {
    return [self initWithLeader:@"" controlFields:[NSArray array] dataFields:[NSArray array]];
}

- (instancetype)initWithLeader:(NSString *)leader
                 controlFields:(NSArray<BibMarcRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibMarcRecordDataField *> *)dataFields {
    if (self = [super init]) {
        _leader = [leader copy];
        _controlFields = [controlFields copy];
        _dataFields = [dataFields copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithLeader:[aDecoder decodeObjectForKey:@"leader"]
                  controlFields:[aDecoder decodeObjectForKey:@"controlFields"]
                     dataFields:[aDecoder decodeObjectForKey:@"dataFields"]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[_BibMarcRecord allocWithZone:zone] initWithLeader:_leader
                                                 controlFields:_controlFields
                                                    dataFields:_dataFields];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[_BibMutableMarcRecord allocWithZone:zone] initWithLeader:_leader
                                                        controlFields:_controlFields
                                                           dataFields:_dataFields];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_leader forKey:@"leader"];
    [aCoder encodeObject:_controlFields forKey:@"controlFields"];
    [aCoder encodeObject:_dataFields forKey:@"dataFields"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToRecord:(_BibMarcRecord *)other {
    return [_leader isEqualToString:[other leader]]
        && [_controlFields isEqualToArray:[other controlFields]]
        && [_dataFields isEqualToArray:[other dataFields]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[_BibMarcRecord class]] && [self isEqualToRecord:other]);
}

- (NSUInteger)hash {
    return [_leader hash] ^ [_controlFields hash] ^ [_dataFields hash];
}

@end

@implementation _BibMutableMarcRecord

@dynamic leader;
- (void)setLeader:(NSString *)leader {
    if (_leader == leader) {
        return;
    }
    [self willChangeValueForKey:@"leader"];
    _leader = [leader copy];
    [self didChangeValueForKey:@"leader"];
}

@dynamic controlFields;
- (void)setControlFields:(NSArray<BibMarcRecordControlField *> *)controlFields {
    if (_controlFields == controlFields) {
        return;
    }
    [self willChangeValueForKey:@"controlFields"];
    _controlFields = [controlFields copy];
    [self didChangeValueForKey:@"controlFields"];
}

@dynamic dataFields;
- (void)setDataFields:(NSArray<BibMarcRecordDataField *> *)dataFields {
    if (_dataFields == dataFields) {
        return;
    }
    [self willChangeValueForKey:@"dataFields"];
    _dataFields = [dataFields copy];
    [self didChangeValueForKey:@"dataFields"];
}

@end
