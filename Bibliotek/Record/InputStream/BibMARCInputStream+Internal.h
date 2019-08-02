//
//  BibMARCInputStream+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/24/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibMARCInputStream.h"
#import "BibSubfield.h"

@class BibLeader;
@class BibFieldTag;
@class BibDirectoryEntry;
@class BibControlField;
@class BibContentIndicatorList;
@class BibContentField;

NS_ASSUME_NONNULL_BEGIN

@interface BibMARCInputStream (Internal)

- (nullable BibLeader *)readLeader:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibFieldTag *)readFieldTag:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibDirectoryEntry *)readDirectoryEntryWithLeader:(BibLeader *)leader
                                                       error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibControlField *)readControlFieldWithLeader:(BibLeader *)leader
                                          directoryEntry:(BibDirectoryEntry *)directoryEntry
                                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibContentIndicatorList *)readContentIndicatorsWithLeader:(BibLeader *)leader
                                                                error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibSubfieldCode)readSubfieldCodeWithLeader:(BibLeader *)leader
                                                 error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable NSString *)readSubfieldContentWithLeader:(BibLeader *)leader
                                               error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

- (nullable BibContentField *)readContentFieldWithLeader:(BibLeader *)leader
                                          directoryEntry:(BibDirectoryEntry *)directoryEntry
                                                   error:(out NSError *_Nullable __autoreleasing *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
