//
//  BibRecordReader__.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibMARC21Reader.h"
#import "BibInputStream.h"
#import "BibSubfield.h"

@class BibLeader;
@class BibDirectoryEntry;
@class BibControlField;
@class BibContentField;
@class BibContentIndicators;

NS_ASSUME_NONNULL_BEGIN

@interface BibMARC21Reader (Internal)

- (nullable BibLeader *)readLeader:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibDirectoryEntry *)readEntryWithLeader:(BibLeader *)leader
                                              error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibControlField *)readControlFieldWithLeader:(BibLeader *)leader
                                          directoryEntry:(BibDirectoryEntry *)directoryEntry
                                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;


- (nullable BibContentField *)readContentFieldWithLeader:(BibLeader *)leader
                                          directoryEntry:(BibDirectoryEntry *)directoryEntry
                                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark - Content Field Reader

@interface _BibMARC21ContentFieldReader : NSObject

- (instancetype)initWithInputStream:(BibInputStream *)inputStream
                             leader:(BibLeader *)leader
                              entry:(BibDirectoryEntry *)entry
                              error:(out NSError *_Nullable __autoreleasing *_Nullable)error NS_DESIGNATED_INITIALIZER;

- (nullable BibContentField *)readContentFieldWithError:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

@interface _BibMARC21ContentFieldReader (ContentField)

- (nullable BibContentIndicators *)readContentIndicatorsWithError:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibSubfieldCode)readSubfieldCodeWithError:(out NSError *_Nullable __autoreleasing *_Nullable)error;

/// \pre \c delimiter is not \c NULL.
- (nullable NSString *)readSubfieldContentWithDelimiter:(out uint8_t *)delimiter
                                                  error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark - Input Stream

@interface BibInputStream (MARC21Reader)

- (BOOL)readFieldTerminator:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (BOOL)readRecordTerminator:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSData *)readDataForDirectoryEntry:(BibDirectoryEntry *)entry
                                         error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibInputStream *)inputStreamForDirectoryEntry:(BibDirectoryEntry *)entry
                                                     error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

#pragma mark - Malformed Data Error

extern void _BibMARC21ReaderSetError(NSError *_Nullable __autoreleasing *_Nullable error,
                                     BibMARC21ReaderErrorCode code,
                                     NSString *format, ...);

NS_ASSUME_NONNULL_END
