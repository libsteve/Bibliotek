//
//  _BibMarcRecord.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BibMarcRecordControlField;
@class BibMarcRecordDataField;

NS_ASSUME_NONNULL_BEGIN

@interface _BibMarcRecord : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

@property (nonatomic, readonly, copy) NSString *leader;
@property (nonatomic, readonly, copy) NSArray<BibMarcRecordControlField *> *controlFields;
@property (nonatomic, readonly, copy) NSArray<BibMarcRecordDataField *> *dataFields;

- (instancetype)initWithLeader:(NSString *)leader
                 controlFields:(NSArray<BibMarcRecordControlField *> *)controlFields
                    dataFields:(NSArray<BibMarcRecordDataField *> *)dataFields NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToRecord:(_BibMarcRecord *)other;

@end

@interface _BibMutableMarcRecord : _BibMarcRecord

@property (nonatomic, readwrite, copy) NSString *leader;
@property (nonatomic, readwrite, copy) NSArray<BibMarcRecordControlField *> *controlFields;
@property (nonatomic, readwrite, copy) NSArray<BibMarcRecordDataField *> *dataFields;

@end

NS_ASSUME_NONNULL_END
