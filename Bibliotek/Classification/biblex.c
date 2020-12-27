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
#include <assert.h>
#include <stddef.h>
#include <stdio.h>

/// The presence of this macro causes lowercase letters in the subject and cutters to
/// autocorrect to their uppercase value instead of failing the lex/parse.
#define BIB_LEX_AUTO_UPPERCASE

#pragma mark - lex

bool bib_lex_integer(bib_digit04_b buffer, char const **const str, size_t *const len)
{
    size_t length = bib_lex_digit_n(buffer, bib_integer_size, str, len);
    return (length > 0);
}

bool bib_lex_digit16(bib_digit16_b buffer, char const **const str, size_t *const len)
{
    size_t length = bib_lex_digit_n(buffer, bib_digit16_size, str, len);
    return (length > 0);
}

bool bib_lex_decimal(bib_digit16_b buffer, char const **const str, size_t *const len)
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

bool bib_lex_year(bib_year_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *str_0 = *str;
    size_t      len_0 = *len;
    size_t length = bib_lex_digit_n(buffer, bib_datenum_size, &str_0, &len_0);
    return (length == 4) && bib_advance_step(*len - len_0, str, len);
}

bool bib_lex_year_abv(bib_year_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *str_0 = *str;
    size_t      len_0 = *len;
    size_t length = bib_lex_digit_n(buffer, 3, &str_0, &len_0);
    return (length == 2) && bib_advance_step(*len - len_0, str, len);
}

bool bib_lex_mark(bib_mark_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool alpha_success = bib_lex_alpha_n(buffer, sizeof(bib_mark_b), &str_0, &len_0);

    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool break_success = alpha_success && (bib_read_space(&str_1, &len_1) || bib_peek_break(str_1, len_1));

    bool success = alpha_success && break_success && bib_advance_step(*len - len_0, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(bib_mark_b));
    }
    return success;
}

bool bib_lex_subclass(bib_alpah03_b buffer, char const **const str, size_t *const len)
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
#ifdef BIB_LEX_AUTO_UPPERCASE
        } else if (islower(current_char)) {
            buffer[buffer_index] = toupper(current_char);
            buffer_index += 1;
            string_index += 1;
#endif
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

bool bib_lex_initial(bib_initial_t *initial, char const **str, size_t *len)
{
    if (initial == NULL) {
        return false;
    }

#ifdef BIB_LEX_AUTO_UPPERCASE
    bool success = bib_read_char(initial, bib_isalpha, str, len);
    if (success && islower(*initial)) {
        *initial = toupper(*initial);
    }
    return success;
#else
    return bib_read_char(initial, bib_isupper, str, len);
#endif
}

bool bib_lex_cutter_ordinal_suffix(bib_word_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str0 = *str;
    size_t      len0 = *len;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &str0, &len0);
    bool alpha_success = (alphalen > 0);

    char const *str1 = str0;
    size_t      len1 = len0;
    bool break_success = alpha_success && bib_peek_break(str1, len1);
    bool point_success = alpha_success && bib_read_point(&str1, &len1);

    bool success = !point_success && break_success && bib_advance_step(*len - len0, str, len);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_caption_ordinal_suffix(bib_word_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str0 = *str;
    size_t      len0 = *len;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &str0, &len0);
    bool alpha_success = (alphalen > 0);

    char const *str1 = str0;
    size_t      len1 = len0;
    bool space_success = alpha_success && bib_read_space(&str1, &len1);
    bool point_success = alpha_success && bib_read_point(&str1, &len1);
    bool blank_success = alpha_success && !space_success && !point_success && bib_peek_break(str1, len1);

    bool success = (space_success || point_success || blank_success) && bib_advance_step(*len - len0, str, len);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_specification_ordinal_suffix(bib_word_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str0 = *str;
    size_t      len0 = *len;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);
    memset(buffer, 0, sizeof(bib_word_b));

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &str0, &len0);
    bool alpha_success = (alphalen > 0) && bib_advance_step(alphalen, (char const **)&outbuf0, &outlen0);

    bool stop = false;
    bool needs_point = false;
    bool success = alpha_success;
    while ((len0 > 0) && (outlen0 > 1) && success && !stop) {
        char const *str1 = str0;
        size_t      len1 = len0;
        char  *outbuf1 = outbuf0;
        size_t outlen1 = outlen0;

        if (!needs_point && bib_read_space(&str1, &len1)) {
            success = true;
            stop = true;
            str0 = str1;
            len0 = len1;
            break;
        }
        bool point_success = bib_read_point(&str1, &len1);
        if (needs_point && !point_success) {
            success = false;
            stop = true;
            break;
        }
        if (point_success) {
            outbuf1[0] = '.';
            bib_advance_step(1, (char const **)&outbuf1, &outlen1);
        }

        char const *str2 = str1;
        size_t      len2 = len1;
        char  *outbuf2 = outbuf1;
        size_t outlen2 = outlen1;
        size_t alphalen = bib_lex_alpha_n(outbuf2, outlen2, &str2, &len2);
        bool alpha_success = (alphalen > 0) && bib_advance_step(alphalen, (char const **)&outbuf2, &outlen2);

        char const *str3 = (alpha_success) ? str2 : str1;
        size_t      len3 = (alpha_success) ? len2 : len1;
        if (alpha_success) {
            needs_point = true;
            outbuf0 = outbuf2;
            outlen0 = outlen2;
            str0 = str3;
            len0 = len3;
            continue;
        } else if (point_success) {
            needs_point = false;
            if (bib_peek_break(str2, len2)) {
                success = true;
                stop = true;
            } else {
                // trailing word-break required
                success = false;
                stop = true;
                break;
            }
            if (success) {
                outbuf0 = outbuf2;
                outlen0 = outlen2;
                str0 = str3;
                len0 = len3;
            }
            continue;
        } else {
            stop = true;
            success = false;
            break;
        }
    }

    bool final_success = success && bib_advance_step(*len - len0, str, len);
    if (!final_success) {
        memset(buffer, 0, sizeof(bib_word_b));
    }
    return final_success;
}

bool bib_lex_volume_prefix(bib_word_b buffer, char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str0 = *str;
    size_t      len0 = *len;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &str0, &len0);
    bool alpha_success = (alphalen > 0);

    char const *str1 = str0;
    size_t      len1 = len0;
    bool point_success = alpha_success && bib_read_point(&str1, &len1);

    bool success = point_success && bib_advance_step(*len - len1, str, len);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_longword(bib_longword_b buffer, char const **str, size_t *len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str0 = *str;
    size_t      len0 = *len;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_longword_b);

    size_t wordlen = bib_lex_char_n(outbuf0, outlen0, bib_notspace, &str0, &len0);
    bool word_success = (wordlen > 0);

    bool success = word_success && bib_advance_step(*len - len0, str, len);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

#pragma mark - lex primitives

size_t bib_lex_digit_n(char *const buffer, size_t const buffer_len, char const **const str, size_t *const len)
{
    return bib_lex_char_n(buffer, buffer_len, bib_isnumber, str, len);
}

size_t bib_lex_alpha_n(char *const buffer, size_t const buffer_len, char const **const str, size_t *const len)
{
    return bib_lex_char_n(buffer, buffer_len, bib_isalpha, str, len);
}

size_t bib_lex_char_n(char *const buffer, size_t const buffer_len, bool (*const pred)(char),
                      char const **const str, size_t *const len)
{
    if (buffer == NULL || buffer_len < 1 || pred == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *const string = *str;
    size_t const string_length = *len;

    size_t string_index = 0;
    size_t buffer_index = 0;
    while ((buffer_index < buffer_len) && (string_index < string_length)) {
        const char current_char = string[string_index];
        if (pred(current_char)) {
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
    return bib_read_char(NULL, bib_ispoint, str, len);
}

bool bib_read_dash(char const **str, size_t *len)
{
    return bib_read_char(NULL, bib_isdash, str, len);
}

bool bib_read_slash(char const **str, size_t *len)
{
    return bib_read_char(NULL, bib_isslash, str, len);
}

#pragma mark - read primitives

bool bib_read_char(char *const c, bool (*const pred)(char), char const **const str, size_t *const len)
{
    if (str == NULL || len == NULL) {
        return false;
    }
    char v = '\0';
    bool success = bib_peek_char(&v, pred, *str, *len) && bib_advance_step(1, str, len);
    if (success && c != NULL) {
        *c = v;
    }
    return success;
}

#pragma mark - character predicates

bool bib_isalpha(char c) {
    return isalpha(c);
}

bool bib_isupper(char c) {
    return isupper(c);
}

bool bib_islower(char c) {
    return islower(c);
}

bool bib_isnumber(char c) {
    return isnumber(c);
}

bool bib_notspace(char c) {
    return !isspace(c);
}

bool bib_ispoint(char c) {
    return c == '.';
}

bool bib_isdash(char c) {
    return c == '-';
}

bool bib_isslash(char c) {
    return c == '/';
}

bool bib_isstop(char c) {
    switch (c) {
    case '\0': // null terminator
    case  EOF: // end of file
    case 0x03: // end of text
    case 0x1C: // file separator
    case 0x1D: // group separator
    case 0x1E: // record separator
    case 0x1F: // unit separator
        return true;
    default:
        return false;
    }
}

#pragma mark - peek

bool bib_peek_char(char *const c, bib_cpred_f const pred, char const *const str, size_t const len)
{
    if (str == NULL || len == 0) {
        return false;
    }
    char v = str[0];
    bool success = (pred == NULL) || pred(v);
    if (success && c != NULL) {
        *c = v;
    }
    return success;
}

bool bib_peek_break(char const *const str, size_t const len)
{
    if (str == NULL) { return false; }
    if (len == 0) { return true; }

    char const *str_0 = str;
    size_t      len_0 = len;
    if (bib_read_space(&str_0, &len_0)) {
        return true;
    }
    char c = '\0';
    return bib_read_char(&c, bib_isstop, &str_0, &len_0);
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
