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
    return [self initWithTag:@"000" content:@""];
}

- (instancetype)initWithTag:(NSString *)tag content:(NSString *)content {
    guard([BibMarcRecordControlField isValidControlFieldTag:tag]) {
        return nil;
    }
    if (self = [super init]) {
        _tag = [tag copy];
        _content = [_content copy];
    }
    return self;
}

+ (instancetype)controlFieldWithTag:(NSString *)tag content:(NSString *)content {
    return [[self alloc] initWithTag:tag content:content];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMarcRecordControlField allocWithZone:zone] initWithTag:_tag content:_content];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableControlField allocWithZone:zone] initWithTag:_tag content:_content];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTag:[aDecoder decodeObjectForKey:kTagKey] content:[aDecoder decodeObjectForKey:kContentKey]];
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

+ (BOOL)isValidControlFieldTag:(NSString *)tag {
    static os_log_t log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = os_log_create("brun.steve.Bibliotek.BibMarcRecord", "ControlField");
    });
    guard([tag bib_isRestrictedToCharacterSet:[NSCharacterSet bib_ASCIINumericCharacterSet]
                                      inRange:NSRangeFromString(tag)]) {
        os_log_debug(log, "Invalid control field tag \"%{public}@\"", tag);
        os_log_info(log, "Field tags must be a sequence of ASCII numerals");
        return NO;
    }
    guard([[tag substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"00"]) {
        os_log_debug(log, "Invalid control field tag \"%{public}@\"", tag);
        os_log_info(log, "Control field tags must begin with 00");
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
    guard([BibMarcRecordControlField isValidControlFieldTag:tag]) {
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
