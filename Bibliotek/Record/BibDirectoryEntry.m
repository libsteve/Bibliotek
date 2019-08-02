//
//  BibFieldEntry.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDirectoryEntry.h"
#import "BibFieldTag.h"

@implementation BibDirectoryEntry

@synthesize tag = _tag;
@synthesize range = _range;

- (instancetype)initWithTag:(BibFieldTag *)tag range:(NSRange)range {
    if (self = [super init]) {
        _tag = tag;
        _range = range;
    }
    return self;
}

- (instancetype)init {
    return [self initWithTag:[[BibFieldTag alloc] init] range:NSMakeRange(NSNotFound, 0)];
}

+ (instancetype)entryWithTag:(BibFieldTag *)tag range:(NSRange)range {
    return [[BibDirectoryEntry alloc] initWithTag:tag range:range];
}

@end

#pragma mark - Equality

@implementation BibDirectoryEntry (Equality)

- (BOOL)isEqualToEntry:(BibDirectoryEntry *)entry {
    return [[self tag] isEqualToTag:[entry tag]] && NSEqualRanges([self range], [entry range]);
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibDirectoryEntry class]] && [self isEqualToEntry:object]);
}

- (NSUInteger)hash {
    NSRange const range = [self range];
    return [[self tag] hash] ^ range.location ^ range.length;
}

@end
