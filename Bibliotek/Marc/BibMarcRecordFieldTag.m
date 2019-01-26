//
//  BibMarcRecordFieldTag.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordFieldTag.h"

@implementation BibMarcRecordFieldTag {
@protected
    NSString *_stringValue;
}

- (instancetype)init {
    return [self initWithString:@"000"];
}

- (instancetype)initWithString:(NSString *)stringValue {
    if (self = [super init]) {
        NSAssert([stringValue length] == 3, @"Invalid field tag \"%@\": Field tags are 3-digit codes", stringValue);
        NSCharacterSet *const decimalDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
        NSString *const trimmedString = [stringValue stringByTrimmingCharactersInSet:decimalDigitCharacterSet];
        NSAssert([trimmedString length] != 0, @"Invalid field tag \"%@\": Field tags are 3-digit codes", stringValue);
        _stringValue = [stringValue copy];
    }
    return self;
}

+ (nullable instancetype)fieldTagWithString:(NSString *)stringValue {
    return [[self alloc] initWithString:stringValue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObjectForKey:@"stringValue"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue forKey:@"stringValue"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToFieldTag:(BibMarcRecordFieldTag *)other {
    return [_stringValue isEqualToString:[other stringValue]];
}

- (BOOL)isEqual:(id)other
{
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordFieldTag class]] && [self isEqualTo:other]);
}

- (NSUInteger)hash
{
    return [_stringValue hash];
}

- (NSString *)description {
    return _stringValue;
}

- (NSComparisonResult)compare:(BibMarcRecordFieldTag *)fieldTag {
    return [_stringValue compare:[fieldTag stringValue]];
}

@end

@implementation BibMarcRecordFieldTag (KnownValidFieldTags)

+ (BibMarcRecordFieldTag *)isbnFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"020"];
}

+ (BibMarcRecordFieldTag *)lccFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"050"];
}

+ (BibMarcRecordFieldTag *)ddcFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"082"];
}

+ (BibMarcRecordFieldTag *)authorFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"100"];
}

+ (BibMarcRecordFieldTag *)titleFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"245"];
}

+ (BibMarcRecordFieldTag *)editionFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"250"];
}

+ (BibMarcRecordFieldTag *)publicationFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"264"];
}

+ (BibMarcRecordFieldTag *)physicalDescriptionFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"300"];
}

+ (BibMarcRecordFieldTag *)noteFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"500"];
}

+ (BibMarcRecordFieldTag *)bibliographyFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"504"];
}

+ (BibMarcRecordFieldTag *)summaryFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"520"];
}

+ (BibMarcRecordFieldTag *)subjectFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"650"];
}

+ (BibMarcRecordFieldTag *)genreFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"655"];
}

+ (BibMarcRecordFieldTag *)seriesFieldTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"830"];
}

@end
