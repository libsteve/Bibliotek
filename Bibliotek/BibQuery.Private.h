//
//  BibQuery.Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibQuery.h"
#import <yaz/zoom.h>

@interface BibQuery ()

@property(nonatomic, readonly, assign, nonnull) ZOOM_query zoomQuery;

@end
