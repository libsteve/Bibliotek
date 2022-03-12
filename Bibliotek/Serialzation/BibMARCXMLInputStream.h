//
//  BibMARCXMLInputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/6/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibRecordInputStream.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MARCXMLInputStream)
@interface BibMARCXMLInputStream : BibRecordInputStream

/// Initializes and returns a \c BibMARCXMLInputStream for reading from the given input stream.
/// \param inputStream The \c NSInputStream object from which record data should be read.
/// \returns An initialized \c BibMARCXMLInputStream object that reads \c BibRecord objects from the given input stream.
- (instancetype)initWithInputStream:(NSInputStream *)inputStream NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
