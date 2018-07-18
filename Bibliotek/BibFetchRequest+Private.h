//
//  BibFetchRequest+Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibFetchRequest.h"
#import <yaz/zoom.h>

@interface BibFetchRequest ()

@property(nonatomic, readonly, assign, nonnull) ZOOM_query zoomQuery;

@end
