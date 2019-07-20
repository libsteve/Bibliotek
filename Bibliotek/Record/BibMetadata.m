//
//  BibMetadata.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <yaz/yaz-iconv.h>

#import "BibMetadata.h"
#import "BibMetadata+Internal.h"
#import "BibLeader.h"

#pragma mark Encoding

NSString *BibEncodingDescription(BibEncoding const encoding) {
    switch (encoding) {
        case BibMARC8Encoding: return @"MARC8";
        case BibUTF8Encoding:  return @"UTF8";
        default: return [NSString stringWithFormat:@"%c", encoding];
    }
}

@implementation NSString (BibEncoding)

NSData *BibUTF8EncodedDataFromMARC8EncodedData(NSData *const data) {
    yaz_iconv_t __block marc8_to_utf8;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        marc8_to_utf8 = yaz_iconv_open("utf8", "marc8");
    });
    NSUInteger byteCount = [data length];
    NSUInteger bufferLen = byteCount * 3 / 2;
    char *const bytes = calloc(byteCount, 1);
    char *const buffer = calloc(bufferLen, 1);
    [data getBytes:bytes length:byteCount];
    char *inBuff = bytes, *outBuff = buffer;
    size_t const length = yaz_iconv(marc8_to_utf8, &inBuff, &byteCount, &outBuff, &bufferLen);
    NSData *const result = (length != -1) ? [NSData dataWithBytes:buffer length:length] : nil;
    free(bytes);
    free(buffer);
    return result;
}

+ (NSString *)bib_stringWithData:(NSData *)data
                        encoding:(BibEncoding)encoding
                           error:(out NSError *__autoreleasing *)error {
    NSString *result = nil;
    switch (encoding) {
        case BibMARC8Encoding: {
            NSData *const stringData = BibUTF8EncodedDataFromMARC8EncodedData(data);
            result = (stringData) ? [[self alloc] initWithData:stringData encoding:NSUTF8StringEncoding] : nil;
        } break;
        case BibUTF8Encoding:
            result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
            break;
        default:
            if (error) {
                NSString *const scheme = BibEncodingDescription(encoding);
                NSString *const message = [NSString stringWithFormat:@"Unknown string encoding '%@'", scheme];
                *error = [NSError errorWithDomain:BibEncodingErrorDomain code:BibEncodingUnknownEncodingError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return nil;
    }
    if (!result && error) {
        NSString *const scheme = BibEncodingDescription(encoding);
        NSString *const message = [NSString stringWithFormat:@"Cannot read malformed %@ string", scheme];
        *error = [NSError errorWithDomain:BibEncodingErrorDomain code:BibEncodingMalformedDataError
                                 userInfo:@{ NSDebugDescriptionErrorKey : message }];
    }
    return result;
}

@end

#pragma mark - Record Kind

BOOL BibRecordKindIsClassification(BibRecordKind recordKind) {
    return recordKind == BibRecordKindClassification;
}

BOOL BibRecordKindIsBibliographic(BibRecordKind recordKind) {
    static BibRecordKind const kinds[] = {
        BibRecordKindLanguageMaterial,
        BibRecordKindNotatedMusic,
        BibRecordKindManuscriptNotatedMusic,
        BibRecordKindCartographicMaterial,
        BibRecordKindManuscriptCartographicMaterial,
        BibRecordKindProjectedMedium,
        BibRecordKindNonMusicalSoundRecording,
        BibRecordKindMusicalSoundRecording,
        BibRecordKindTwoDimensionalNonProjectableGraphic,
        BibRecordKindComputerFile,
        BibRecordKindKit,
        BibRecordKindMixedMaterials,
        BibRecordKindThreeDimensionalArtifact,
        BibRecordKindManuscriptLanguageMateral
    };
    for (NSUInteger index = 0; index < sizeof(kinds); index += 1) {
        if (kinds[index] == recordKind) {
            return YES;
        }
    }
    return NO;
}

NSString *BibRecordKindDescription(BibRecordKind recordKind) {
    switch (recordKind) {
        case BibRecordKindClassification:                      return @"Classification";
        case BibRecordKindLanguageMaterial:                    return @"Language Material";
        case BibRecordKindNotatedMusic:                        return @"Notated Music";
        case BibRecordKindManuscriptNotatedMusic:              return @"Manuscript Notated Music";
        case BibRecordKindCartographicMaterial:                return @"Cartographic Material";
        case BibRecordKindManuscriptCartographicMaterial:      return @"Manuscript Cartographic Material";
        case BibRecordKindProjectedMedium:                     return @"Projected Medium";
        case BibRecordKindNonMusicalSoundRecording:            return @"NonMusical Sound Recording";
        case BibRecordKindMusicalSoundRecording:               return @"Musical Sound Recording";
        case BibRecordKindTwoDimensionalNonProjectableGraphic: return @"Two-Dimensional Non-Projectable Graphic";
        case BibRecordKindComputerFile:                        return @"Computer File";
        case BibRecordKindKit:                                 return @"Kit";
        case BibRecordKindMixedMaterials:                      return @"Mixed Materials";
        case BibRecordKindThreeDimensionalArtifact:            return @"Three-Dimensional Artifact";
        case BibRecordKindManuscriptLanguageMateral:           return @"Manuscript LanguageMateral";
        case BibRecordKindUndefined:                           return @"Undefined";
        default: return [NSString stringWithFormat:@"%c", recordKind];
    }
}

#pragma mark - Metadata

@implementation BibMetadata

@synthesize leader = _leader;

- (BibRecordKind)kind {
    return [_leader recordKind];
}

- (BibRecordStatus)status {
    return [_leader recordStatus];
}

- (instancetype)initWithLeader:(BibLeader *)leader {
    if (self = [super init]) {
        _leader = [leader mutableCopy];
    }
    return self;
}

- (instancetype)initWithKind:(BibRecordKind)kind status:(BibRecordStatus)status {
    if (self = [super init]) {
        _leader = [BibMutableLeader new];
        [_leader setRecordKind:kind];
        [_leader setRecordStatus:status];
    }
    return self;
}

- (instancetype)init {
    return [self initWithKind:BibRecordKindUndefined status:BibRecordStatusNew];
}

+ (instancetype)metadataWithKind:(BibRecordKind)kind status:(BibRecordStatus)status {
    return [[self alloc] initWithKind:kind status:status];
}

- (char)implementationDefinedValueAtIndex:(BibImplementationDefinedValueIndex)index {
    return [[self leader] implementationDefinedValueAtIndex:index];
}

@end

#pragma mark -

@implementation BibMetadata (Copying)

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BibMutableMetadata allocWithZone:zone] initWithLeader:[self leader]];
}

@end

@implementation BibMetadata (Equality)

static BibImplementationDefinedValueIndex const kAllValueIndices[] = {
    BibImplementationDefinedValueIndex07,
    BibImplementationDefinedValueIndex08,
    BibImplementationDefinedValueIndex17,
    BibImplementationDefinedValueIndex18,
    BibImplementationDefinedValueIndex19
};

- (BOOL)isEqualToMetadata:(BibMetadata *)metadata {
    if ([self kind] != [metadata kind] || [self status] != [metadata status]) {
        return NO;
    }
    int const indexCount = sizeof(kAllValueIndices) / sizeof(BibImplementationDefinedValueIndex);
    for (int index = 0; index < indexCount; index += 1) {
        char const myValue = [self implementationDefinedValueAtIndex:index];
        char const theirValue = [metadata implementationDefinedValueAtIndex:index];
        if (myValue != theirValue) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    return self == object
        || ([object isKindOfClass:[BibMetadata class]] && [self isEqualToMetadata:object]);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    int const indexCount = sizeof(kAllValueIndices) / sizeof(BibImplementationDefinedValueIndex);
    for (int index = 0; index < indexCount; index += 1) {
        hash |= [self implementationDefinedValueAtIndex:kAllValueIndices[index]] << (index % 4 * 8);
    }
    return hash ^ ([self kind] | ([self status] << 16));
}

@end

#pragma mark -

@implementation BibMutableMetadata

- (id)copyWithZone:(NSZone *)zone {
    return [[BibMetadata allocWithZone:zone] initWithLeader:[self leader]];
}

@dynamic kind;
- (void)setKind:(BibRecordKind)kind {
    NSString *const key = NSStringFromSelector(@selector(kind));
    [self willChangeValueForKey:key];
    [[self leader] setRecordKind:kind];
    [self didChangeValueForKey:key];
}

@dynamic status;
- (void)setStatus:(BibRecordStatus)status {
    NSString *const key = NSStringFromSelector(@selector(status));
    [self willChangeValueForKey:key];
    [[self leader] setRecordStatus:status];
    [self didChangeValueForKey:key];
}

- (void)setImplementationDefinedValue:(char)value atIndex:(BibImplementationDefinedValueIndex)index {
    [[self leader] setImplementationDefinedValue:value atIndex:index];
}

@end
