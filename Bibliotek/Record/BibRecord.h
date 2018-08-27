//
//  BibRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibRecord+Protocols.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A collection of information pertaining to some physical entity represented in the database.
@interface BibRecord : NSObject <BibRecord>

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title fromDatabase:(NSString *)database NS_SWIFT_NAME(init(title:database:));

- (instancetype)initWithRecordStore:(id<BibRecord>)recordStore;

@end

/// A mutable collection of information pertaining to some physical entity represented in the database.
@interface BibMutableRecord : BibRecord <BibMutableRecord>

@end

NS_ASSUME_NONNULL_END
