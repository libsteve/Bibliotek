//
//  BibMetadata+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMetadata.h"

@class BibLeader;
@class BibMutableLeader;

NS_ASSUME_NONNULL_BEGIN

@interface BibMetadata ()

@property (nonatomic, copy, readonly) BibMutableLeader *leader;

- (instancetype)initWithLeader:(BibLeader *)leader NS_DESIGNATED_INITIALIZER;

@end

@interface NSString (BibEncoding)

extern NSData *BibUTF8EncodedDataFromMARC8EncodedData(NSData *const data);

+ (nullable NSString *)bib_stringWithData:(NSData *)data
                                 encoding:(BibEncoding)encoding
                                    error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

extern NSErrorDomain const BibEncodingErrorDomain;

typedef NS_ERROR_ENUM(BibEncodingErrorDomain, BibEncodingErrorCode) {
    BibEncodingUnknownEncodingError NS_SWIFT_NAME(unknownEncoding),
    BibEncodingMalformedDataError NS_SWIFT_NAME(malformedData)
} NS_SWIFT_NAME(Encoding.Error);

NS_ASSUME_NONNULL_END
