//
//  BibMarcRecordDataField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecordDataField.h"
#import "BibMarcRecordError.h"
#import "BibMarcRecordFieldIndicator.h"
#import "BibMarcRecordFieldTag.h"
#import "BibMarcRecordSubfield.h"

#define guard(predicate) if(!((predicate)))

@implementation BibMarcRecordDataField {
@protected
    BibMarcRecordFieldTag *_tag;
    BibMarcRecordFieldIndicator *_firstIndicator;
    BibMarcRecordFieldIndicator *_secondIndicator;
    NSArray<BibMarcRecordSubfield *> *_subfields;
}

@synthesize tag = _tag;
@synthesize firstIndicator = _firstIndicator;
@synthesize secondIndicator = _secondIndicator;
@synthesize subfields = _subfields;

- (instancetype)init {
    return [self initWithTag:[BibMarcRecordFieldTag tagWithString:@"100"]
              firstIndicator:[BibMarcRecordFieldIndicator new]
             secondIndicator:[BibMarcRecordFieldIndicator new]
                   subfields:[NSArray array] error:NULL];
}

- (instancetype)initWithTag:(BibMarcRecordFieldTag *)tag
             firstIndicator:(BibMarcRecordFieldIndicator *)firstIndicator
            secondIndicator:(BibMarcRecordFieldIndicator *)secondIndicator
                  subfields:(NSArray<BibMarcRecordSubfield *> *)subfields
                      error:(NSError *__autoreleasing *)error {
    guard([subfields count] >= 1) {
        guard (error != NULL) { return nil; }
        NSString *const description = @"Invalid data field";
        NSString *const reason = @"Data fields must contain at least one subfield.";
        *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                     code:BibMarcRecordErrorMissingSubfield
                                 userInfo:@{ NSLocalizedDescriptionKey : description,
                                             NSLocalizedFailureReasonErrorKey : reason }];
        return nil;
    }
    if ([tag isControlFieldTag]) {
        guard (error != NULL) { return nil; }
        NSString *const description = [NSString stringWithFormat:@"Invalid data field with tag %@", tag];
        NSString *const reason = @"Data fields cannot have control field tags.";
        *error = [NSError errorWithDomain:BibMarcRecordErrorDomain
                                     code:BibMarcRecordErrorInvalidFieldTag
                                 userInfo:@{ NSLocalizedDescriptionKey : description,
                                             NSLocalizedFailureReasonErrorKey : reason }];
        return nil;
    }
    if (self = [super init]) {
        _tag = tag;
        _firstIndicator = firstIndicator;
        _secondIndicator = secondIndicator;
        _subfields = [[NSArray alloc] initWithArray:subfields copyItems:YES];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    if (zone == nil && [[self class] isEqualTo:[BibMarcRecordSubfield class]]) {
        return self;
    }
    return [[BibMarcRecordDataField allocWithZone:zone] initWithTag:_tag
                                                     firstIndicator:_firstIndicator
                                                    secondIndicator:_secondIndicator
                                                          subfields:_subfields
                                                              error:NULL];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMarcRecordMutableDataField allocWithZone:zone] initWithTag:_tag
                                                            firstIndicator:_firstIndicator
                                                           secondIndicator:_secondIndicator
                                                                 subfields:_subfields
                                                                     error:NULL];
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSError *error = nil;
    self = [self initWithTag:[aDecoder decodeObjectForKey:@"tag"]
              firstIndicator:[aDecoder decodeObjectForKey:@"ind1"]
             secondIndicator:[aDecoder decodeObjectForKey:@"ind2"]
                   subfields:[aDecoder decodeObjectForKey:@"subfields"]
                       error:&error];
    guard(error == nil) {
        NSString *const description = error.localizedDescription;
        NSString *const reason = error.localizedFailureReason;
        [[[NSException alloc] initWithName:error.domain
                                    reason:[NSString stringWithFormat:@"%@: %@", description, reason]
                                  userInfo:error.userInfo] raise];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:@"tag"];
    [aCoder encodeObject:_firstIndicator forKey:@"ind1"];
    [aCoder encodeObject:_secondIndicator forKey:@"ind2"];
    [aCoder encodeObject:_subfields forKey:@"subfields"];
}

+ (BOOL)supportsSecureCoding { return YES; }

#pragma mark - Equality

- (BOOL)isEqualToDataField:(BibMarcRecordDataField *)other {
    return [_tag isEqualToTag:[other tag]]
        && [_firstIndicator isEqualToIndicator:[other firstIndicator]]
        && [_secondIndicator isEqualToIndicator:[other secondIndicator]]
        && [_subfields isEqualToArray:[other subfields]];
}

- (BOOL)isEqual:(id)other {
    return [super isEqual:other]
        || ([other isKindOfClass:[BibMarcRecordDataField class]] && [self isEqualToDataField:other]);
}

- (NSUInteger)hash {
    return [_tag hash] ^ [_firstIndicator hash] ^ [_secondIndicator hash] ^ [_subfields hash];
}

@end

#pragma mark -

@implementation BibMarcRecordMutableDataField

@dynamic tag;
+ (BOOL)automaticallyNotifiesObserversOfTag { return NO; }
- (void)setTag:(BibMarcRecordFieldTag *)tag {
    if (_tag == tag) {
        return;
    }
    [self willChangeValueForKey:@"tag"];
    _tag = tag;
    [self didChangeValueForKey:@"tag"];
}

@dynamic firstIndicator;
+ (BOOL)automaticallyNotifiesObserversOfFirstIndicator { return NO; }
- (void)setFirstIndicator:(BibMarcRecordFieldIndicator *)firstIndicator {
    if (_firstIndicator == firstIndicator) {
        return;
    }
    [self willChangeValueForKey:@"firstIndicator"];
    _firstIndicator = firstIndicator;
    [self didChangeValueForKey:@"firstIndicator"];
}

@dynamic secondIndicator;
+ (BOOL)automaticallyNotifiesObserversOfSecondIndicator { return NO; }
- (void)setSecondIndicator:(BibMarcRecordFieldIndicator *)secondIndicator {
    if (_secondIndicator == secondIndicator) {
        return;
    }
    [self willChangeValueForKey:@"secondIndicator"];
    _secondIndicator = secondIndicator;
    [self didChangeValueForKey:@"secondIndicator"];
}

@dynamic subfields;
+ (BOOL)automaticallyNotifiesObserversOfSubfields { return NO; }
- (void)setSubfields:(NSArray<BibMarcRecordSubfield *> *)subfields {
    if (_subfields == subfields) {
        return;
    }
    [self willChangeValueForKey:@"subfields"];
    _subfields = [[NSArray alloc] initWithArray:subfields copyItems:YES];
    [self didChangeValueForKey:@"subfields"];
}

@end
