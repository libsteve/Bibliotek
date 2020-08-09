//
//  BibLCCallNumber+Internal.c
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//
//  See https://www.oclc.org/bibformats/en/0xx/050.html for details about the Library of Congress Call Number format.
//

#include "BibLCCallNumber+Internal.h"

typedef enum bib_lc_calln_segment {
    bib_lc_calln_segment_alphabetic                   = 0,
    bib_lc_calln_segment_whole_number                 = 1,
    bib_lc_calln_segment_decimal_number               = 2,
    bib_lc_calln_segment_date_or_other                = 3,
    bib_lc_calln_segment_first_cutter                 = 4,
    bib_lc_calln_segment_date_or_other_after_cutter   = 5,
    bib_lc_calln_segment_second_cutter                = 6
} bib_lc_calln_segment_t;

static bool bib_consume_blanks(bool one_or_more, char const **str, unsigned long *len);
static bool bib_consume_period(char const **str, unsigned long *len);

#pragma mark -

bool bib_lc_calln_init(bib_lc_calln_t *call_number, char const *const string)
{
    if (call_number == NULL || string == NULL) {
        return false;
    }

    char const *input = string;
    unsigned long length = strlen(string);
    memset(call_number, 0, sizeof(bib_lc_calln_t));

    bool success =                   bib_lc_calln_read_alphabetic_segment   (call_number, &input, &length)
                && ((length == 0) || bib_lc_calln_read_whole_number         (call_number, &input, &length))
                && ((length == 0) || bib_lc_calln_read_decimal_number       (call_number, &input, &length) || true)
                && ((length == 0) || bib_lc_calln_read_date_or_other_number (call_number, &input, &length) || true)
                && ((length == 0) || bib_lc_calln_read_first_cutter_number  (call_number, &input, &length))
                && ((length == 0) || bib_lc_calln_read_number_after_cutter  (call_number, &input, &length) || true)
                && ((length == 0) || bib_lc_calln_read_second_cutter_number (call_number, &input, &length));

    if (success) {
        call_number->remaing_segments = NULL;
        call_number->remaing_segments_length = 0;
        while (length != 0) {
            char *const buffer = alloca(length);
            unsigned long buffer_len = 0;
            unsigned long index = 0;
            bool stop = false;
            while (index < length && !stop) {
                char const c = input[index];
                if (buffer_len == 0) {
                    if (isblank(c)) {
                        index += 1;
                    } else {
                        buffer[buffer_len] = c;
                        buffer_len += 1;
                        index += 1;
                    }
                } else if (isblank(c)) {
                    index += 1;
                    stop = true;
                } else {
                    buffer[buffer_len] = c;
                    buffer_len += 1;
                    index += 1;
                }
            }
            if (buffer_len != 0) {
                size_t const index = call_number->remaing_segments_length;
                call_number->remaing_segments_length += 1;
                call_number->remaing_segments = (call_number->remaing_segments == NULL)
                                              ? calloc(1, sizeof(char *))
                                              : realloc(call_number->remaing_segments,
                                                        call_number->remaing_segments_length * sizeof(char *));
                call_number->remaing_segments[index] = calloc(buffer_len + 1, sizeof(char));
                memcpy(call_number->remaing_segments[index], buffer, buffer_len);
            }
            length -= index;
            input = &(input[index]);
        }
    }
    if (!success) {
        bib_lc_calln_deinit(call_number);
    }
    return success;
}

void bib_lc_calln_deinit(bib_lc_calln_t *call_number)
{
    if (call_number->remaing_segments != NULL) {
        size_t const length = call_number->remaing_segments_length;
        for (size_t index = 0; index < length; index += 1) {
            free(call_number->remaing_segments[index]);
        }
        free(call_number->remaing_segments);
    }
    memset(call_number, 0, sizeof(bib_lc_calln_t));
}

#pragma mark -

bool bib_lc_calln_read_alphabetic_segment(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    return (call_number != NULL)
        && bib_read_lc_calln_alphabetic_segment(call_number->alphabetic_segment, str, len);
}

bool bib_lc_calln_read_whole_number(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    char const *string = *str;
    u_long length = *len;
    bool const success = (call_number != NULL)
                      && bib_consume_blanks(false, &string, &length)
                      && (length != 0)
                      && bib_read_lc_calln_whole_number(call_number->whole_number, &string, &length);
    if (success) {
        *str = string;
        *len = length;
    }
    return success;
}

bool bib_lc_calln_read_decimal_number(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    return (call_number != NULL)
        && bib_read_lc_calln_decimal_number(call_number->decimal_number, str, len);
}

bool bib_lc_calln_read_date_or_other_number(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    char const *string = *str;
    u_long length = *len;
    bool const  success = (call_number != NULL)
                       && bib_consume_blanks(true, &string, &length)
                       && (length != 0)
                       && bib_read_lc_calln_date_or_other_number(call_number->date_or_other_number, &string, &length)
                       && ((length == 0) || bib_consume_blanks(true, &string, &length));
    if (success) {
        *str = string;
        *len = length;
    }
    return success;
}

bool bib_lc_calln_read_first_cutter_number(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    char const *string = *str;
    u_long length = *len;
    bool success = (call_number != NULL)
               && bib_consume_blanks(false, &string, &length)
               && (length != 0)
               && bib_consume_period(&string, &length)
               && (length != 0)
               && bib_read_lc_calln_cutter_number(call_number->first_cutter_number, &string, &length);
    if (success) {
        *str = string;
        *len = length;
    }
    return success;
}

bool bib_lc_calln_read_number_after_cutter(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    char const *string = *str;
    u_long length = *len;
    bool const success = (call_number != NULL)
                      && bib_consume_blanks(true, &string, &length)
                      && (length != 0)
                      && bib_read_lc_calln_date_or_other_number(call_number->date_or_other_number_after_first_cutter,
                                                                &string, &length);
    if (success) {
        *str = string;
        *len = length;
    }
    return success;
}

bool bib_lc_calln_read_second_cutter_number(bib_lc_calln_t *const call_number, char const **const str, u_long *const len)
{
    char const *string = *str;
    u_long length = *len;
    bool const success = (call_number != NULL)
                      && bib_consume_blanks(true, &string, &length)
                      && (length != 0)
                      && bib_read_lc_calln_cutter_number(call_number->second_cutter_number, &string, &length);
    if (success) {
        *str = string;
        *len = length;
    }
    return success;
}

#pragma mark -

bool bib_read_lc_calln_alphabetic_segment(char buffer[alpha_len], char const **const str, unsigned long *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *inbuf = *str;
    u_long inlen = *len;

    bool stop = false;
    size_t bufflen = 0;
    while ((bufflen < alpha_len) && (inlen != 0) && !stop) {
        char const c = inbuf[0];
        if (isalpha(c)) {
            buffer[bufflen] = c;
            bufflen += 1;
            inlen -= 1;
            inbuf += 1;
        } else {
            stop = true;
        }
    }

    bool const success = (bufflen != 0);
    if (success) {
        *len = inlen;
        *str = inbuf;
    }
    return success;
}

bool bib_read_lc_calln_whole_number(char buffer[whole_len], char const **const str, unsigned long *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    u_long const string_length = *len;

    bool stop = false;
    u_long string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < whole_len) && (string_index < string_length) && !stop) {
        char const current_char = string[string_index];
        if (isnumber(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else if (buffer_index == 0) {
            if (isblank(current_char)) {
                string_index += 1;
            } else {
                return false;
            }
        } else {
            stop = true;
            break;
        }
    }

    bool const success = (buffer_index != 0);
    if (success) {
        *len -= string_index;
        *str = &(string[string_index]);
    }
    return success;
}

bool bib_read_lc_calln_decimal_number(char buffer[decml_len], char const **const str, unsigned long *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    u_long const string_length = *len;

    bool stop = false;
    bool found_decimal = false;
    u_long string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < decml_len) && (string_index < string_length) && !stop) {
        char const current_char = string[string_index];
        if (found_decimal) {
            if (isnumber(current_char)) {
                buffer[buffer_index] = current_char;
                buffer_index += 1;
                string_index += 1;
            } else if (buffer_index == 0) {
                return false;
            } else {
                stop = true;
            }
        } else if (current_char == '.') {
            found_decimal = true;
            string_index += 1;
        } else {
            return false;
        }
    }

    bool const success = (buffer_index != 0);
    if (success) {
        *len -= string_index;
        *str = &(string[string_index]);
    }
    return success;
}

bool bib_read_lc_calln_date_or_other_number(char buffer[daten_len], char const **const str, unsigned long *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    u_long const string_length = *len;

    bool stop = false;
    u_long string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < daten_len) && (string_index < string_length) && !stop) {
        char const current_char = string[string_index];
            if (buffer_index == 0) {
                if (isnumber(current_char)) {
                    buffer[buffer_index] = current_char;
                    buffer_index += 1;
                    string_index += 1;
                } else {
                    return false;
                }
            } else if (isalnum(current_char)) {
                buffer[buffer_index] = current_char;
                buffer_index += 1;
                string_index += 1;
            } else {
                stop = true;
            }
    }

    bool const success = (buffer_index != 0);
    if (success) {
        *len -= string_index;
        *str = &(string[string_index]);
    }
    return success;
}

bool bib_read_lc_calln_cutter_number(char buffer[cuttr_len], char const **const str, unsigned long *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    u_long const string_length = *len;

    bool stop = false;
    u_long string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < cuttr_len) && (string_index < string_length) && !stop) {
        char const current_char = string[string_index];
        if (buffer_index == 0) {
            if (isalpha(current_char)) {
                buffer[buffer_index] = toupper(current_char);
                buffer_index += 1;
                string_index += 1;
            } else {
                return false;
            }
        } else if (isnumber(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            stop = true;
        }
    }

    bool const success = (buffer_index != 0);
    if (success) {
        *len -= string_index;
        *str = &(string[string_index]);
    }
    return success;
}

#pragma mark -

bool bib_consume_blanks(bool const one_or_more, char const **const str, unsigned long *const len)
{
    if (str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    u_long const string_length = *len;

    bool stop = false;
    u_long string_index = 0;
    while ((string_index < string_length) && !stop) {
        char current_char = string[string_index];
        if (isblank(current_char)) {
            string_index += 1;
        } else {
            stop = true;
        }
    }

    bool const success = (!one_or_more) || (string_index != 0);
    if (success) {
        *str = &(string[string_index]);
        *len -= string_index;
    }
    return success;
}

static bool bib_consume_period(char const **const str, unsigned long *const len)
{
    if (str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    bool const success = (string[0] == '.');
    if (success) {
        *str = &(string[1]);
        *len -= 1;
    }
    return success;
}
