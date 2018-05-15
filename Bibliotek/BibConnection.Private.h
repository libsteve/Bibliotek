//
//  BibConnection.Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibConnection.h"
#import <yaz/zoom.h>

@interface BibConnection ()

@property(nonatomic, readonly, assign, nonnull) ZOOM_connection zoomConnection;

@end
