//
//  BibMARCSerialization.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/26/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibMARCSerialization.h"
#import "BibRecord.h"
#import "BibMARCInputStream.h"
#import "BibMARCOutputStream.h"
#import "BibSerializationError.h"

#import "BibMetadata+Internal.h"

#import "BibCharacterConversion.h"

#import "BibRecord.h"
#import "BibLeader.h"
#import "BibFieldTag.h"
#import "BibRecordField.h"
#import "BibFieldIndicator.h"
#import "BibSubfield.h"
#import "BibRecordKind.h"

#import "BibMarcIO.h"

static BibMarcRecord BibMarcRecordMakeFromBibRecord(BibRecord *record);
static BibRecord *BibRecordMakeFromMarcRecord(BibMarcRecord const *marcRecord) NS_RETURNS_RETAINED;

static BOOL BibMarcLeaderReadFromInputStream(BibMarcLeader *leader, NSInputStream *inputStream,
                                             NSError *__autoreleasing *error);

static BOOL BibMARCSerializationCanUseStream(NSStream *stream, NSError *__autoreleasing *error);
static NSError *BibMARCSerializationMakeMissingDataError(void);
static NSError *BibMARCSerializationMakeMalformedDataError(void);
static NSError *BibMARCSerializationMakeStreamAtEndError(void);

@implementation BibMARCSerialization

+ (NSData *)dataWithRecord:(BibRecord *)record error:(NSError *__autoreleasing *)error {
    NSOutputStream *const outputStream = [[NSOutputStream alloc] initToMemory];
    [outputStream open];
    BOOL const success = [self writeRecord:record toStream:outputStream error:error];
    [outputStream close];
    return (success) ? [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey] : nil;
}

+ (NSData *)dataWithRecordsInArray:(NSArray<BibRecord *> *)records error:(NSError *__autoreleasing *)error {
    NSOutputStream *const outputStream = [[NSOutputStream alloc] initToMemory];
    [outputStream open];
    for (BibRecord *record in records) {
        if (! [self writeRecord:record toStream:outputStream error:error]) {
            [outputStream close];
            return nil;
        }
    }
    [outputStream close];
    return [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

+ (NSArray<BibRecord *> *)recordsFromData:(NSData *)data error:(out NSError *__autoreleasing *)error {
    NSInputStream *const inputStream = [[NSInputStream alloc] initWithData:data];
    NSMutableArray *const recordsArray = [[NSMutableArray alloc] init];

    [inputStream open];
    NSError *err = nil;
    BibRecord *record = [self recordFromStream:inputStream error:error];
    while (record != nil && err == nil) {
        [recordsArray addObject:record];
        record = [inputStream hasBytesAvailable] ? [self recordFromStream:inputStream error:&err] : nil;
    }
    [inputStream close];

    if (err != nil && error != NULL) {
        *error = err;
    }
    return (err == nil) ? recordsArray : nil;
}

+ (BibRecord *)recordFromStream:(NSInputStream *)inputStream error:(out NSError *__autoreleasing *)error {
    if (! [inputStream hasBytesAvailable]) {
        if (error != NULL) {
            *error = BibMARCSerializationMakeStreamAtEndError();
        }
        return nil;
    }
    if (! BibMARCSerializationCanUseStream(inputStream, error)) {
        return nil;
    }
    BibMarcLeader leader;
    if (! BibMarcLeaderReadFromInputStream(&leader, inputStream, error)) {
        return nil;
    }

    size_t const remainingBytesCount = leader.recordLength - BibLeaderRawDataLength;
    uint8_t *const buffer = alloca(leader.recordLength * sizeof(int8_t));
    memcpy(buffer, leader.leaderData, BibLeaderRawDataLength);

    NSUInteger const remainingReadLength = [inputStream read:(buffer + BibLeaderRawDataLength)
                                                   maxLength:remainingBytesCount];
    if (remainingReadLength == NSNotFound)
    {
        if (error != NULL) {
            *error = [inputStream streamError];
        }
        return nil;
    }
    else if (remainingReadLength != remainingBytesCount)
    {
        if (error != NULL) {
            *error = BibMARCSerializationMakeMissingDataError();
        }
        return nil;
    }

    BibMarcRecord marcRecord;
    if (BibMarcRecordRead(&marcRecord, (int8_t *)buffer, leader.recordLength) != leader.recordLength) {
        if (error != NULL) {
            *error = BibMARCSerializationMakeMalformedDataError();
        }
        return nil;
    }

    BibRecord *const bibRecord = BibRecordMakeFromMarcRecord(&marcRecord);
    BibMarcRecordDestroy(&marcRecord);
    return bibRecord;
}

+ (BOOL)writeRecord:(BibRecord *)record
           toStream:(NSOutputStream *)outputStream
              error:(out NSError *__autoreleasing *)error {
    if (! [outputStream hasSpaceAvailable]) {
        if (error != NULL) {
            *error = BibMARCSerializationMakeStreamAtEndError();
        }
        return NO;
    }
    if (! BibMARCSerializationCanUseStream(outputStream, error)) {
        return NO;
    }

    BibMarcRecord marcRecord = BibMarcRecordMakeFromBibRecord(record);

    size_t const length = BibMarcRecordGetWriteSize(&marcRecord);
    int8_t *const buffer = alloca(sizeof(int8_t) * length);
    size_t const bufferWriteLength = length - BibMarcRecordWrite(&marcRecord, buffer, length);
    BibMarcRecordDestroy(&marcRecord);

    if (bufferWriteLength == 0) {
        if (error != NULL) {
            *error = BibMARCSerializationMakeMalformedDataError();
        }
        return NO;
    }
    size_t const outputWriteLength = [outputStream write:(uint8_t *)buffer maxLength:length];
    BOOL const success = (bufferWriteLength == outputWriteLength);
    if (!success && error != NULL) {
        *error = BibMARCSerializationMakeStreamAtEndError();
    }
    
    return success;
}

@end

#pragma mark -

static BibMarcRecord BibMarcRecordMakeFromBibRecord(BibRecord *bibRecord)
{
    BibMarcRecord record;
    NSData *const leaderData = bibRecord.leader.rawData;
    record.leader = BibMarcLeaderRead(leaderData.bytes, leaderData.length);
    NSMutableArray *const bibControlFields = [NSMutableArray new];
    NSMutableArray *const bibDataFields = [NSMutableArray new];
    for (BibRecordField *field in bibRecord.fields) {
        if (field.isDataField) {
            [bibDataFields addObject:field];
        } else if (field.isControlField) {
            [bibControlFields addObject:field];
        }
    }
    record.controlFieldsCount = bibControlFields.count;
    record.contentFieldsCount = bibDataFields.count;
    record.controlFields = calloc(record.controlFieldsCount, sizeof(BibMarcControlField));
    record.contentFields = calloc(record.contentFieldsCount, sizeof(BibMarcContentField));

    bib_char_encoding_t to, from;
    switch (bibRecord.leader.recordEncoding) {
        case BibUTF8Encoding:
            to = bib_char_encoding_utf8;
            from = bib_char_encoding_utf8;
            break;
        case BibMARC8Encoding:
        default:
            to = bib_char_encoding_marc8;
            from = bib_char_encoding_utf8;
            break;
    }

    bib_char_converter_t const converter = bib_char_converter_open(to, from);
    for (size_t index = 0; index < record.controlFieldsCount; index += 1)
    {
        BibMarcControlField *const field = &(record.controlFields[index]);
        BibRecordField *const bibField = bibControlFields[index];
        field->content = bib_char_convert_utf8(converter, bibField.controlValue);
        strcpy(field->tag, bibField.fieldTag.stringValue.UTF8String);
    }
    for (size_t index = 0; index < record.contentFieldsCount; index += 1)
    {
        BibMarcContentField *const field = &(record.contentFields[index]);
        BibRecordField *const bibField = bibDataFields[index];
        field->indicators[0] = bibField.firstIndicator.rawValue;
        field->indicators[1] = bibField.secondIndicator.rawValue;
        strcpy(field->tag, bibField.fieldTag.stringValue.UTF8String);
        field->subfieldsCount = bibField.subfields.count;
        field->subfields = calloc(field->subfieldsCount, sizeof(BibMarcSubfield));
        NSEnumerator *const bibSubfields = [bibField.subfields objectEnumerator];
        for (size_t index = 0; index < field->subfieldsCount; index += 1)
        {
            BibMarcSubfield *const subfield = &(field->subfields[index]);
            BibSubfield *const bibSubfield = [bibSubfields nextObject];
            subfield->code = bibSubfield.subfieldCode.UTF8String[0];
            subfield->content = bib_char_convert_utf8(converter, bibSubfield.content);
        }
    }
    bib_char_converter_close(converter);
    return record;
}

static NSArray *BibRecordFieldMakeArrayFromMarcRecord(BibMarcRecord const *marcRecord,
                                                      bib_char_converter_t converter) NS_RETURNS_RETAINED;


static BibRecord *BibRecordMakeFromMarcRecord(BibMarcRecord const *const marcRecord) NS_RETURNS_RETAINED
{
    int8_t const *const leaderBytes = marcRecord->leader.leaderData;
    NSData *const leaderData = [[NSData alloc] initWithBytes:leaderBytes length:BibLeaderRawDataLength];
    BibLeader *const bibLeader = [[BibLeader alloc] initWithData:leaderData];

    bib_char_encoding_t to, from;
    switch (marcRecord->leader.recordEncoding) {
        case 'a':
            to = bib_char_encoding_utf8;
            from = bib_char_encoding_utf8;
            break;
        case ' ':
        default:
            to = bib_char_encoding_utf8;
            from = bib_char_encoding_marc8;
            break;
    }

    bib_char_converter_t const converter = bib_char_converter_open(to, from);
    NSArray *fields = BibRecordFieldMakeArrayFromMarcRecord(marcRecord, converter);
    BibRecord *const record = [[BibRecord alloc] initWithLeader:bibLeader fields:fields];
    bib_char_converter_close(converter);
    return record;
}

static BOOL BibMarcLeaderReadFromInputStream(BibMarcLeader *const leader, NSInputStream *const inputStream,
                                             NSError *__autoreleasing *const error) {
    assert(leader != NULL);

    uint8_t *const leaderBytes = alloca(BibLeaderRawDataLength * sizeof(int8_t));
    NSUInteger const readLength = [inputStream read:leaderBytes maxLength:BibLeaderRawDataLength];
    if (readLength == 0)
    {
        if (error != NULL) {
            *error = BibMARCSerializationMakeStreamAtEndError();
        }
        return NO;
    }
    else if (readLength == NSNotFound)
    {
        if (error != NULL) {
            *error = [inputStream streamError];
        }
        return NO;
    }
    else if (readLength != BibLeaderRawDataLength)
    {
        if (error != NULL) {
            *error = BibMARCSerializationMakeMissingDataError();
        }
        return NO;
    }

    *leader = BibMarcLeaderRead((int8_t *)leaderBytes, BibLeaderRawDataLength);
    if (leader->recordLength == NSNotFound || leader->fieldsLocation == NSNotFound)
    {
        if (error != NULL) {
            *error = BibMARCSerializationMakeMalformedDataError();
        }
        return NO;
    }

    return YES;
}

static NSArray *BibRecordFieldMakeArrayFromMarcRecord(BibMarcRecord const *const marcRecord,
                                                      bib_char_converter_t marc8) NS_RETURNS_RETAINED
{
    NSUInteger const recordFieldsCount = marcRecord->controlFieldsCount + marcRecord->contentFieldsCount;
    NSMutableArray *const recordFields = [[NSMutableArray alloc] initWithCapacity:recordFieldsCount];
    for (size_t index = 0; index < marcRecord->controlFieldsCount; index += 1)
    {
        BibMarcControlField const *const field = &(marcRecord->controlFields[index]);
        NSString *const tagString = [[NSString alloc] initWithUTF8String:field->tag];
        BibFieldTag *const tag = [[BibFieldTag alloc] initWithString:tagString];
        NSString *const value = bib_char_convert_marc8(marc8, field->content);
        BibRecordField *const controlField = [[BibRecordField alloc] initWithFieldTag:tag controlValue:value];
        [recordFields addObject:controlField];
    }
    for (size_t index = 0; index < marcRecord->contentFieldsCount; index += 1)
    {
        BibMarcContentField const *const field = &(marcRecord->contentFields[index]);
        NSString *const tagString = [[NSString alloc] initWithUTF8String:field->tag];
        BibFieldTag *const tag = [[BibFieldTag alloc] initWithString:tagString];
        BibFieldIndicator *const firstIndicator = [[BibFieldIndicator alloc] initWithRawValue:field->indicators[0]];
        BibFieldIndicator *const secondIndicator = [[BibFieldIndicator alloc] initWithRawValue:field->indicators[1]];
        NSMutableArray *const subfields = [[NSMutableArray alloc] initWithCapacity:field->subfieldsCount];
        for (size_t index = 0; index < field->subfieldsCount; index += 1)
        {
            BibMarcSubfield const *const subfield = &(field->subfields[index]);
            NSString *const code = [[NSString alloc] initWithUTF8String:(char[2]){subfield->code, '\0'}];
            NSString *const content = bib_char_convert_marc8(marc8, subfield->content);
            BibSubfield *const bibSubfield = [[BibSubfield alloc] initWithCode:code content:content];
            [subfields addObject:bibSubfield];
        }
        BibRecordField *const dataField = [[BibRecordField alloc] initWithFieldTag:tag
                                                                    firstIndicator:firstIndicator
                                                                   secondIndicator:secondIndicator
                                                                         subfields:subfields];
        [recordFields addObject:dataField];
    }
    return recordFields;
}

static BOOL BibMARCSerializationCanUseStream(NSStream *const stream, NSError *__autoreleasing *const error) {
    switch ([stream streamStatus]) {
        case NSStreamStatusOpen:
            return YES;
        case NSStreamStatusError:
            if (error) {
                *error = [stream streamError];
            }
            return NO;
        case NSStreamStatusAtEnd:
            if (error) {
                *error = BibMARCSerializationMakeStreamAtEndError();
            }
            return NO;
        case NSStreamStatusNotOpen:
            if (error) {
                static NSString *const message = @"A stream must be opened before data can be read/written";
                *error = [NSError errorWithDomain:BibSerializationErrorDomain
                                             code:BibSerializationStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusClosed:
            if (error) {
                static NSString *const message = @"A closed stream cannot read/write data";
                *error = [NSError errorWithDomain:BibSerializationErrorDomain
                                             code:BibSerializationStreamNotOpenedError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusOpening:
            if (error) {
                static NSString *const message = @"Cannot read/write data from a stream while it's opening";
                *error = [NSError errorWithDomain:BibSerializationErrorDomain
                                             code:BibSerializationStreamBusyError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusReading:
            if (error) {
                static NSString *const message = @"Cannot read/write data from a stream while it's reading data";
                *error = [NSError errorWithDomain:BibSerializationErrorDomain
                                             code:BibSerializationStreamBusyError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
        case NSStreamStatusWriting:
            if (error) {
                static NSString *const message = @"Cannot read/write data from a stream while it's writing data";
                *error = [NSError errorWithDomain:BibSerializationErrorDomain
                                             code:BibSerializationStreamBusyError
                                         userInfo:@{ NSDebugDescriptionErrorKey : message }];
            }
            return NO;
    }
}

static NSError *BibMARCSerializationMakeMissingDataError() {
    return  [NSError errorWithDomain:BibSerializationErrorDomain
                                code:BibSerializationStreamAtEndError
                            userInfo:@{ NSDebugDescriptionErrorKey : @"Expected to read more MARC 21 data" }];
}

static NSError *BibMARCSerializationMakeMalformedDataError() {
    return [NSError errorWithDomain:BibSerializationErrorDomain
                               code:BibSerializationMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : @"Malformed MARC 21 data" }];
}

static NSError *BibMARCSerializationMakeStreamAtEndError() {
    static NSString *const message = @"Cannot read/write data from a the end of a stream";
    return [NSError errorWithDomain:BibSerializationErrorDomain
                               code:BibSerializationStreamAtEndError
                           userInfo:@{ NSDebugDescriptionErrorKey : message }];
}
