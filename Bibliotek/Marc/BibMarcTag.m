//
//  BibMarcTag.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordError.h"
#import "BibMarcTag.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"
#import <os/log.h>

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithString:[aDecoder decodeObject]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

+ (BOOL)supportsSecureCoding { return YES; }

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

@implementation BibMarcTag (KnownValidFieldTags)

+ (BibMarcTag *)controlNumberTag {
    return [[BibMarcTag alloc] initWithString:@"001" error:NULL];
}

+ (BibMarcTag *)isbnTag {
    return [[BibMarcTag alloc] initWithString:@"020" error:NULL];
}

+ (BibMarcTag *)lccTag {
    return [[BibMarcTag alloc] initWithString:@"050" error:NULL];
}

+ (BibMarcTag *)ddcTag {
    return [[BibMarcTag alloc] initWithString:@"082" error:NULL];
}

+ (BibMarcTag *)authorTag {
    return [[BibMarcTag alloc] initWithString:@"100" error:NULL];
}

+ (BibMarcTag *)titleTag {
    return [[BibMarcTag alloc] initWithString:@"245" error:NULL];
}

+ (BibMarcTag *)editionTag {
    return [[BibMarcTag alloc] initWithString:@"250" error:NULL];
}

+ (BibMarcTag *)publicationTag {
    return [[BibMarcTag alloc] initWithString:@"264" error:NULL];
}

+ (BibMarcTag *)physicalDescriptionTag {
    return [[BibMarcTag alloc] initWithString:@"300" error:NULL];
}

+ (BibMarcTag *)noteTag {
    return [[BibMarcTag alloc] initWithString:@"500" error:NULL];
}

+ (BibMarcTag *)bibliographyTag {
    return [[BibMarcTag alloc] initWithString:@"504" error:NULL];
}

+ (BibMarcTag *)summaryTag {
    return [[BibMarcTag alloc] initWithString:@"520" error:NULL];
}

+ (BibMarcTag *)subjectTag {
    return [[BibMarcTag alloc] initWithString:@"650" error:NULL];
}

+ (BibMarcTag *)genreTag {
    return [[BibMarcTag alloc] initWithString:@"655" error:NULL];
}

+ (BibMarcTag *)seriesTag {
    return [[BibMarcTag alloc] initWithString:@"830" error:NULL];
}

@end
