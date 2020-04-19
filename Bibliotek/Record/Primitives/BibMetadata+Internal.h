//
//  BibMetadata+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibMetadata.h>

@class BibLeader;
@class BibMutableLeader;

NS_ASSUME_NONNULL_BEGIN

@interface BibMetadata (Internal)

@property (nonatomic, strong, readonly) BibLeader *leader;

- (instancetype)initWithLeader:(BibLeader *)leader;

@end

@interface BibMutableMetadata (Internal)

@property (nonatomic, strong, readonly) BibMutableLeader *leader;

@end

NS_ASSUME_NONNULL_END
