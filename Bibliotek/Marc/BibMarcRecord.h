//
//  BibMarcRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcRecordControlField;
@class BibMarcRecordDataField;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord)
@interface BibMarcRecord : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, copy, readonly) NSString *leader;
@property (nonatomic, copy, readonly) NSArray<BibMarcRecordControlField *> *controlFields;
@property (nonatomic, copy, readonly) NSArray<BibMarcRecordDataField *> *dataFields;

- (instancetype)initWithLeader:(NSString *)leader
                 controlFields:(NSArray<BibMarcRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibMarcRecordDataField *> *)dataFields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToRecord:(BibMarcRecord *)other;

@end

NS_SWIFT_NAME(MutableMarcRecord)
@interface BibMutableMarcRecord : BibMarcRecord

@property (nonatomic, copy, readwrite) NSString *leader;
@property (nonatomic, copy, readwrite) NSArray<BibMarcRecordControlField *> *controlFields;
@property (nonatomic, copy, readwrite) NSArray<BibMarcRecordDataField *> *dataFields;

@end

NS_ASSUME_NONNULL_END
