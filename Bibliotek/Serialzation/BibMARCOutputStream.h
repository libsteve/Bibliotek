//
//  BibMARCOutputStream.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibRecordOutputStream.h>

@class BibRecord;

NS_ASSUME_NONNULL_BEGIN

/// A write-only stream used to serialize record objects as MARC 21 encoded data.
NS_SWIFT_NAME(MARCOutputStream)
@interface BibMARCOutputStream : BibRecordOutputStream

/// Initializes and returns a \c BibMARCOutputStream for writing to the given input stream.
/// \param outputStream The \c NSOutputStream object to which record data should be written.
/// \returns An initialized \c BibMARCOutputStream object that writes \c BibRecord objects to the given input stream.
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
