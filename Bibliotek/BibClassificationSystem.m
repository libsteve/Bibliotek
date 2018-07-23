//
//  BibClassificationSystem.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationSystem.h"

static NSRegularExpression *lccRegex;

@implementation BibClassificationSystem {
    NSString *_description;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// source: https://gist.github.com/kurtraschke/560162
        /// source: https://www.wikidata.org/wiki/Property:P1149
        NSString *pattern = [@[ @"^",
                                @"(?<Class>[A-Z]{1,3})",
                                @"\\s?(?<Topic>\\d{1,4}(?:\\.\\d{1,3})?)?",
                                @"\\s?(?<Cutter>\\.?[A-Z]+[0-9]*)*",
                                @"\\s(?<Date>\\d{1,4}[a-z]?)?" ] componentsJoinedByString:@""];
        NSError *error = nil;
        lccRegex = [NSRegularExpression regularExpressionWithPattern:pattern  options:0 error:&error];
        NSAssert(error == nil, @"%@", error);
    });
}

- (instancetype)init {
    return [self initWithAcronym:@"" description:@"" fieldTag:@""];
}

- (instancetype)initWithAcronym:(NSString *)acronym description:(NSString *)description fieldTag:(BibMarcRecordFieldTag)fieldTag {
    if (self = [super init]) {
        _acronym = [acronym copy];
        _description = [description copy];
        _fieldTag = [fieldTag copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithAcronym:[aDecoder decodeObjectForKey:@"acronym"]
                     description:[aDecoder decodeObjectForKey:@"description"]
                        fieldTag:[aDecoder decodeObjectForKey:@"fieldTag"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_acronym forKey:@"acronym"];
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_fieldTag forKey:@"fieldTag"];
}

+ (BOOL)supportsSecureCoding { return YES; }

+ (instancetype)systemForFieldTag:(BibMarcRecordFieldTag)fieldTag {
    NSArray *const systems = @[[self lcc], [self ddc]];
    for (BibClassificationSystem *system in systems) {
        if ([fieldTag isEqualToString:[system fieldTag]]) {
            return system;
        }
    }
    return nil;
}

- (NSArray<NSString *> *)componentsFromString:(NSString *)string {
    if ([_fieldTag isEqualToString:BibRecordFieldTagLCC]) {
        NSRange const range = NSMakeRange(0, string.length);
        NSTextCheckingResult *const result = [lccRegex firstMatchInString:string options:0 range:range];
        if (result == nil) {
            return nil;
        }
        NSMutableArray *components = [NSMutableArray new];
        NSUInteger const count = [result numberOfRanges];
        for (NSUInteger index = 1; index < count; index += 1) {
            NSRange const range = [result rangeAtIndex:index];
            if (range.location == NSNotFound) {
                continue;
            }
            [components addObject:[string substringWithRange:range]];
        }
        return components;
    } else if ([_fieldTag isEqualToString:BibRecordFieldTagDDC]) {
        return [[string stringByReplacingOccurrencesOfString:@"/" withString:@""] componentsSeparatedByString:@" "];
    }
    return nil;
}

#pragma mark - Properties

- (NSString *)description {
    return _description;
}

+ (BibClassificationSystem *)ddc {
    static BibClassificationSystem *system;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        system = [[BibClassificationSystem alloc] initWithAcronym:@"DDC" description:@"Dewey Decimal Classification" fieldTag:BibRecordFieldTagDDC];
    });
    return system;
}

+ (BibClassificationSystem *)lcc {
    static BibClassificationSystem *system;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        system = [[BibClassificationSystem alloc] initWithAcronym:@"LCC" description:@"Library of Congress Classification" fieldTag:BibRecordFieldTagLCC];
    });
    return system;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    return [self isKindOfClass:[object class]] && [self isEqualToSystem:object];
}

- (NSUInteger)hash {
    return [_acronym hash] ^ [_description hash];
}

- (BOOL)isEqualToSystem:(BibClassificationSystem *)system {
    return [_acronym isEqualToString:[system acronym]] && [_description isEqualToString:[system description]];
}

@end
