//
//  biblex.c
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#include "biblex.h"
#include <ctype.h>
#include <string.h>

#pragma mark - lex

bool bib_lex_integer(char buffer[bib_integer_size + 1], char const **const str, size_t *const len)
{
    size_t length = bib_lex_digit_n(buffer, bib_integer_size, str, len);
    buffer[length] = '\0';
    return (length > 0);
}

bool bib_lex_digit16(char buffer[bib_digit16_size + 1], char const **const str, size_t *const len)
{
    size_t length = bib_lex_digit_n(buffer, bib_digit16_size, str, len);
    buffer[length] = '\0';
    return (length > 0);
}

bool bib_lex_decimal(char buffer[bib_digit16_size + 1], char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t string_length = *len;
    bool success = bib_read_point(&string, &string_length)
                && bib_lex_digit16(buffer, &string, &string_length)
                && bib_advance_step(*len - string_length, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * (bib_digit16_size + 1));
    }
    return success;
}

bool bib_lex_suffix(char buffer[bib_suffix_size  + 1], char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t string_length = *len;

    size_t string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < bib_suffix_size) && (string_index < string_length)) {
        const char current_char = string[string_index];
        if (islower(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            break;
        }
    }
    buffer[buffer_index] = '\0';
    return bib_advance_step(buffer_index, str, len);
}

bool bib_lex_date(char buffer[bib_datenum_size + 1], char const **const str, size_t *const len)
{
    size_t length = bib_lex_digit_n(buffer, bib_datenum_size, str, len);
    buffer[length] = '\0';
    return (length > 0);
    /*
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    size_t const string_length = *len;
    static size_t const buffer_len = bib_datenum_size + 1;

    size_t string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < bib_datenum_size) && (string_index < string_length)) {
        const char current_char = string[string_index];
        if (isnumber(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            break;
        }
    }
    bool success = (buffer_index == bib_datenum_size) && bib_advance_step(buffer_index, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * buffer_len);
    } else {
        buffer[buffer_index] = '\0';
    }
    return success;
     */
}

bool bib_lex_cutter(char buffer[bib_cuttern_size + 1], char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t string_length = *len;

    if (isupper(string[0])) {
        buffer[0] = string[0];
        string = &(string[1]);
        string_length -= 1;
        buffer[1] = '\0';
    } else {
        return false;
    }

    size_t digit_length = bib_lex_digit_n(&(buffer[1]), bib_cuttern_size - 1, &string, &string_length);
    buffer[digit_length + 1] = '\0';
    bool success = bib_advance_step(*len - string_length, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * (bib_cuttern_size + 1));
    }
    return success;
}

bool bib_lex_subclass(char buffer[bib_lcalpha_size + 1], char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t string_length = *len;

    size_t string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < bib_lcalpha_size) && (string_index < string_length)) {
        const char current_char = string[string_index];
        if (isupper(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            break;
        }
    }
    buffer[buffer_index] = '\0';
    bool success = bib_advance_step(buffer_index, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * (bib_lcalpha_size + 1));
    }
    return success;
}

bool bib_lex_workmark(char buffer[bib_suffix_size  + 1], char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t string_length = *len;

    size_t string_index = 0;
    size_t buffer_index = 0;
    char current_char = string[string_index];
    if (isupper(current_char)) {
        buffer[buffer_index] = current_char;
        buffer_index += 1;
        string_index += 1;
    } else {
        return false;
    }
    while ((buffer_index < bib_suffix_size) && (string_index < string_length)) {
        current_char = string[string_index];
        if (islower(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            break;
        }
    }
    buffer[buffer_index] = '\0';
    bool success = (buffer_index > 1) && bib_advance_step(buffer_index, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * (bib_suffix_size + 1));
    }
    return success;
}

size_t bib_lex_digit_n(char *const buffer, size_t const buffer_len, char const **const str, size_t *const len)
{
    if (buffer == NULL || buffer_len < 1 || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    size_t const string_length = *len;

    size_t string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < buffer_len) && (string_index < string_length)) {
        const char current_char = string[string_index];
        if (isnumber(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            break;
        }
    }
    bool success = bib_advance_step(buffer_index, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * buffer_len);
    }
    return (success) ? buffer_index : 0;
}

#pragma mark - read

bool bib_read_space(char const **const str, size_t *const len)
{
    if (str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    size_t const string_length = *len;

    bool stop = false;
    size_t string_index = 0;
    while ((string_index < string_length) && !stop) {
        char current_char = string[string_index];
        if (isspace(current_char)) {
            string_index += 1;
        } else {
            stop = true;
        }
    }
    return bib_advance_step(string_index, str, len);
}

bool bib_read_point(char const **const str, size_t *const len)
{
    if (str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    return ((*str)[0] == '.') ? bib_advance_step(1, str, len) : false;
}

bool bib_read_dash(char const **str, size_t *len)
{
    if (str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    return ((*str)[0] == '-') ? bib_advance_step(1, str, len) : false;
}

#pragma mark - advance

bool bib_advance_step(size_t const step, char const **const str, size_t *const len)
{
    if (str == NULL || *str == NULL || len == NULL || *len == 0 || step <= 0) {
        return false;
    }
    if (step < *len) {
        *str = &((*str)[step]);
        *len -= step;
    }
    return true;
}
