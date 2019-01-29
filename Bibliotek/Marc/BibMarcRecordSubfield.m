//
//  BibMarcRecordSubfield.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordError.h"
#import "BibMarcRecordSubfield.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"

#define guard(predicate) if(!((predicate)))

#define BIB_ASSERT_VALID_SUBFILED_CODE(CODE) do {                                                                      \
    NSAssert([((CODE)) length] == 1, @"Invalid subfield code \"%@\": "                                                 \
             @"Subfield codes must be exactly one lowercase ASCII character", ((CODE)));                               \
    NSAssert([[NSCharacterSet bib_lowercaseAlphanumericCharacterSet] characterIsMember:[((CODE)) characterAtIndex:0]], \
             @"Invalid subfield code \"%@\": Subfield codes must be a lowercase ASCII character", ((CODE)));           \
} while(0)

static NSString *const BibMarcRecordSubfieldInvalidCodeException = @"BibMarcRecordSubfieldInvalidCodeException";

@implementation BibMarcRecordSubfield {
@protected
    NSString *_code;
    NSString *_content;
}

@synthesize code = _code;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithCode:@"a" content:@""];
}

- (instancetype)initWithCode:(NSString *)code content:(NSString *)content {
    return [self initWithCode:code content:content error:NULL];
}

- (instancetype)initWithCode:(NSString *)code content:(NSString *)content error:(NSError *__autoreleasing *)error {
    guard([BibMarcRecordSubfield validateSubfieldCode:code error:error]) {
        return nil;
    }
    if (self = [super init]) {
        _code = [code copy];
        _content = [content copy] ?: @"";
    }
    return self;
}

+ (instancetype)subfieldWithCode:(NSString *)code content:(NSString *)content error:(NSError *__autoreleasing *)error {
    return [[self alloc] initWithCode:code content:content error:error];
}

+ (instancetype)subfieldWithCode:(NSString *)code content:(NSString *)content {
    return [self subfieldWithCode:code content:content error:NULL];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSError *error = nil;
    self = [self initWithCode:[aDecoder decodeObjectForKey:@"code"]
                      content:[aDecoder decodeObjectForKey:@"content"]
                        error:&error];
    guard(error == nil) {
        NSString *const description = [error localizedDescription];
        NSString *const reason = [error localizedFailureReason];
        [NSException raise:BibMarcRecordSubfieldInvalidCodeException format:@"%@: %@", description, reason];
        return nil;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    if (zone == nil && [[self class] isEqualTo:[BibMarcRecordSubfield class]]) {
        return self;
    }
    return [[BibMarcRecordSubfield allocWithZone:zone] initWithCode:_code content:_content];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableSubfield allocWithZone:zone] initWithCode:_code content:_content];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_code forKey:@"code"];
    [aCoder encodeObject:_content forKey:@"content"];
}

+ (BOOL)supportsSecureCoding { return YES; }

- (BOOL)isEqualToSubfield:(BibMarcRecordSubfield *)other {
    return (_code == [other code] || [_code isEqualToString:[other code]])
        && (_content == [other content] || [_content isEqualToString:[other content]]);
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordSubfield class]] && [self isEqualToSubfield:other]);
}

- (NSUInteger)hash {
    return [_code hash] ^ [_content hash];
}

+ (BOOL)validateSubfieldCode:(NSString *)code error:(NSError *__autoreleasing *)error {
    guard([code length] == 1) {
        guard(error != nil) { return NO; }
        NSString *const description = [NSString stringWithFormat:@"Invalid subfield code \"%@\"", code];
        NSString *const reason = @"Subfield codes are exactly one character.";
        *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                     code:BibMarcRecordErrorInvalidCharacterCount
                                 userInfo:@{ NSLocalizedDescriptionKey : description,
                                             NSLocalizedFailureReasonErrorKey : reason }];
        return NO;
    }
    guard([code bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIILowercaseAlphanumericCharacterSet]
                                       inRange:NSRangeFromString(code)]) {
        guard(error != nil) { return NO; }
        NSString *const description = [NSString stringWithFormat:@"Invalid subfield code \"%@\"", code];
        NSString *const reason = @"Subfield codes are ASCII lowercase and numeric characters.";
        *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                     code:BibMarcRecordErrorInvalidCharacterCount
                                 userInfo:@{ NSLocalizedDescriptionKey : description,
                                             NSLocalizedFailureReasonErrorKey : reason }];
        return NO;
    }
    return YES;
}

@end

@implementation BibMarcRecordMutableSubfield

@dynamic code;
+ (BOOL)automaticallyNotifiesObserversOfCode { return NO; }
- (void)setCode:(NSString *)code {
    if (_code == code) {
        return;
    }
    NSError *error = nil;
    guard([BibMarcRecordSubfield validateSubfieldCode:code error:&error]) {
        NSString *const description = [error localizedDescription];
        NSString *const reason = [error localizedFailureReason];
        [NSException raise:BibMarcRecordSubfieldInvalidCodeException format:@"%@: %@", description, reason];
        return;
    }
    [self willChangeValueForKey:@"code"];
    _code = [code copy];
    [self didChangeValueForKey:@"code"];
}

@dynamic content;
+ (BOOL)automaticallyNotifiesObserversOfContent { return NO; }
- (void)setContent:(NSString *)content {
    if (_content == content) {
        return;
    }
    [self willChangeValueForKey:@"content"];
    _content = [content copy];
    [self didChangeValueForKey:@"content"];
}

@end
