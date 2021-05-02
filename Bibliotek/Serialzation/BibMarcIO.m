//
//  BibMarcIO.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/12/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibMarcIO.h"

static int8_t const kEncoding = '0';
static int8_t const kNumberOfIndicators = 2;
static int8_t const kLengthOfSubfieldCode = 2;
static NSRange const kLengthOfFieldRange = { .length = 4, .location = 5 };

static size_t const kLeaderLength = 24;
static size_t const kDirectoryEntryLength = 12;

static int8_t const kRecordTerminator  = 0x1D;
static int8_t const kFieldTerminator   = 0x1E;
static int8_t const kSubfieldDelimiter = 0x1F;

#pragma mark - Helpers

size_t BibMarcSizeRead(int8_t const *buffer, size_t length);
void BibMarcSizeWrite(size_t size, int8_t *buffer, size_t length);

#pragma mark - Reading

BibMarcLeader BibMarcLeaderRead(int8_t const *const buffer, size_t const length)
{
    assert(buffer != NULL);
    assert(length >= kLeaderLength);
    BibMarcLeader leader = (BibMarcLeader) {
        .recordKind = buffer[6],
        .recordLength = BibMarcSizeRead(buffer, 5),
        .fieldsLocation = BibMarcSizeRead(buffer + 12, 5),
    };
    memcpy(leader.leaderData, buffer, 24);
    return leader;
}

BibMarcDirectoryEntry BibMarcDirectoryEntryRead(int8_t const *buffer, size_t length)
{
    assert(buffer != NULL);
    assert(length >= kDirectoryEntryLength);
    BibMarcDirectoryEntry entry = (BibMarcDirectoryEntry) {
        .fieldLength = BibMarcSizeRead(buffer + 3, 4),
        .fieldLocation = BibMarcSizeRead(buffer + 7, 5)
    };
    memcpy(entry.fieldTag, buffer, 3);
    entry.fieldTag[3] = '\0'; // null-terminate strings
    return entry;
}

boolean_t BibMarcControlFieldRead(BibMarcControlField *const field, BibMarcDirectoryEntry const *const entry,
                                  int8_t const *const buffer, size_t const length)
{
    assert(field != NULL);
    assert(entry->fieldLocation + entry->fieldLength < length);
    if (field == NULL || entry->fieldLocation + entry->fieldLength > length) {
        return false;
    }
    strcpy(field->tag, entry->fieldTag);
    field->content = calloc(sizeof(uint8_t), entry->fieldLength);
    memcpy(field->content, buffer + entry->fieldLocation, entry->fieldLength - 1);
    field->content[entry->fieldLength] = '\0'; // keep the field null-terminated
    return true;
}

size_t BibMarcSubfieldRead(BibMarcSubfield *const subfield, int8_t const *const buffer, size_t const length)
{
    assert(subfield != nil);
    assert(buffer != NULL);
    assert(length >= 3); // minimum [delimiter][code][delimiter/terminator]

    // subfeild must always begin with a delimiter
    assert(buffer[0] == kSubfieldDelimiter);

    // read subfield code
    subfield->code = buffer[1];

    // find string content length
    size_t const location = 2;
    size_t cursor = location;
    int8_t byte = buffer[cursor];
    while (byte != kSubfieldDelimiter && byte != kFieldTerminator)
    {
        cursor += 1;
        assert(cursor < length);
        byte = buffer[cursor];
    }

    // content must always end with a delimiter or terminator
    assert(byte == kSubfieldDelimiter || byte == kFieldTerminator);

    // read string content
    size_t const content_len = cursor - location;
    subfield->content = calloc(content_len + 1, sizeof(char));
    memcpy(subfield->content, buffer + location, content_len);
    subfield->content[content_len] = '\0'; // null-terminate strings
    return cursor;
}

size_t BibMarcContentFieldReadSubfieldsCount(BibMarcDirectoryEntry const *const entry,
                                             int8_t const *const buffer, size_t const length)
{
    size_t const location = entry->fieldLocation + 2; // ignore the two indicator characters
    size_t const upper_bound = entry->fieldLocation + entry->fieldLength;
    assert(location < upper_bound);
    assert(upper_bound < length);
    size_t count = 0;
    for (size_t index = location; index < upper_bound; index += 1)
    {
        if (buffer[index] == kSubfieldDelimiter)
        {
            count += 1;
        }
    }
    return count;
}

boolean_t BibMarcContentFieldRead(BibMarcContentField *const field, BibMarcDirectoryEntry const *const entry,
                                  int8_t const *const buffer, size_t const length)
{
    assert(field != NULL);
    assert(entry->fieldLength >= 3); // expect at least 2 indicators and a field terminator
    assert(entry->fieldLocation + entry->fieldLength < length);

    // read tag and indicators
    strcpy(field->tag, entry->fieldTag);
    memcpy(field->indicators, buffer + entry->fieldLocation, 2);

    // allocate subfields
    size_t const count = BibMarcContentFieldReadSubfieldsCount(entry, buffer, length);
    field->subfields = calloc(count, sizeof(BibMarcSubfield));
    field->subfieldsCount = count;

    // read subfields
    size_t buffer_len = entry->fieldLength - 2;
    int8_t const *buffer_ptr = buffer + entry->fieldLocation + 2;
    for (size_t index = 0; index < count; index += 1)
    {
        size_t const offset = BibMarcSubfieldRead(&(field->subfields[index]), buffer_ptr, buffer_len);
        buffer_len -= offset;
        buffer_ptr += offset;
    }

    assert(buffer_len == 1);
    assert(buffer_ptr[0] == kFieldTerminator);
    return (buffer_len == 1) && (buffer_ptr[0] == kFieldTerminator);
}

/// \note Directory entries must be sorted by tag, beginning with entries for control fields.
size_t BibMarcDirectoryGetControlEntryCount(BibMarcDirectoryEntry const *const directory, size_t const length)
{
    size_t count = 0;
    for (size_t index = 0; index < length; index += 1)
    {
        BibMarcDirectoryEntry const *const entry = &(directory[index]);
        if (entry->fieldTag[0] == '0' && entry->fieldTag[1] == '0')
        {
            count += 1;
        }
        else
        {
            return count;
        }
    }
    return count;
}

size_t BibMarcRecordRead(BibMarcRecord *const record, int8_t const *const buffer, size_t const length)
{
    assert(record != NULL);

    size_t buffer_len = length;
    int8_t const *buffer_ptr = buffer;

    assert(length > kLeaderLength);
    if (length < kLeaderLength) { return 0; }

    // read the record leader
    BibMarcLeader const leader = BibMarcLeaderRead(buffer_ptr, buffer_len);
    assert(length >= leader.recordLength);
    if (length < leader.recordLength) { return 0; }

    buffer_ptr += kLeaderLength;
    buffer_len -= kLeaderLength;

    // read the directory entries
    size_t const directory_len = (leader.fieldsLocation - kLeaderLength) / kDirectoryEntryLength;
    BibMarcDirectoryEntry *const directory = alloca(directory_len * sizeof(BibMarcDirectoryEntry));
    for (size_t index = 0; index < directory_len; index += 1)
    {
        directory[index] = BibMarcDirectoryEntryRead(buffer_ptr, buffer_len);
        buffer_ptr += kDirectoryEntryLength;
        buffer_len -= kDirectoryEntryLength;
    }
    assert(buffer_ptr[0] == kFieldTerminator);
    if (buffer_ptr[0] != kFieldTerminator) { return 0; }
    buffer_ptr += 1;
    buffer_len -= 1;

    // read control fields
    size_t const control_count = BibMarcDirectoryGetControlEntryCount(directory, directory_len);
    BibMarcControlField *const control_fields = calloc(control_count, sizeof(BibMarcControlField));
    for (size_t index = 0; index < control_count; index += 1)
    {
        BibMarcDirectoryEntry const *const entry = &(directory[index]);
        boolean_t const success = BibMarcControlFieldRead(&(control_fields[index]), entry, buffer_ptr, buffer_len);
        assert(success);
    }

    // read content fields
    size_t const content_count = directory_len - control_count;
    BibMarcContentField *const content_fields = calloc(content_count, sizeof(BibMarcContentField));
    for (size_t index = 0; index < content_count; index += 1)
    {
        size_t const entry_index = index + control_count;
        BibMarcDirectoryEntry const *const entry = &(directory[entry_index]);
        boolean_t const success = BibMarcContentFieldRead(&(content_fields[index]), entry, buffer_ptr, buffer_len);
        assert(success);
    }

    record->leader = leader;
    record->controlFields = control_fields;
    record->controlFieldsCount = control_count;
    record->contentFields = content_fields;
    record->contentFieldsCount = content_count;

    // records must always end with a record terminator
    assert(buffer[leader.recordLength - 1] == kRecordTerminator);
    return leader.recordLength;
}

#pragma mark - Writing

boolean_t BibMarcLeaderWrite(BibMarcLeader const *const leader, int8_t *const buffer, size_t const length)
{
    assert(buffer != NULL);
    assert(length >= kLeaderLength);
    if (buffer == NULL || length <= kLeaderLength) { return false; }

    memcpy(buffer, leader->leaderData, 24);

    buffer[6] = leader->recordKind;
    BibMarcSizeWrite(leader->recordLength, buffer, 5);
    BibMarcSizeWrite(leader->fieldsLocation, buffer + 12, 5);

    memcpy(buffer + 9, " 22", 3); // encoding, number of indicators, length of subfield code
    memcpy(buffer + 20, "4500", 4); // directory entry map
    return true;
}

boolean_t BibMarcDirectoryEntryWrite(BibMarcDirectoryEntry const *const entry,
                                     int8_t *const buffer, size_t const length)
{
    assert(entry != NULL);
    assert(buffer != NULL);
    assert(length >= kDirectoryEntryLength);
    if (entry == NULL || buffer == NULL || length < kDirectoryEntryLength) { return false; }

    memcpy(buffer, entry->fieldTag, 3);
    BibMarcSizeWrite(entry->fieldLength, buffer + 3, 4);
    BibMarcSizeWrite(entry->fieldLocation, buffer + 7, 5);
    return true;
}

boolean_t BibMarcControlFieldWrite(BibMarcControlField const *const field,
                                   BibMarcDirectoryEntry const *const entry,
                                   int8_t *const buffer, size_t const length)
{
    assert(field != NULL);
    assert(entry != NULL);
    assert(buffer != NULL);
    assert(entry->fieldLocation + entry->fieldLength < length);
    assert(entry->fieldLength - 1 == strlen(field->content));
    if (field == NULL || entry == NULL || buffer == NULL
        || (entry->fieldLocation + entry->fieldLength >= length)
        || (entry->fieldLength - 1 != strlen(field->content))) { return false; }

    memcpy(buffer + entry->fieldLocation, field->content, entry->fieldLength - 1);
    buffer[entry->fieldLocation + entry->fieldLength - 1] = kFieldTerminator;
    return true;
}

size_t BibMarcSubfieldWrite(BibMarcSubfield const *const subfield, int8_t *const buffer, size_t const length)
{
    assert(subfield != NULL);
    assert(buffer != NULL);
    if (subfield == NULL || buffer == NULL) { return 0; }

    // [delimiter][code][...content...]
    size_t const content_len = strlen(subfield->content);
    assert(length >= kLengthOfSubfieldCode + content_len);
    if (length < kLengthOfSubfieldCode + content_len) { return 0; }

    buffer[0] = kSubfieldDelimiter; // delimiter
    buffer[1] = subfield->code; // subfield code
    memcpy(buffer + kLengthOfSubfieldCode, subfield->content, content_len); // content

    return kLengthOfSubfieldCode + content_len;
}

boolean_t BibMarcContentFieldWrite(BibMarcContentField const *const field,
                                   BibMarcDirectoryEntry const *const entry,
                                   int8_t *const buffer, size_t const length)
{
    assert(field != NULL);
    assert(entry != NULL);
    assert(buffer != NULL);
    if (field == NULL || entry == NULL || buffer == NULL) { return false; }

    size_t const upper_bounds = entry->fieldLocation + entry->fieldLength;
    assert(upper_bounds <= length);
    if (upper_bounds > length) { return false; }

    // write indicators
    memcpy(buffer + entry->fieldLocation, field->indicators, kNumberOfIndicators); // indicators

    // write subfields
    int8_t *buffer_ptr = buffer + entry->fieldLocation + kNumberOfIndicators;
    size_t  buffer_len = entry->fieldLength - kNumberOfIndicators;
    size_t const subfields_count = field->subfieldsCount;
    for (size_t index = 0; (index < subfields_count) && (buffer_len > 1); index += 1)
    {
        BibMarcSubfield const *const subfield = &(field->subfields[index]);
        size_t const offset = BibMarcSubfieldWrite(subfield, buffer_ptr, buffer_len);
        buffer_ptr += offset;
        buffer_len -= offset;
    }

    // write field terminator
    buffer_ptr[0] = kFieldTerminator;
    assert(buffer_ptr == buffer + upper_bounds - 1);
    if (buffer_ptr != (buffer + upper_bounds - 1)) { return false; }

    return true;
}

size_t BibMarcRecordWrite(BibMarcRecord const *const record, int8_t *const buffer, size_t const length)
{
    assert(record != NULL);
    assert(buffer != NULL);
    if (record == NULL || buffer == NULL) { return 0; }

    size_t const control_count = record->controlFieldsCount;
    size_t const content_count = record->contentFieldsCount;
    size_t const directory_len = control_count + content_count;

    BibMarcLeader leader = {
        .recordKind = record->leader.recordKind,
        .recordLength = BibMarcRecordGetWriteSize(record),
        .fieldsLocation = kLeaderLength + (directory_len * kDirectoryEntryLength) + 1,
    };
    memcpy(leader.leaderData, record->leader.leaderData, 24);
    assert(length >= leader.recordLength);
    if (length < leader.recordLength) { return 0; }
    BibMarcLeaderWrite(&leader, buffer, length);

    int8_t *const fields_buffer_ptr = buffer + leader.fieldsLocation;
    size_t  const fields_buffer_len = leader.recordLength - leader.fieldsLocation;

    size_t field_location = 0;
    int8_t *dir_buffer_ptr = buffer + kLeaderLength;
    size_t  dir_buffer_len = directory_len * kDirectoryEntryLength;
    for (size_t index = 0; index < control_count; index += 1)
    {
        BibMarcControlField const *const field = &(record->controlFields[index]);
        BibMarcDirectoryEntry entry = {
            .fieldLocation = field_location,
            .fieldLength = BibMarcControlFieldGetWriteSize(field)
        };
        strcpy(entry.fieldTag, field->tag);
        BibMarcDirectoryEntryWrite(&entry, dir_buffer_ptr, dir_buffer_len);
        BibMarcControlFieldWrite(field, &entry, fields_buffer_ptr, fields_buffer_len);
        field_location += entry.fieldLength;
        dir_buffer_ptr += kDirectoryEntryLength;
        dir_buffer_len -= kDirectoryEntryLength;
    }
    for (size_t index = 0; index < content_count; index += 1)
    {
        BibMarcContentField const *const field = &(record->contentFields[index]);
        BibMarcDirectoryEntry entry = {
            .fieldLocation = field_location,
            .fieldLength = BibMarcContentFieldGetWriteSize(field)
        };
        strcpy(entry.fieldTag, field->tag);
        BibMarcDirectoryEntryWrite(&entry, dir_buffer_ptr, dir_buffer_len);
        BibMarcContentFieldWrite(field, &entry, fields_buffer_ptr, fields_buffer_len);
        field_location += entry.fieldLength;
        dir_buffer_ptr += kDirectoryEntryLength;
        dir_buffer_len -= kDirectoryEntryLength;
    }
    dir_buffer_ptr[0] = kFieldTerminator; // field terminator after directory, before fields
    fields_buffer_ptr[fields_buffer_len - 1] = kRecordTerminator; // record terminator after last field

    return length - leader.recordLength;
}

#pragma mark -

size_t BibMarcControlFieldGetWriteSize(BibMarcControlField const *const field)
{
    assert(field != NULL);
    if (field == NULL) { return 0; }

    return strlen(field->content) + 1; // [...content...][terminator]
}

size_t BibMarcContentFieldGetWriteSize(BibMarcContentField const *const field)
{
    assert(field != NULL);
    if (field == NULL) { return 0; }

    size_t buffer_size = kNumberOfIndicators; // indicators
    for (size_t index = 0; index < field->subfieldsCount; index += 1)
    {
        BibMarcSubfield const *const subfield = &(field->subfields[index]);
        buffer_size += kLengthOfSubfieldCode + strlen(subfield->content); // [delimiter][code][...content...]
    }
    buffer_size += 1; // field terminator

    return buffer_size;
}

size_t BibMarcRecordGetWriteSize(BibMarcRecord const *const record)
{
    assert(record != NULL);
    if (record == NULL) { return 0; }

    size_t buffer_len = kLeaderLength;
    buffer_len += kDirectoryEntryLength * (record->controlFieldsCount + record->contentFieldsCount);
    buffer_len += 1; // field terminator
    for (size_t index = 0; index < record->controlFieldsCount; index += 1)
    {
        buffer_len += BibMarcControlFieldGetWriteSize(&(record->controlFields[index]));
    }
    for (size_t index = 0; index < record->contentFieldsCount; index += 1)
    {
        buffer_len += BibMarcContentFieldGetWriteSize(&(record->contentFields[index]));
    }
    buffer_len += 1; // record terminator
    return buffer_len;
}

#pragma mark - Cleanup

void BibMarcControlFieldDestroy(BibMarcControlField *const field)
{
    if (field->content != NULL)
    {
        free(field->content);
        field->content = NULL;
    }
}

void BibMarcSubfieldDestroy(BibMarcSubfield *const subfield)
{
    if (subfield->content != NULL)
    {
        free(subfield->content);
        subfield->content = NULL;
    }
}

void BibMarcContentFieldDestroy(BibMarcContentField *const field)
{
    if (field->subfields != NULL)
    {
        size_t const count = field->subfieldsCount;
        BibMarcSubfield *const subfields = field->subfields;
        for (size_t index = 0; index < count; index += 1)
        {
            BibMarcSubfieldDestroy(&(subfields[index]));
        }
        free(field->subfields);
        field->subfields = NULL;
        field->subfieldsCount = 0;
    }
}

void BibMarcRecordDestroy(BibMarcRecord *const record)
{
    if (record->controlFields != NULL)
    {
        size_t const count = record->controlFieldsCount;
        BibMarcControlField *const fields = record->controlFields;
        for (size_t index = 0; index < count; index += 1)
        {
            BibMarcControlFieldDestroy(&(fields[index]));
        }
        free(record->controlFields);
        record->controlFields = NULL;
        record->controlFieldsCount = 0;
    }
    if (record->contentFields != NULL)
    {
        size_t const count = record->contentFieldsCount;
        BibMarcContentField *const fields = record->contentFields;
        for (size_t index = 0; index < count; index += 1)
        {
            BibMarcContentFieldDestroy(&(fields[index]));
        }
        free(record->contentFields);
        record->contentFields = NULL;
        record->contentFieldsCount = 0;
    }
}


#pragma mark - Helpers

size_t BibMarcSizeRead(int8_t const *const buffer, size_t length)
{
    size_t value = 0;
    for (size_t power = 0; power < length; power += 1)
    {
        size_t const index = length - 1 - power;
        int8_t const digit = buffer[index] - '0';
        if (digit < 0 || digit > 9)
        {
            return NSNotFound;
        }
        value += (size_t)digit * (size_t)pow(10, (double)power);
    }
    return value;
}

void BibMarcSizeWrite(size_t value, int8_t *const buffer, size_t const length)
{
    for (size_t index = 0; index < length; index += 1)
    {
        size_t const power = length - 1 - index;
        size_t const divisor = (size_t)pow(10, (double)power);
        size_t const digit = value / divisor;
        buffer[index] = (int8_t)digit + '0';
        value -= digit * divisor;
    }
}
