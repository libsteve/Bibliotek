//
//  BibLibraryOfCongressCallNumber.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationSystem.h"
#import "BibLibraryOfCongressCallNumber.h"
#import "BibMarcRecordField.h"

static NSRegularExpression *regex;

@implementation BibLibraryOfCongressCallNumber

- (instancetype)initWithCallNumber:(BibLibraryOfCongressCallNumber *)callNumber {
    if (self = [super init]) {
        _subjectArea = [[callNumber subjectArea] copy];
        _topic = [[callNumber topic] copy];
        _cutters = [[callNumber cutters] copy];
        _date = [[callNumber date] copy];
        _work = [[callNumber work] copy];
    }
    return self;
}

#pragma mark - BibCallNumber

- (BibClassificationSystem *)system {
    return [BibClassificationSystem libraryOfCongress];
}

- (NSString *)classification {
    NSArray *components = @[ _subjectArea, _topic ];
    if ([_cutters count] > 1) {
        NSRange const range = NSMakeRange(0, [_cutters count] - 1);
        NSMutableArray *const cutters = [[_cutters subarrayWithRange:range] mutableCopy];
        components = [components arrayByAddingObject:({
            [NSString stringWithFormat:@".%@", [cutters componentsJoinedByString:@" "]];
        })];
    }
    return [components componentsJoinedByString:@" "];
}

- (NSString *)item {
    NSMutableString *item = [NSMutableString new];
    switch ([_cutters count]) {
        case 0: break;
        case 1:
            [item appendString:@"."];
        default:
            [item appendString:[_cutters lastObject]];
            [item appendString:@" "];
    }
    [item appendString:_date];
    if (_work != nil) {
        [item appendString:_work];
    }
    return [item copy];
}

- (instancetype)initWithString:(NSString *)string {
    NSRange const range = NSMakeRange(0, string.length);
    NSTextCheckingResult *const result = [regex firstMatchInString:string options:0 range:range];
    if (result == nil) {
        return nil;
    }
    NSRange const subject = [result rangeWithName:@"Subject"];
    NSRange const topic = [result rangeWithName:@"Topic"];
    NSRange const date = [result rangeWithName:@"Date"];
    NSRange const work = [result rangeWithName:@"Work"];
    if (self = [super init]) {
        _subjectArea = [string substringWithRange:subject];
        _topic = [string substringWithRange:topic];
        _date = [string substringWithRange:date];
        _work = (work.location == NSNotFound) ? nil : [string substringWithRange:work];
        NSRange const topicDate = [result rangeWithName:@"TopicDate"];
        if (topicDate.location != NSNotFound) {
            NSString *const date = [string substringWithRange:topicDate];
            _topic = [NSString stringWithFormat:@"%@ %@", _topic, date];
        }
        NSMutableArray *cutters = [NSMutableArray new];
        for (unsigned index = 0; index < 10; index += 1) {
            NSString *const key = [NSString stringWithFormat:@"Cutter%u", index];
            NSRange const range = [result rangeWithName:key];
            if (range.location == NSNotFound) {
                continue;
            }
            NSString *const cutter = [string substringWithRange:range];
            NSString *const dateKey = [NSString stringWithFormat:@"CutterDate%u", index];
            NSRange const dateRange = [result rangeWithName:dateKey];
            if (dateRange.location == NSNotFound) {
                [cutters addObject:cutter];
            } else {
                NSString *const date = [string substringWithRange:range];
                [cutters addObject:[NSString stringWithFormat:@"%@ %@", cutter, date]];
            }
        }
        _cutters = [cutters copy];
    }
    return self;
}

- (nullable instancetype)initWithField:(BibMarcRecordField *)field {
    if ([[field fieldTag] isEqualToString:[[self system] fieldTag]]) {
        return [self initWithString:[@[ field['a'], field['b'] ] componentsJoinedByString:@" "]];
    }
    return nil;
}

- (BOOL)isEqualToCallNumber:(id<BibCallNumber>)callNumber {
    if ([callNumber isKindOfClass:[BibLibraryOfCongressCallNumber class]]) {
        BibLibraryOfCongressCallNumber *other = callNumber;
        return [_subjectArea isEqualToString:[other subjectArea]]
            && [_topic isEqualToString:[other topic]]
            && [_date isEqualToString:[other date]]
            && [_cutters isEqualToArray:[other cutters]]
            && (_work == [other work] || [_work isEqualToString:[other work]]);
    }
    return NO;
}

- (BOOL)isSimilarToCallNumber:(id<BibCallNumber>)callNumber {
    if ([callNumber isKindOfClass:[BibLibraryOfCongressCallNumber class]]) {
        BibLibraryOfCongressCallNumber *other = callNumber;
        if ([_subjectArea isEqualToString:[other subjectArea]] && [_topic isEqualToString:[other topic]]) {
            NSUInteger const cutterCount = MAX([_cutters count] - 1, 0);
            NSUInteger const otherCutterCount = MAX([[other cutters] count] - 1, 0);
            NSArray *cutters = [_cutters subarrayWithRange:NSMakeRange(0, cutterCount)];
            NSArray *otherCutters = [[other cutters] subarrayWithRange:NSMakeRange(0, otherCutterCount)];
            return [cutters isEqualToArray:otherCutters];
        }
    }
    return NO;
}

#pragma mark - NSSecureCoding

typedef NSString *CodingKeys NS_EXTENSIBLE_STRING_ENUM;
static CodingKeys const CallNumberSubjectArea = @"CallNumberSubjectArea";
static CodingKeys const CallNumberTopic = @"CallNumberTopic";
static CodingKeys const CallNumberDate = @"CallNumberDate";
static CodingKeys const CallNumberWork = @"CallNumberWork";
static CodingKeys const CallNumberCutters = @"CallNumberCutters";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _subjectArea = [aDecoder decodeObjectForKey:CallNumberSubjectArea];
        _topic = [aDecoder decodeObjectForKey:CallNumberTopic];
        _date = [aDecoder decodeObjectForKey:CallNumberDate];
        _work = [aDecoder decodeObjectForKey:CallNumberWork];
        _cutters = [aDecoder decodeObjectForKey:CallNumberCutters];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_subjectArea forKey:CallNumberSubjectArea];
    [aCoder encodeObject:_topic forKey:CallNumberTopic];
    [aCoder encodeObject:_date forKey:CallNumberDate];
    [aCoder encodeObject:_work forKey:CallNumberWork];
    [aCoder encodeObject:_cutters forKey:CallNumberCutters];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[BibLibraryOfCongressCallNumber allocWithZone:zone] initWithCallNumber:self];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[BibLibraryOfCongressCallNumber class]]) {
        return [self isEqualToCallNumber:object];
    }
    return NO;
}

- (NSUInteger)hash {
    return [[self description] hash];
}

- (NSString *)description {
    return [@[ [self classification], [self item] ] componentsJoinedByString:@" "];
}

#pragma mark - Objective-C


+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *const components = [@[ @"^",
                                               @"(?<Subject>[A-Z]+)" ] mutableCopy];
        [components addObject:({
            NSString *const topic = @"(?<Topic>\\d+(?:\\.\\d+)?)";
            NSString *const date = @"\\s+(?<TopicDate>\\d{1,4})\\s+";
            [NSString stringWithFormat:@"(?:\\s*%@(?:%@)?)", topic, date];
        })];
        [components addObject:({
            NSString *const cutter = @"\\.(?<Cutter0>[A-Z]+\\d*)";
            NSString *const date = @"\\s+(?<CutterDate0>\\d{1,4})\\s+";
            [NSString stringWithFormat:@"(?:\\s*%@(?:%@)?)", cutter, date];
        })];
        for (unsigned index = 1; index < 10; index += 1) {
            NSString *const cutter = [NSString stringWithFormat:@"(?<Cutter%u>[A-Z]+\\d*)", index];
            NSString *const date = [NSString stringWithFormat:@"\\s+(?<CutterDate%u>\\d{1,4})\\s+", index];
            [components addObject:[NSString stringWithFormat:@"(?:\\s*%@(?:%@)?)?", cutter, date]];
        }
        [components addObject:({
            NSString *const date = @"(?<Date>\\d{1,4})";
            NSString *const work = @"(?<Work>[a-z])";
            [NSString stringWithFormat:@"(?:\\s+%@%@?)", date, work];
        })];
        [components addObject:@"$"];
        NSString *const pattern = [components componentsJoinedByString:@""];
        NSError *error = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:pattern  options:0 error:&error];
        NSAssert(error == nil, @"%@", error);
    });
}

@end
