//
//  BibField.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/12/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibField.h"
#import "BibFieldTag.h"

@implementation BibFieldEnumerator {
    NSEnumerator<id<BibField>> *_enumerator;
}

- (instancetype)initWithEnumerator:(NSEnumerator<id<BibField>> *)enumerator {
    if (self = [super init]) {
        _enumerator = enumerator;
    }
    return self;
}

- (instancetype)init {
    return [self initWithEnumerator:[NSEnumerator new]];
}

- (id)nextObject {
    return [_enumerator nextObject];
}

- (id<BibField>)nextField {
    return [self nextObject];
}

- (id<BibField>)nextFieldWithTag:(BibFieldTag *)fieldTag {
    for (id<BibField> field = [self nextField]; field != nil; field = [self nextField]) {
        if ([[field tag] isEqualToTag:fieldTag]) {
            return field;
        }
    }
    return nil;
}

@end
