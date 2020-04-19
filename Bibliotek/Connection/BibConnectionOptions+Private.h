//
//  BibConnectionOptions+Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Bibliotek/BibConnectionOptions.h>
#import <yaz/zoom.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibConnectionOptions ()

@property(nonatomic, readonly, assign) ZOOM_options zoomOptions;

@end

NS_ASSUME_NONNULL_END
