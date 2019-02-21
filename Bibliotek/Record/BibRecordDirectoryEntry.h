//
//  BibRecordDirectoryEntry.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Record.DirectoryEntry)
@interface BibRecordDirectoryEntry : NSObject

@property (nonatomic, copy, readonly) NSString *fieldTag;

@property (nonatomic, assign, readonly) NSRange fieldRange;

- (instancetype)initWithData:(NSData *)data;

- (instancetype)initWithFieldTag:(NSString *)fieldTag range:(NSRange)fieldRange NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToEntry:(BibRecordDirectoryEntry *)entry;

@end

NS_ASSUME_NONNULL_END
