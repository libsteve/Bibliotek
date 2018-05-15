//
//  BibRecord.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/15/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibRecord.h"
#import "BibRecord.Private.h"
#import <yaz/zoom.h>

@implementation BibRecord {
    ZOOM_record _record;
}

@synthesize zoomRecord = _record;

#pragma mark - Initialization

- (instancetype)initWithZoomRecord:(ZOOM_record)zoomRecord {
    if (self = [super init]) {
        _record = ZOOM_record_clone(zoomRecord);
    }
    return self;
}

- (void)dealloc {
    ZOOM_record_destroy(_record);
}

#pragma mark - Properties

- (NSData *)xmlData {
    int length = 0;
    char const *const type = "xml; charset=marc8";
    char const *const bytes = ZOOM_record_get(_record, type, &length);
    return [NSData dataWithBytes:bytes length:length];
}

- (NSData *)jsonData {
    int length = 0;
    char const *const type = "json; charset=marc8";
    char const *const bytes = ZOOM_record_get(_record, type, &length);
    return [NSData dataWithBytes:bytes length:length];
}

@end
