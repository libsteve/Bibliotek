//
//  BibMarcRecordControlField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordControlField.h"
#import "BibMarcRecordError.h"
#import "BibMarcRecordFieldTag.h"
#import "NSCharacterSet+BibASCIICharacterSet.h"
#import "NSString+BibCharacterSetValidation.h"
#import <os/log.h>

#define guard(predicate) if(!((predicate)))

NSErrorDomain const BibMarcRecordControlFieldInvalidTagException = @"BibMarcRecordControlFieldInvalidTagException";

static NSString *const kTagKey = @"tag";
static NSString *const kContentKey = @"content";

static BOOL sIsValidTag(NSString *tag);

@implementation BibMarcRecordControlField {
@protected
    BibMarcRecordFieldTag *_tag;
    NSString *_content;
}

@synthesize tag = _tag;
@synthesize content = _content;

- (instancetype)init {
    return [self initWithTag:[BibMarcRecordFieldTag new] content:@"" error:NULL];
}

- (instancetype)initWithTag:(BibMarcRecordFieldTag *)tag
                    content:(NSString *)content
                      error:(NSError *__autoreleasing *)error {
    guard([BibMarcRecordControlField isValidControlFieldTag:tag error:error]) {
        return nil;
    }
    if (self = [super init]) {
        _tag = [tag copy];
        _content = [_content copy];
    }
    return self;
}

+ (instancetype)controlFieldWithTag:(BibMarcRecordFieldTag *)tag
                            content:(NSString *)content
                              error:(NSError *__autoreleasing *)error {
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
    NSError *error = nil;
    self = [self initWithTag:[aDecoder decodeObjectForKey:kTagKey]
                     content:[aDecoder decodeObjectForKey:kContentKey]
                       error:&error];
    guard(error == nil) {
        NSString *const description = error.localizedDescription;
        NSString *const reason = error.localizedFailureReason;
        [[NSException exceptionWithName:BibMarcRecordControlFieldInvalidTagException
                                 reason:[NSString stringWithFormat:@"%@: %@", description, reason]
                               userInfo:error.userInfo] raise];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:kTagKey];
    [aCoder encodeObject:_content forKey:kContentKey];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Equality

- (BOOL)isEqualToControlField:(BibMarcRecordControlField *)other {
    return [_tag isEqualToTag:[other tag]]
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

+ (BOOL)isValidControlFieldTag:(BibMarcRecordFieldTag *)tag error:(NSError *__autoreleasing *)error {
    guard([tag isControlFieldTag]) {
        guard(error != NULL) { return NO; }
        NSString *const description = [NSString stringWithFormat:@"Invalid control field tag \"%@\"", tag];
        NSString *const reason = @"MARC 21 control field tags must begin with two zeros.";
        *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                     code:BibMarcRecordErrorInvalidFieldTag
                                 userInfo:@{ NSLocalizedDescriptionKey : description,
                                             NSLocalizedFailureReasonErrorKey : reason }];
        return NO;
    }
    return YES;
}

@end

#pragma mark -

@implementation BibMarcRecordMutableControlField

@dynamic tag;
+ (BOOL)automaticallyNotifiesObserversOfTag { return NO; }
- (void)setTag:(BibMarcRecordFieldTag *)tag {
    if (_tag == tag) {
        return;
    }
    NSError *error = nil;
    guard([BibMarcRecordControlField isValidControlFieldTag:tag error:&error]) {
        NSString *const description = error.localizedDescription;
        NSString *const reason = error.localizedFailureReason;
        [[NSException exceptionWithName:BibMarcRecordControlFieldInvalidTagException
                                 reason:[NSString stringWithFormat:@"%@: %@", description, reason]
                               userInfo:error.userInfo] raise];
        return;
    }
    [self willChangeValueForKey:kTagKey];
    _tag = tag;
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
