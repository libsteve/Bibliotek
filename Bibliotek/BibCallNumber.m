//
//  BibCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibCallNumber.h"
#import "BibClassificationSystem.h"
#import "BibMarcRecordField.h"

@implementation BibCallNumber {
@protected
    NSArray<NSString *> *_components;
    BibClassificationSystem *_system;
}

- (instancetype)init {
    return [self initWithComponents:@[] system:[BibClassificationSystem new]];
}

- (instancetype)initWithString:(NSString *)string system:(BibClassificationSystem *)system {
    NSArray *components = [system componentsFromString:string];
    return [self initWithComponents:components system:system];
}

- (instancetype)initWithComponents:(NSArray<NSString *> *)components system:(BibClassificationSystem *)system {
    if (self = [super init]) {
        _components = [components copy];
        _system = system;
    }
    return self;
}

- (instancetype)initWithCallNumber:(BibCallNumber *)callNumber {
    return [self initWithComponents:[callNumber components] system:[callNumber system]];
}

- (instancetype)initWithField:(BibMarcRecordField *)field {
    if ([field.fieldTag isEqualToString:[[BibClassificationSystem lcc] fieldTag]]) {
        NSString *string = [NSString stringWithFormat:@"%@ %@", field['a'], field['b']];
        return [self initWithString:string system:[BibClassificationSystem lcc]];
    } else if ([field.fieldTag isEqualToString:[[BibClassificationSystem ddc] fieldTag]]) {
        return [self initWithString:field['a']  system:[BibClassificationSystem ddc]];
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithComponents:[aDecoder decodeObjectForKey:@"components"] system:[aDecoder decodeObjectForKey:@"system"]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibCallNumber alloc] initWithCallNumber:self];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_components forKey:@"components"];
    [aCoder encodeObject:_system forKey:@"system"];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Properties

@synthesize system = _system;

- (NSString *)description {
    return [[self components] componentsJoinedByString:@" "];
}

- (NSString *)spineDescription {
    return [[self components] componentsJoinedByString:@"\n"];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    return [self isKindOfClass:[object class]] && [self isEqualToCallNumber:object];
}

- (NSUInteger)hash {
    return [[self description] hash] ^ [_system hash];
}

- (BOOL)isEqualToCallNumber:(BibCallNumber *)callNumber {
    return [[self system] isEqualToSystem:[callNumber system]] && [[self components] isEqualToArray:[callNumber components]];
}

@end
