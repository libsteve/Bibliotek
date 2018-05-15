//
//  BibOptions.Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibOptions.h"
#import <yaz/zoom.h>

@interface BibOptions ()

@property(nonatomic, readonly, assign, nullable) ZOOM_options zoomOptions;

@end
