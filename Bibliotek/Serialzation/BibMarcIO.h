//
//  BibMarcIO.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/12/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct BibMarcLeader {
    int8_t recordKind;
    size_t recordLength;
    size_t fieldsLocation;
    int8_t leaderData[24];
} BibMarcLeader;

typedef struct BibMarcDirectoryEntry {
    char   fieldTag[4];
    size_t fieldLength;
    size_t fieldLocation; // Location of the field relative to the first field's location in the record.

} BibMarcDirectoryEntry;

typedef struct BibMarcControlField {
    char  tag[4];
    char *content;
} BibMarcControlField;

typedef struct BibMarcSubfield {
    char  code;
    char *content;
} BibMarcSubfield;

typedef struct BibMarcContentField {
    char   tag[4];
    int8_t indicators[2];
    BibMarcSubfield *subfields;
    size_t subfieldsCount;
} BibMarcContentField;

typedef struct BibMarcRecord {
    BibMarcLeader leader;
    BibMarcControlField *controlFields;
    size_t controlFieldsCount;
    BibMarcContentField *contentFields;
    size_t contentFieldsCount;
} BibMarcRecord;

#pragma mark - Reading

BibMarcLeader BibMarcLeaderRead(int8_t const *buffer, size_t length);
BibMarcDirectoryEntry BibMarcDirectoryEntryRead(int8_t const *buffer, size_t length);

/// \param field Allocated space for a control field structure where data read from the buffer will be written.
/// \param entry The directory entry describing the control field in the buffer.
/// \param buffer The raw data containing the record's control fields and content fields.
/// \param length The length of the raw data buffer containing the record's control and content fields.
boolean_t BibMarcControlFieldRead(BibMarcControlField *field, BibMarcDirectoryEntry const *entry, int8_t const *buffer, size_t length);
size_t BibMarcSubfieldRead(BibMarcSubfield *subfield, int8_t const *buffer, size_t length);

/// \param field Allocated space for a content field structure where data read from the buffer will be written.
/// \param entry The directory entry describing the content field in the buffer.
/// \param buffer The raw data containing the record's control fields and content fields.
/// \param length The length of the raw data buffer containing the record's control and content fields.
boolean_t BibMarcContentFieldRead(BibMarcContentField *field, BibMarcDirectoryEntry const *entry, int8_t const *buffer, size_t length);
size_t BibMarcRecordRead(BibMarcRecord *record, int8_t const *buffer, size_t length);

#pragma mark - Writing

boolean_t BibMarcLeaderWrite(BibMarcLeader const *leader, int8_t *buffer, size_t length);
boolean_t BibMarcDirectoryEntryWrite(BibMarcDirectoryEntry const *entry, int8_t *buffer, size_t length);

/// \param buffer A buffer to write the record's control and content fields—including the record terminator.
/// \param length The length of the raw data buffer to write the record's control and content fields.
boolean_t BibMarcControlFieldWrite(BibMarcControlField const *field, BibMarcDirectoryEntry const *entry, int8_t *buffer, size_t length);
size_t BibMarcSubfieldWrite(BibMarcSubfield const *subfield, int8_t *buffer, size_t length);

/// \param buffer A buffer to write the record's control and content fields—including the record terminator.
/// \param length The length of the raw data buffer to write the record's control and content fields.
boolean_t BibMarcContentFieldWrite(BibMarcContentField const *field, BibMarcDirectoryEntry const *entry, int8_t *buffer, size_t length);
size_t BibMarcRecordWrite(BibMarcRecord const *record, int8_t *buffer, size_t length);

#pragma mark - 

size_t BibMarcControlFieldGetWriteSize(BibMarcControlField const *field);
size_t BibMarcContentFieldGetWriteSize(BibMarcContentField const *field);
size_t BibMarcRecordGetWriteSize(BibMarcRecord const *record);

#pragma mark - Cleanup

void BibMarcControlFieldDestroy(BibMarcControlField *field);
void BibMarcSubfieldDestroy(BibMarcSubfield *subfield);
void BibMarcContentFieldDestroy(BibMarcContentField *field);
void BibMarcRecordDestroy(BibMarcRecord *record);

NS_ASSUME_NONNULL_END
