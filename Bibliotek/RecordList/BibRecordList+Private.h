//
//  BibRecordList+Private.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/27/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import "BibRecordList.h"
#import <yaz/zoom.h>

@class BibConnection;
@class BibFetchRequest;

@interface BibRecordList ()

- (instancetype)initWithZoomResultSet:(ZOOM_resultset)resultset connection:(BibConnection *)connection request:(BibFetchRequest *)request;

@end

@interface BibRecordListEnumerator: NSEnumerator<BibRecord *> <NSCopying, NSMutableCopying>

- (instancetype)initWithRecordList:(BibRecordList *)recordList;

@end
