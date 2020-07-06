//
//  BibFieldPath.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/10/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibSubfield.h>

@class BibFieldTag;

NS_ASSUME_NONNULL_BEGIN

@interface BibFieldPath : NSObject <NSCopying>

@property (nonatomic, readonly, copy) BibFieldTag *fieldTag;
@property (nonatomic, readonly, copy, nullable) BibSubfieldCode subfieldCode;

@property (nonatomic, readonly) BOOL isControlFieldPath;
@property (nonatomic, readonly) BOOL isContentFieldPath DEPRECATED_MSG_ATTRIBUTE("Use -isDataFieldPath");
@property (nonatomic, readonly) BOOL isDataFieldPath;
@property (nonatomic, readonly) BOOL isSubfieldPath;

- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode
    NS_DESIGNATED_INITIALIZER;

@end

@interface BibFieldPath (Convenience)

- (instancetype)initWithFieldTagString:(NSString *)fieldTagString NS_SWIFT_UNAVAILABLE("Use init(fieldTag:)");
- (instancetype)initWithFieldTagString:(NSString *)fieldTagString subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_UNAVAILABLE("Use init(fieldTag:subfieldCode:)");

+ (instancetype)fieldPathWithFieldTag:(BibFieldTag *)fieldTag NS_SWIFT_UNAVAILABLE("Use init(fieldTag:)");
+ (instancetype)fieldPathWithFieldTag:(BibFieldTag *)fieldTag subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_UNAVAILABLE("Use init(fieldTag:subfieldCode:)");

+ (instancetype)fieldPathWithFieldTagString:(NSString *)fieldTagString NS_SWIFT_UNAVAILABLE("Use init(fieldTag:)");
+ (instancetype)fieldPathWithFieldTagString:(NSString *)fieldTagString subfieldCode:(BibSubfieldCode)subfieldCode
    NS_SWIFT_UNAVAILABLE("Use init(fieldTag:subfieldCode:)");

@end

@interface BibFieldPath (Equality)

- (BOOL)isEqualToFieldPath:(BibFieldPath *)fieldPath;

@end

NS_ASSUME_NONNULL_END
