//
//  BibMetadata+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMetadata.h"

@class BibMutableLeader;

NS_ASSUME_NONNULL_BEGIN

@interface BibMetadata ()

@property (nonatomic, copy, readonly) BibMutableLeader *leader;

- (instancetype)initWithLeader:(BibLeader *)leader NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
