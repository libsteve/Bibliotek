//
//  BibLibraryOfCongressCallNumber.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibCallNumber.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LibraryOfCongressCallNumber)
@interface BibLibraryOfCongressCallNumber : NSObject <BibCallNumber>

@property(nonatomic, readonly, copy) NSString *subjectArea;

@property(nonatomic, readonly, copy) NSString *topic;

@property(nonatomic, readonly, copy) NSArray<NSString *> *cutters;

@property(nonatomic, readonly, copy) NSString *date;

@property(nonatomic, readonly, copy, nullable) NSString *work;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
