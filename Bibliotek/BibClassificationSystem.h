//
//  BibClassificationSystem.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibConstants.h"

@class BibCallNumber;
@class BibMarcRecordField;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ClassificationSystem)
@interface BibClassificationSystem : NSObject <NSSecureCoding>

@property(nonatomic, readonly, copy) NSString *acronym;

@property(nonatomic, readonly, copy) BibMarcRecordFieldTag fieldTag;

@property(nonatomic, readonly, class) BibClassificationSystem *lcc;

@property(nonatomic, readonly, class) BibClassificationSystem *ddc;

- (instancetype)initWithAcronym:(NSString *)acronym
                    description:(NSString *)description
                       fieldTag:(BibMarcRecordFieldTag)fieldTag NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToSystem:(BibClassificationSystem *)system;

@end

NS_ASSUME_NONNULL_END
