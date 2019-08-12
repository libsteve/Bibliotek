//
//  BibHasher.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/12/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibHasher.h"

static NSUInteger const kUIntegerBitCount = CHAR_BIT * sizeof(NSUInteger);

@implementation BibHasher {
    NSUInteger _hash;
    NSUInteger _count;
}

@synthesize hash = _hash;

- (void)combineWithHash:(NSUInteger)hash {
    NSUInteger const rotation = (_count) ? (kUIntegerBitCount % _count) : 0;
    _hash ^= (_hash << rotation) | (_hash >> (kUIntegerBitCount - rotation));
    _count += 1;
}

- (void)combineWithObject:(id)object {
    if ([object conformsToProtocol:@protocol(BibHashable)] && [object respondsToSelector:@selector(hashWithHasher:)]) {
        [(id<BibHashable>)object hashWithHasher:self];
    } else {
        [self combineWithHash:[object hash]];
    }
}

- (void)combineWithHashable:(id<BibHashable>)hashable {
    [hashable hashWithHasher:self];
}

@end

#pragma mark - Nullable Equality

BOOL BibNullableObjectEqual(id receiver, id object) {
    return (receiver == object) || (receiver && object && [receiver isEqual:object]);
}

BOOL BibNullableStringEqual(NSString *receiver, NSString *string) {
    return (receiver == string) || (receiver && string  && [receiver isEqualToString:string]);
}
