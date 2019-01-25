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
    NSString *_descriptiveTitle;
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

+ (BibMarcRecordFieldTag *)isbnFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"020"];
    fieldTag->_descriptiveTitle = @"ISBN";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)lccFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"050"];
    fieldTag->_descriptiveTitle = @"LCC";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)ddcFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"082"];
    fieldTag->_descriptiveTitle = @"DDC";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)authorFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"100"];
    fieldTag->_descriptiveTitle = @"Author";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)titleFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"245"];
    fieldTag->_descriptiveTitle = @"Title";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)editionFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"250"];
    fieldTag->_descriptiveTitle = @"Edition";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)publicationFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"264"];
    fieldTag->_descriptiveTitle = @"Publication";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)physicalDescriptionFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"300"];
    fieldTag->_descriptiveTitle = @"Physical-Description";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)noteFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"500"];
    fieldTag->_descriptiveTitle = @"Note";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)bibliographyFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"504"];
    fieldTag->_descriptiveTitle = @"Bibliography";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)summaryFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"520"];
    fieldTag->_descriptiveTitle = @"Summary";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)subjectFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"650"];
    fieldTag->_descriptiveTitle = @"Subject";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)genreFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"655"];
    fieldTag->_descriptiveTitle = @"Genre";
    return fieldTag;
}

+ (BibMarcRecordFieldTag *)seriesFieldTag {
    BibMarcRecordFieldTag *const fieldTag = [[BibMarcRecordFieldTag alloc] initWithString:@"940"];
    fieldTag->_descriptiveTitle = @"Series";
    return fieldTag;
}

@end
