//
//  BibMarcRecordFieldTag.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordError.h"
#import "BibMarcRecordFieldTag.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"
#import <os/log.h>

#define guard(predicate) if(!((predicate)))

@implementation BibMarcRecordFieldTag {
@protected
    NSString *_stringValue;
    BOOL _isControlFieldTag;
}

@synthesize stringValue = _stringValue;
@synthesize isControlFieldTag = _isControlFieldTag;

- (instancetype)init {
    return [self initWithString:@"000" error:NULL];
}

- (instancetype)initWithString:(NSString *)stringValue error:(NSError *__autoreleasing *)error {
    if (self = [super init]) {
        guard([stringValue length] == 3) {
            guard(error != nil) { return nil; }
            NSString *const description = [NSString stringWithFormat:@"Invalid record field tag \"%@\"", stringValue];
            NSString *const reason = @"Record field tags are always 3-digit codes.";
            *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                         code:BibMarcRecordErrorInvalidCharacterCount
                                     userInfo:@{ NSLocalizedDescriptionKey : description,
                                                 NSLocalizedFailureReasonErrorKey : reason }];
            return nil;
        }
        guard([stringValue bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIIAlphanumericCharacterSet]
                                                  inRange:NSRangeFromString(stringValue)]) {
            guard(error != nil) { return nil; }
            NSString *const description = [NSString stringWithFormat:@"Invalid record field tag \"%@\"", stringValue];
            NSString *const reason = @"Record field tags contain only ASCII alphanumeric characters.";
            *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                         code:BibMarcRecordErrorInvalidCharacterCount
                                     userInfo:@{ NSLocalizedDescriptionKey : description,
                                                 NSLocalizedFailureReasonErrorKey : reason }];
            return nil;
        }
        _stringValue = [stringValue copy];
        _isControlFieldTag = [[stringValue substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"00"];
    }
    return self;
}

+ (instancetype)fieldTagWithString:(NSString *)stringValue error:(NSError *__autoreleasing *)error {
    return [[self alloc] initWithString:stringValue error:error];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSError *error = nil;
    self = [self initWithString:[aDecoder decodeObject] error:&error];
    guard(error == nil) {
        NSString *const description = [error localizedDescription];
        NSString *const reason = [error localizedFailureReason];
        [NSException raise:@"BibMarcRecordFieldInvalidTagException" format:@"%@: %@", description, reason];
        return nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToTag:(BibMarcRecordFieldTag *)tag {
    return [_stringValue isEqualToString:[tag stringValue]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordFieldTag class]] && [self isEqualToTag:other]);
}

- (NSUInteger)hash {
    return [_stringValue hash];
}

- (NSString *)description {
    return _stringValue;
}

- (NSComparisonResult)compare:(BibMarcRecordFieldTag *)tag {
    return [_stringValue compare:[tag stringValue]];
}

@end

@implementation BibMarcRecordFieldTag (KnownValidFieldTags)

+ (BibMarcRecordFieldTag *)controlNumberTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"001" error:NULL];
}

+ (BibMarcRecordFieldTag *)isbnTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"020" error:NULL];
}

+ (BibMarcRecordFieldTag *)lccTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"050" error:NULL];
}

+ (BibMarcRecordFieldTag *)ddcTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"082" error:NULL];
}

+ (BibMarcRecordFieldTag *)authorTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"100" error:NULL];
}

+ (BibMarcRecordFieldTag *)titleTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"245" error:NULL];
}

+ (BibMarcRecordFieldTag *)editionTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"250" error:NULL];
}

+ (BibMarcRecordFieldTag *)publicationTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"264" error:NULL];
}

+ (BibMarcRecordFieldTag *)physicalDescriptionTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"300" error:NULL];
}

+ (BibMarcRecordFieldTag *)noteTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"500" error:NULL];
}

+ (BibMarcRecordFieldTag *)bibliographyTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"504" error:NULL];
}

+ (BibMarcRecordFieldTag *)summaryTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"520" error:NULL];
}

+ (BibMarcRecordFieldTag *)subjectTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"650" error:NULL];
}

+ (BibMarcRecordFieldTag *)genreTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"655" error:NULL];
}

+ (BibMarcRecordFieldTag *)seriesTag {
    return [[BibMarcRecordFieldTag alloc] initWithString:@"830" error:NULL];
}

@end
