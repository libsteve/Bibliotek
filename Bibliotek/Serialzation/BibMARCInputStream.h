//
//  BibMARCInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibAttributes.h>
#import <Bibliotek/BibRecordInputStream.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// A read-only stream of records parsed from MARC 21 encoded data.
NS_SWIFT_NAME(MARCInputStream)
@interface BibMARCInputStream : BibRecordInputStream

/// Initializes and returns a ``BibMARCInputStream`` for reading from the given input stream.
/// - parameter inputStream: The `NSInputStream` object from which record data should be read.
/// - returns: An initialized ``BibMARCInputStream`` object that reads ``BibRecord`` objects
///            from the given input stream.
- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
