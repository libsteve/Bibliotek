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
                                @"(?<Subject>[A-Z]+)",
                                @"\\s*(?<Topic>\\d+(?:\\.\\d+)?)?",
                                @"\\s*(?<Cutter0>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter1>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter2>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter3>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter4>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter5>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter6>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter7>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter8>\\.?[A-Z]+\\d*)?",
                                @"\\s*(?<Cutter9>\\.?[A-Z]+\\d*)?",
                                @"\\s+(?<Date>\\d{1,4}[a-z]?)?" ] componentsJoinedByString:@""];
        NSError *error = nil;
        lccRegex = [NSRegularExpression regularExpressionWithPattern:pattern  options:0 error:&error];
        NSAssert(error == nil, @"%@", error);
    });
}

- (instancetype)init {
    return [self initWithAcronym:@"" description:@"" fieldTag:@""];
}

- (instancetype)initWithAcronym:(NSString *)acronym description:(NSString *)description fieldTag:(_BibMarcRecordFieldTag)fieldTag {
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

+ (instancetype)systemForFieldTag:(_BibMarcRecordFieldTag)fieldTag {
    NSArray *const systems = @[[self libraryOfCongress], [self deweyDecimal]];
    for (BibClassificationSystem *system in systems) {
        if ([fieldTag isEqualToString:[system fieldTag]]) {
            return system;
        }
    }
    return nil;
}

#pragma mark - Properties

- (NSString *)description {
    return _description;
}

+ (BibClassificationSystem *)deweyDecimal {
    static BibClassificationSystem *system;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        system = [[BibClassificationSystem alloc] initWithAcronym:@"DDC" description:@"Dewey Decimal Classification" fieldTag:BibMarcRecordFieldTagDDC];
    });
    return system;
}

+ (BibClassificationSystem *)libraryOfCongress {
    static BibClassificationSystem *system;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        system = [[BibClassificationSystem alloc] initWithAcronym:@"LCC" description:@"Library of Congress Classification" fieldTag:BibMarcRecordFieldTagLCC];
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
