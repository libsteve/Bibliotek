//
//  BibRecordField.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/3/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibRecordConstants.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RecordField)
@protocol BibRecordField <NSObject>

/// A three-digit code used to identify this control field's semantic purpose.
@property (nonatomic, readonly) BibRecordFieldTag tag;

- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
