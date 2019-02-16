//
//  BibMarcTag.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcTag.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"

#define guard(predicate) if(!((predicate)))

@implementation BibMarcTag {
@protected
    NSString *_stringValue;
    BOOL _isControlFieldTag;
}

@synthesize stringValue = _stringValue;
@synthesize isControlFieldTag = _isControlFieldTag;

- (instancetype)init {
    return [self initWithString:@"000"];
}

- (instancetype)initWithString:(NSString *)stringValue {
    if (self = [super init]) {
        guard([stringValue length] == 3) {
            return nil;
        }
        guard([stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIAlphanumericCharacterSet]
                                                  inRange:NSRangeFromString(stringValue)]) {
            return nil;
        }
        _stringValue = [stringValue copy];
        _isControlFieldTag = [[stringValue substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"00"];
    }
    return self;
}

+ (instancetype)tagWithString:(NSString *)stringValue {
    return [self tagWithString:stringValue];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObject]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithDecoder:(id<BibDecoder>)decoder error:(NSError *__autoreleasing  _Nullable *)error {
    NSString *const string = [[decoder singleValueDecoder:error] decodeString:error];
    guard (string) { return nil; }
    BibMarcTag *const tag = [self initWithString:string];
    guard (tag) {
        guard (error) { return nil; }
        // TODO: create error
        return nil;
    }
    return tag;
}

#pragma mark - Equality

- (BOOL)isEqualToTag:(BibMarcTag *)tag {
    return [_stringValue isEqualToString:[tag stringValue]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcTag class]] && [self isEqualToTag:other]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

- (NSString *)description {
    return _stringValue;
}

- (NSComparisonResult)compare:(BibMarcTag *)tag {
    return [_stringValue compare:[tag stringValue]];
}

@end

#pragma mark -

@implementation BibMarcTag (KnownValidFieldTags)

+ (BibMarcTag *)controlNumberTag {
    return [[BibMarcTag alloc] initWithString:@"001"];
}

+ (BibMarcTag *)isbnTag {
    return [[BibMarcTag alloc] initWithString:@"020"];
}

+ (BibMarcTag *)lccTag {
    return [[BibMarcTag alloc] initWithString:@"050"];
}

+ (BibMarcTag *)ddcTag {
    return [[BibMarcTag alloc] initWithString:@"082"];
}

+ (BibMarcTag *)authorTag {
    return [[BibMarcTag alloc] initWithString:@"100"];
}

+ (BibMarcTag *)titleTag {
    return [[BibMarcTag alloc] initWithString:@"245"];
}

+ (BibMarcTag *)editionTag {
    return [[BibMarcTag alloc] initWithString:@"250"];
}

+ (BibMarcTag *)publicationTag {
    return [[BibMarcTag alloc] initWithString:@"264"];
}

+ (BibMarcTag *)physicalDescriptionTag {
    return [[BibMarcTag alloc] initWithString:@"300"];
}

+ (BibMarcTag *)noteTag {
    return [[BibMarcTag alloc] initWithString:@"500"];
}

+ (BibMarcTag *)bibliographyTag {
    return [[BibMarcTag alloc] initWithString:@"504"];
}

+ (BibMarcTag *)summaryTag {
    return [[BibMarcTag alloc] initWithString:@"520"];
}

+ (BibMarcTag *)subjectTag {
    return [[BibMarcTag alloc] initWithString:@"650"];
}

+ (BibMarcTag *)genreTag {
    return [[BibMarcTag alloc] initWithString:@"655"];
}

+ (BibMarcTag *)seriesTag {
    return [[BibMarcTag alloc] initWithString:@"830"];
}

@end
