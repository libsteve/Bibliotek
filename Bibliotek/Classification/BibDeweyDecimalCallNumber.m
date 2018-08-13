//
//  BibDeweyDecimalCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationSystem.h"
#import "BibDeweyDecimalCallNumber.h"
#import "BibMarcRecordField.h"

static NSRegularExpression *regex;

@implementation BibDeweyDecimalCallNumber

- (NSString *)expanded {
    return [NSString stringWithFormat:@"%@%@", _abridged, _qualification];
}

- (instancetype)initWithCallNumber:(BibDeweyDecimalCallNumber *)callNumber {
    if (self = [super init]) {
        _abridged = [[callNumber abridged] copy];
        _qualification = [[callNumber qualification] copy];
        _itemComponents = [[callNumber itemComponents] copy];
    }
    return self;
}

#pragma mark - BibCallNumber

- (BibClassificationSystem *)system {
    return [BibClassificationSystem deweyDecimal];
}

- (NSString *)classification {
    return [self expanded];
}

- (NSString *)item {
    return [_itemComponents componentsJoinedByString:@" "];
}

- (instancetype)initWithString:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange const range = NSMakeRange(0, string.length);
    NSTextCheckingResult *const result = [regex firstMatchInString:string options:0 range:range];
    if (result == nil) {
        return nil;
    }
    if (self = [super init]) {
        NSRange const head = [result rangeWithName:@"Head"];
        NSRange const tail = [result rangeWithName:@"Tail"];
        _abridged = [string substringWithRange:head];
        _qualification = (tail.location == NSNotFound) ? @"" : [string substringWithRange:tail];
        _itemComponents = @[];
    }
    return self;
}

- (nullable instancetype)initWithField:(BibMarcRecordField *)field {
    if ([[field fieldTag] isEqualToString:[[self system] fieldTag]]) {
        NSString *const a = field['a'];
        if (a) {
            return [self initWithString:a];
        }
    }
    return nil;
}

- (BOOL)isEqualToCallNumber:(id<BibCallNumber>)callNumber {
    if ([callNumber isKindOfClass:[BibDeweyDecimalCallNumber class]]) {
        BibDeweyDecimalCallNumber *number = callNumber;
        return [_abridged isEqualToString:[number abridged]]
            && [_qualification isEqualToString:[number qualification]]
            && [_itemComponents isEqualToArray:[number itemComponents]];
    }
    return NO;
}

- (BOOL)isSimilarToCallNumber:(id<BibCallNumber>)callNumber {
    if ([callNumber isKindOfClass:[BibDeweyDecimalCallNumber class]]) {
        BibDeweyDecimalCallNumber *number = callNumber;
        return [_abridged isEqualToString:[number abridged]]
            && [_qualification isEqualToString:[number qualification]];
    }
    return NO;
}

#pragma mark - NSSecureCoding

typedef NSString *CodingKeys NS_EXTENSIBLE_STRING_ENUM;
static CodingKeys const CallNumberAbridged = @"CallNumberAbridged";
static CodingKeys const CallNumberQualification = @"CallNumberQualification";
static CodingKeys const CallNumberItemComponents = @"CallNumberItemComponents";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _abridged = [aDecoder decodeObjectForKey:CallNumberAbridged];
        _qualification = [aDecoder decodeObjectForKey:CallNumberQualification];
        _itemComponents = [aDecoder decodeObjectForKey:CallNumberItemComponents];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_abridged forKey:CallNumberAbridged];
    [aCoder encodeObject:_qualification forKey:CallNumberQualification];
    [aCoder encodeObject:_itemComponents forKey:CallNumberItemComponents];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[BibDeweyDecimalCallNumber allocWithZone:zone] initWithCallNumber:self];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[BibDeweyDecimalCallNumber class]]) {
        return [self isEqualToCallNumber:object];
    }
    return NO;
}

- (NSUInteger)hash {
    return [[self debugDescription] hash];
}

- (NSString *)description {
    if (_itemComponents.count > 0) {
        return [@[ [self classification], [self item] ] componentsJoinedByString:@" "];
    }
    return [self classification];
}

- (NSString *)debugDescription {
    if ([_qualification isEqualToString:@""]) {
        NSArray *const components = [@[ _abridged ] arrayByAddingObjectsFromArray:_itemComponents];
        return [components componentsJoinedByString:@""];
    }
    NSString *const expanded = [NSString stringWithFormat:@"%@/%@", _abridged, _qualification];
    NSArray *const components = [@[ expanded ] arrayByAddingObjectsFromArray:_itemComponents];
    return [components componentsJoinedByString:@""];
}

#pragma mark - Objective-C

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *pattern = [@[ @"^(?<Head>\\d{3}(?:.\\d+)?)",
                                @"(?:[\\/](?<Tail>\\d*(?:\\.\\d+)?))?",
                                @"$"] componentsJoinedByString:@""];
        NSError *error = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:pattern  options:0 error:&error];
        NSAssert(error == nil, @"%@", error);
    });
}

@end
