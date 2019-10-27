//
//  BibISBN.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/29/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibISBN.h"
#import "BibContentField.h"

@implementation BibISBN

@synthesize stringValue = _stringValue;
@synthesize kind = _kind;

- (instancetype)initWithStringValue:(NSString *)stringValue {
    if (self = [super init]) {
        _stringValue = [stringValue copy];
        switch ([stringValue length]) {
            case 10:
                _kind = BibISBNKindISBN10;
                break;
            case 13:
                _kind = BibISBNKindISBN13;
                break;
            default:
                return nil;
        }
    }
    return self;
}

+ (instancetype)isbnWithStringValue:(NSString *)stringValue {
    return [[self alloc] initWithStringValue:stringValue];
}

- (instancetype)initWithContentField:(BibContentField *)contentField {
    return [self initWithStringValue:[[contentField firstSubfieldWithCode:@"a"] content]];
}

- (instancetype)init {
    return nil;
}

+ (instancetype)new {
    return nil;
}

- (NSString *)description {
    return [self stringValue];
}

@end

@implementation BibISBN (Equality)

- (BOOL)isEqualToISBN:(BibISBN *)isbn {
    return self == isbn || [self stringValue] == [isbn stringValue];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibISBN class]] && [self isEqualToISBN:object]);
}

- (NSUInteger)hash {
    return [[self stringValue] hash];
}

@end
