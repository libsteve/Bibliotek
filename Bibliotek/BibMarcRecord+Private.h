//
//  BibMarcRecord+Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/18/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibMarcRecord.h"
#import <yaz/zoom.h>

NS_ASSUME_NONNULL_BEGIN

@interface BibMarcRecord ()

@property(nonatomic, readonly, assign, nullable) ZOOM_record zoomRecord;

- (instancetype)initWithZoomRecord:(ZOOM_record)zoomRecord;

@end

NS_ASSUME_NONNULL_END
