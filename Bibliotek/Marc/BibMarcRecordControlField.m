//
//  BibMarcRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordControlField.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"
#import <os/log.h>

#define guard(predicate) if(!((predicate)))

NSErrorDomain const BibMarcRecordControlFieldErrorDomain = @"brun.steve.bibliotek.marc21.controlfield.error";

static NSString *const kTagKey = @"tag";
static NSString *const kContentKey = @"content";

static BOOL sIsValidTag(NSString *tag);

@implementation BibMarcRecordControlField {
@protected
    NSString *_tag;
    NSString *_content;
}

@synthesize tag = _tag;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithTag:@"000" content:@"" error:NULL];
}

- (instancetype)initWithTag:(NSString *)tag content:(NSString *)content error:(NSError *__autoreleasing *)error {
    guard([BibMarcRecordControlField isValidControlFieldTag:tag error:error]) {
        return nil;
    }
    if (self = [super init]) {
        _tag = [tag copy];
        _content = [_content copy];
    }
    return self;
}

+ (instancetype)controlFieldWithTag:(NSString *)tag content:(NSString *)content error:(NSError *__autoreleasing *)error {
    return [[self alloc] initWithTag:tag content:content error:error];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMarcRecordControlField allocWithZone:zone] initWithTag:_tag content:_content error:NULL];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableControlField allocWithZone:zone] initWithTag:_tag content:_content error:NULL];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTag:[aDecoder decodeObjectForKey:kTagKey]
                     content:[aDecoder decodeObjectForKey:kContentKey]
                       error:NULL];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:kTagKey];
    [aCoder encodeObject:_content forKey:kContentKey];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Equality

- (BOOL)isEqualToControlField:(BibMarcRecordControlField *)other {
    return [_tag isEqualToString:[other tag]]
        && [_content isEqualToString:[other content]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordControlField class]] && [self isEqualToControlField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_content hash];
}

#pragma mark -

+ (void)throwError:(NSError *__autoreleasing *)error
          withCode:(NSInteger)code
           message:(NSString *)message
            reason:(NSString *)reason {
    guard(error) { return; }
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setObject:message forKeyedSubscript:NSLocalizedDescriptionKey];
    [userInfo setObject:reason forKeyedSubscript:NSLocalizedFailureReasonErrorKey];
    *error = [NSError errorWithDomain:BibMarcRecordControlFieldErrorDomain code:code userInfo:[userInfo copy]];
}

+ (BOOL)isValidControlFieldTag:(NSString *)tag error:(NSError *__autoreleasing *)error {
    guard([tag bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                      inRange:NSRangeFromString(tag)]
          && [tag length] == 3) {
        [self throwError:error
                withCode:1
                 message:[NSString stringWithFormat:@"Invalid control field tag \"%@\"", tag]
                  reason:@"MARC 21 tags are always 3 ASCII numerals"];
        return NO;
    }
    guard([[tag substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"00"]) {
        [self throwError:error
                withCode:2
                 message:[NSString stringWithFormat:@"Invalid control field tag \"%@\"", tag]
                  reason:@"MARC 21 control field tags must begin with 00"];
        return NO;
    }
    return YES;
}

@end

#pragma mark -

@implementation BibMarcRecordMutableControlField

@dynamic tag;
+ (BOOL)automaticallyNotifiesObserversOfTag { return NO; }
- (void)setTag:(NSString *)tag {
    if (_tag == tag) {
        return;
    }
    NSError *error = nil;
    guard([BibMarcRecordControlField isValidControlFieldTag:tag error:&error]) {
        NSLog(@"%@", error.localizedFailureReason ?: error.localizedDescription);
        return;
    }
    [self willChangeValueForKey:kTagKey];
    _tag = [tag copy];
    [self didChangeValueForKey:kTagKey];
}

@dynamic content;
+ (BOOL)automaticallyNotifiesObserversOfContent { return NO; }
- (void)setContent:(NSString *)content {
    if (_content == content) {
        return;
    }
    [self willChangeValueForKey:kContentKey];
    _content = [content copy];
    [self didChangeValueForKey:kContentKey];
}

@end
