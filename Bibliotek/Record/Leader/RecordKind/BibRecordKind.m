//
//  BibRecordKind.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibRecordKind.h"
#import "BibStaticClassRef.h"
#import "Bibliotek+Internal.h"

/// An underlying backing type for immutable singleton instances of ``BibRecordKind`` for each value.
///
/// An instance for each of the 128 possible ASCII values is allocated at load time.
/// When ``BibRecordKind/initWithRawValue:`` is called, one of those pre-allocated instances is returned.
@interface _BibRecordKind : BibRecordKind
DECLARE_STATIC_CLASS_REF(_BibRecordKind);
DECLARE_STATIC_CLASS_STRUCT(_BibRecordKind);
@end

@interface _BibBibliographicRecordKind : BibBibliographicRecordKind
DECLARE_STATIC_CLASS_REF(_BibBibliographicRecordKind);
DECLARE_STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, uint8_t byteValue;);
@end

@interface _BibAuthorityRecordKind : BibAuthorityRecordKind
DECLARE_STATIC_CLASS_REF(_BibAuthorityRecordKind);
DECLARE_STATIC_CLASS_STRUCT(_BibAuthorityRecordKind, uint8_t byteValue;);
@end

@interface _BibHoldingsRecordKind : BibHoldingsRecordKind
DECLARE_STATIC_CLASS_REF(_BibHoldingsRecordKind);
DECLARE_STATIC_CLASS_STRUCT(_BibHoldingsRecordKind, uint8_t byteValue;);
@end

@interface _BibClassificationRecordKind : BibClassificationRecordKind
DECLARE_STATIC_CLASS_REF(_BibClassificationRecordKind);
DECLARE_STATIC_CLASS_STRUCT(_BibClassificationRecordKind, uint8_t byteValue;);
@end

@interface _BibCommunityRecordKind : BibCommunityRecordKind
DECLARE_STATIC_CLASS_REF(_BibCommunityRecordKind);
DECLARE_STATIC_CLASS_STRUCT(_BibCommunityRecordKind, uint8_t byteValue;);
@end

#pragma mark -


@implementation BibRecordKind

- (uint8_t)byteValue {
    BibUnimplementedPropertyFrom(BibRecordKind);
}

- (BibRecordFormat)recordFormat {
    BibUnimplementedPropertyFrom(BibRecordKind);
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibRecordKind class]) {
        static struct _BibRecordKind const placeholder = STATIC_CLASS_STRUCT(_BibRecordKind);
        return (__bridge id)&placeholder;
    }
    return [super allocWithZone:zone];
}

- (instancetype)initWithByte:(char)byteValue {
    Method original = class_getInstanceMethod([BibRecordKind class], @selector(initWithByte:));
    Method current = class_getInstanceMethod([self class], @selector(initWithByte:));
    if (original == current) {
        BibUnimplementedInitializerFrom(BibRecordKind);
    }
    if (byteValue < 0x20 || byteValue > 0x7E) {
        return nil;
//        [NSException raise:NSRangeException
//                    format:@"*** A record kind's raw value must be a graphic ASCII character."];
    }
    return [super init];
}

+ (instancetype)recordKindWithByte:(char)byteValue {
    return [[self alloc] initWithByte:byteValue];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BibRecordKind allocWithZone:zone] initWithByte:[self byteValue]];
}

- (NSString *)description {
    NSBundle *bundle = [NSBundle bundleForClass:[BibRecordKind class]];
    NSString *value = [NSString stringWithFormat:@"%c", [self byteValue]];
    NSString *key = [NSString stringWithFormat:@"kind:%c", [self byteValue]];
    return [bundle localizedStringForKey:key value:value table:@"RecordKind"];
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)new {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end

#pragma mark - Equality

@implementation BibRecordKind (Equality)

- (BOOL)isEqualToRecordKind:(BibRecordKind *)recordKind {
    return self == recordKind || [self byteValue] == [recordKind byteValue];
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibRecordKind class]] && [self isEqualToRecordKind:object]);
}

- (NSUInteger)hash {
    return [self byteValue];
}

@end

#pragma mark - MARC 21 Categories

@implementation BibRecordKind (MARC21Categories)

- (BOOL)isClassificationKind {
    return [self recordFormat] == BibRecordFormatClassification;
}

- (BOOL)isBibliographicKind {
    return [self recordFormat] == BibRecordFormatBibliographic;
}

@end

#pragma mark - MARC 21 Record Kinds

@implementation BibRecordKind (MARC21RecordKinds)

+ (BibBibliographicRecordKind *)languageMaterial {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'a');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)notatedMusic {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'c');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)manuscriptNotatedMusic {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'd');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)cartographicMaterial {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'e');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)manuscriptCartographicMaterial {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'f');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)projectedMedium {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'g');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)nonMusicalSoundRecording {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'i');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)musicalSoundRecording {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'j');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)twoDimensionalNonProjectableGraphic {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'k');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)computerFile {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'm');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)kit {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'o');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)mixedMaterials {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'p');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibCommunityRecordKind *)communityInformation {
    static struct _BibCommunityRecordKind kind = STATIC_CLASS_STRUCT(_BibCommunityRecordKind, 'q');
    return (__bridge BibCommunityRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)threeDimensionalArtifact {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 'r');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibBibliographicRecordKind *)manuscriptLanguageMaterial {
    static struct _BibBibliographicRecordKind kind = STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 't');
    return (__bridge BibBibliographicRecordKind *)&kind;
}
+ (BibHoldingsRecordKind *)unknownHoldings {
    static struct _BibHoldingsRecordKind kind = STATIC_CLASS_STRUCT(_BibHoldingsRecordKind, 'u');
    return (__bridge BibHoldingsRecordKind *)&kind;
}
+ (BibHoldingsRecordKind *)multipartItemHoldings {
    static struct _BibHoldingsRecordKind kind = STATIC_CLASS_STRUCT(_BibHoldingsRecordKind, 'v');
    return (__bridge BibHoldingsRecordKind *)&kind;
}
+ (BibClassificationRecordKind *)classification {
    static struct _BibClassificationRecordKind kind = STATIC_CLASS_STRUCT(_BibClassificationRecordKind, 'w');
    return (__bridge BibClassificationRecordKind *)&kind;
}
+ (BibHoldingsRecordKind *)singlePartItemHoldings {
    static struct _BibHoldingsRecordKind kind = STATIC_CLASS_STRUCT(_BibHoldingsRecordKind, 'x');
    return (__bridge BibHoldingsRecordKind *)&kind;
}
+ (BibHoldingsRecordKind *)serialItemHoldings {
    static struct _BibHoldingsRecordKind kind = STATIC_CLASS_STRUCT(_BibHoldingsRecordKind, 'y');
    return (__bridge BibHoldingsRecordKind *)&kind;
}
+ (BibAuthorityRecordKind *)authorityData {
    static struct _BibAuthorityRecordKind kind = STATIC_CLASS_STRUCT(_BibAuthorityRecordKind, 'z');
    return (__bridge BibAuthorityRecordKind *)&kind;
}

@end

@implementation _BibRecordKind

+ (void)load {
    static_class_apply_overrides(self);
}

- (instancetype)initWithByte:(char)byteValue {
    switch (byteValue) {
        case 'a': return (id)[BibRecordKind languageMaterial];
        case 'c': return (id)[BibRecordKind notatedMusic];
        case 'd': return (id)[BibRecordKind manuscriptNotatedMusic];
        case 'e': return (id)[BibRecordKind cartographicMaterial];
        case 'f': return (id)[BibRecordKind manuscriptCartographicMaterial];
        case 'g': return (id)[BibRecordKind projectedMedium];
        case 'i': return (id)[BibRecordKind nonMusicalSoundRecording];
        case 'j': return (id)[BibRecordKind musicalSoundRecording];
        case 'k': return (id)[BibRecordKind twoDimensionalNonProjectableGraphic];
        case 'm': return (id)[BibRecordKind computerFile];
        case 'o': return (id)[BibRecordKind kit];
        case 'p': return (id)[BibRecordKind mixedMaterials];
        case 'q': return (id)[BibRecordKind communityInformation];
        case 'r': return (id)[BibRecordKind threeDimensionalArtifact];
        case 't': return (id)[BibRecordKind manuscriptLanguageMaterial];
        case 'u': return (id)[BibRecordKind unknownHoldings];
        case 'v': return (id)[BibRecordKind multipartItemHoldings];
        case 'w': return (id)[BibRecordKind classification];
        case 'x': return (id)[BibRecordKind singlePartItemHoldings];
        case 'y': return (id)[BibRecordKind serialItemHoldings];
        case 'z': return (id)[BibRecordKind authorityData];
        default: return nil;
    }
}

@end

#pragma mark - Bibliographic

@implementation BibBibliographicRecordKind

- (BibRecordFormat)recordFormat {
    return BibRecordFormatBibliographic;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibBibliographicRecordKind class]) {
        static struct _BibBibliographicRecordKind placeholder =
            STATIC_CLASS_STRUCT(_BibBibliographicRecordKind, 0x00);
        return (__bridge BibBibliographicRecordKind *)&placeholder;
    }
    return [super allocWithZone:zone];
}

@end

@implementation _BibBibliographicRecordKind

+ (void)load {
    static_class_apply_overrides(self);
}

- (uint8_t)byteValue {
    return ((__bridge struct _BibBibliographicRecordKind *)self)->byteValue;
}

- (instancetype)initWithByte:(char)byteValue {
    switch (byteValue) {
    case 'a': return (id)[BibRecordKind languageMaterial];
    case 'c': return (id)[BibRecordKind notatedMusic];
    case 'd': return (id)[BibRecordKind manuscriptNotatedMusic];
    case 'e': return (id)[BibRecordKind cartographicMaterial];
    case 'f': return (id)[BibRecordKind manuscriptCartographicMaterial];
    case 'g': return (id)[BibRecordKind projectedMedium];
    case 'i': return (id)[BibRecordKind nonMusicalSoundRecording];
    case 'j': return (id)[BibRecordKind musicalSoundRecording];
    case 'k': return (id)[BibRecordKind twoDimensionalNonProjectableGraphic];
    case 'm': return (id)[BibRecordKind computerFile];
    case 'o': return (id)[BibRecordKind kit];
    case 'p': return (id)[BibRecordKind mixedMaterials];
    case 'r': return (id)[BibRecordKind threeDimensionalArtifact];
    case 't': return (id)[BibRecordKind manuscriptLanguageMaterial];
    default: return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

#pragma mark - Authority

@implementation BibAuthorityRecordKind

- (BibRecordFormat)recordFormat {
    return BibRecordFormatAuthority;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibAuthorityRecordKind class]) {
        static struct _BibAuthorityRecordKind placeholder =
            STATIC_CLASS_STRUCT(_BibAuthorityRecordKind, 0x00);
        return (__bridge BibAuthorityRecordKind *)&placeholder;
    }
    return [super allocWithZone:zone];
}

@end

@implementation _BibAuthorityRecordKind

+ (void)load {
    static_class_apply_overrides(self);
}

- (uint8_t)byteValue {
    return ((__bridge struct _BibAuthorityRecordKind *)self)->byteValue;
}

- (instancetype)initWithByte:(uint8_t)byteValue {
    switch (byteValue) {
    case 'z': return (id)[BibAuthorityRecordKind authorityData];
    default: return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

#pragma mark - Holdings

@implementation BibHoldingsRecordKind

- (BibRecordFormat)recordFormat {
    return BibRecordFormatHoldings;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibHoldingsRecordKind class]) {
        static struct _BibHoldingsRecordKind placeholder =
            STATIC_CLASS_STRUCT(_BibHoldingsRecordKind, 0x00);
        return (__bridge BibHoldingsRecordKind *)&placeholder;
    }
    return [super allocWithZone:zone];
}

@end

@implementation _BibHoldingsRecordKind

+ (void)load {
    static_class_apply_overrides(self);
}

- (uint8_t)byteValue {
    return ((__bridge struct _BibHoldingsRecordKind *)self)->byteValue;
}

- (instancetype)initWithByte:(char)byteValue {
    switch (byteValue) {
    case 'u': return (id)[BibRecordKind unknownHoldings];
    case 'v': return (id)[BibRecordKind multipartItemHoldings];
    case 'x': return (id)[BibRecordKind singlePartItemHoldings];
    case 'y': return (id)[BibRecordKind serialItemHoldings];
    default: return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

#pragma mark - Classification

@implementation BibClassificationRecordKind

- (BibRecordFormat)recordFormat {
    return BibRecordFormatClassification;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibClassificationRecordKind class]) {
        static struct _BibClassificationRecordKind placeholder =
            STATIC_CLASS_STRUCT(_BibClassificationRecordKind, 0x00);
        return (__bridge BibClassificationRecordKind *)&placeholder;
    }
    return [super allocWithZone:zone];
}

@end

@implementation _BibClassificationRecordKind

+ (void)load {
    static_class_apply_overrides(self);
}

- (uint8_t)byteValue {
    return ((__bridge struct _BibClassificationRecordKind *)self)->byteValue;
}

- (instancetype)initWithByte:(uint8_t)byteValue {
    switch (byteValue) {
    case 'w': return (id)[BibRecordKind classification];
    default: return nil;
    }
}

- (instancetype)init {
    return (id)[BibRecordKind classification];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

#pragma mark - Community

@implementation BibCommunityRecordKind

- (BibRecordFormat)recordFormat {
    return BibRecordFormatCommunity;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (self == [BibCommunityRecordKind class]) {
        static struct _BibCommunityRecordKind placeholder =
            STATIC_CLASS_STRUCT(_BibCommunityRecordKind, 0x00);
        return (__bridge BibCommunityRecordKind *)&placeholder;
    }
    return [super allocWithZone:zone];
}

@end

@implementation _BibCommunityRecordKind

+ (void)load {
    static_class_apply_overrides(self);
}

- (uint8_t)byteValue {
    return ((__bridge struct _BibCommunityRecordKind *)self)->byteValue;
}

- (instancetype)initWithByte:(uint8_t)byteValue {
    switch (byteValue) {
    case 'q': return (id)[BibRecordKind communityInformation];
    default: return nil;
    }
}

- (instancetype)init {
    return (id)[BibRecordKind communityInformation];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
