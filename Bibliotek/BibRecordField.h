//
//  BibRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordFieldTag.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Record.Field)
@interface BibRecordField<Content: id> : NSObject

@property(nonatomic, readonly, copy) BibRecordFieldTag tag;
@property(nonatomic, readonly, nullable) Content content;

@end

NS_ASSUME_NONNULL_END
