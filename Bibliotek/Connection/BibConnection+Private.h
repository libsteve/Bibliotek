//
//  BibConnection+Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Bibliotek/BibConnection.h>
#import <yaz/zoom.h>

NS_ASSUME_NONNULL_BEGIN

extern NSInteger const kDefaultPort;
extern NSString *const kDefaultDatabase;

@interface BibConnection ()

@property(nonatomic, readonly, assign, nonnull) ZOOM_connection zoomConnection;

- (BOOL)error:(NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
