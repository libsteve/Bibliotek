//
//  BibClassificationRecordMetadata.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibClassificationRecord.h"
#import "BibClassificationRecordMetadata.h"

static NSUInteger const kContentLength        =  14;
static NSRange    const kCreationDateRange    = { 0, 6};
static NSUInteger const kRecordKindIndex      =   6;
static NSUInteger const kNumberKindIndex      =   7;
static NSUInteger const kValidityIndex        =   8;
static NSUInteger const kStandardizationIndex =  11;

static NSDateFormatter *sDateFormatter = nil;

@implementation BibClassificationRecordMetadata

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDateFormatter = [NSDateFormatter new];
        [sDateFormatter setDateFormat:@"yyMMdd"];
        [sDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [sDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
}

+ (BibRecordFieldTag)recordFieldTag {
    return BibRecordFieldTagClassificationRecordMetadata;
}

- (instancetype)initWithTag:(BibRecordFieldTag)tag content:(NSString *)content {
    if (![tag isEqualToString:[[self class] recordFieldTag]]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"%@ must have tag %@", NSStringFromClass([self class]), [[self class] recordFieldTag]];
    }
    return [self initWithContent:content];
}

- (instancetype)initWithContent:(NSString *)content {
    if ([content length] != kContentLength) {
        unsigned long const length = kContentLength;
        [NSException raise:NSRangeException
                    format:@"Classification record's metadata must be exactly %lu characters long", length];
        return nil;
    }
    if (self = [super initWithTag:[[self class] recordFieldTag] content:content]) {
        _creationDate = [sDateFormatter dateFromString:[content substringWithRange:kCreationDateRange]];
        if (_creationDate == nil) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Classification record's creation data must be formatted yyMMdd"];
            return nil;
        }
        _recordKind = [content characterAtIndex:kRecordKindIndex];
        _classificationNumberKind = [content characterAtIndex:kNumberKindIndex];
        _recordValidity = [content characterAtIndex:kValidityIndex];
        _standardization = [content characterAtIndex:kStandardizationIndex];
    }
    return self;
}

@end
