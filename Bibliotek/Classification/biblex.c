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

bib_strbuf_t bib_strbuf(char const *const str, size_t const len)
{
    return (bib_strbuf_t){
        .str = str,
        .len = (str == NULL) ? 0
             : (len == 0) ? strlen(str) + 1
             : 0
    };
}

bool bib_advance_strbuf(bib_strbuf_t *const volatile lexer, bib_strbuf_t const *const volatile update)
{
    if (lexer == NULL || update == NULL) {
        return false;
    }
    return bib_advance_step(lexer->len - update->len, &(lexer->str), &(lexer->len));
}

#pragma mark - lex

bool bib_lex_integer(bib_digit06_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;
    size_t length = bib_lex_digit_n(buffer, sizeof(bib_digit06_b), &l);
    return (length > 0) && bib_advance_step(length, &(lexer->str), &(lexer->len));
}

bool bib_lex_digit16(bib_digit16_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;
    size_t length = bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &l);
    return (length > 0) && bib_advance_step(length, &(lexer->str), &(lexer->len));
}

bool bib_lex_decimal(bib_digit16_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;
    bool success = bib_read_point(&l)
                && bib_lex_digit16(buffer, &l)
                && bib_advance_strbuf(lexer, &l);
    if (!success) {
        memset(buffer, 0, sizeof(bib_digit16_b));
    }
    return success;
}

bool bib_lex_year(bib_year_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;
    size_t length = bib_lex_digit_n(buffer, sizeof(bib_year_b), &l);
    bool success = (length == 4) && bib_advance_strbuf(lexer, &l);
    if (!success) {
        memset(buffer, 0, sizeof(bib_year_b));
    }
    return success;
}

bool bib_lex_year_abv(bib_year_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;
    size_t length = bib_lex_digit_n(buffer, sizeof(char) * 3, &l);
    bool success = (length == 2) && bib_advance_strbuf(lexer, &l);
    if (!success) {
        memset(buffer, 0, sizeof(bib_year_b));
    }
    return success;
}

bool bib_lex_mark(bib_mark_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l0 = *lexer;
    bool alpha_success = bib_lex_alpha_n(buffer, sizeof(bib_mark_b), &l0);

    bib_strbuf_t l1 = l0;
    bool break_success = alpha_success && (bib_read_space(&l1) || bib_peek_break(&l1));

    bool success = alpha_success && break_success && bib_advance_strbuf(lexer, &l0);
    if (!success) {
        memset(buffer, 0, sizeof(bib_mark_b));
    }
    return success;
}

bool bib_lex_subclass(bib_alpah03_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;

    size_t string_index = 0;
    size_t buffer_index = 0;
    static size_t const max_buffer_index = sizeof(bib_alpah03_b) - sizeof(char);
    while ((buffer_index < max_buffer_index) && (string_index < l.len)) {
        const char current_char = l.str[string_index];
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
    bool success = bib_advance_step(buffer_index, &(lexer->str), &(lexer->len));
    if (!success) {
        memset(buffer, 0, sizeof(bib_alpah03_b));
    }

    return success;
}

bool bib_lex_initial(bib_initial_t *initial, bib_strbuf_t *const lexer)
{
    if (initial == NULL) {
        return false;
    }

#ifdef BIB_LEX_AUTO_UPPERCASE
    bool success = bib_read_char(initial, bib_isalpha, lexer);
    if (success && islower(*initial)) {
        *initial = toupper(*initial);
    }
    return success;
#else
    return bib_read_char(initial, bib_isupper, lexer);
#endif
}

bool bib_lex_cutter_ordinal_suffix(bib_word_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }

    bib_strbuf_t l0 = *lexer;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &l0);
    bool alpha_success = (alphalen > 0);

    bib_strbuf_t l1 = l0;
    bool break_success = alpha_success && bib_peek_break(&l1);
    bool point_success = alpha_success && bib_read_point(&l1);

    bool success = !point_success && break_success && bib_advance_strbuf(lexer, &l0);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_caption_ordinal_suffix(bib_word_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }

    bib_strbuf_t l0 = *lexer;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &l0);
    bool alpha_success = (alphalen > 0);

    bib_strbuf_t l1 = l0;
    bool space_success = alpha_success && bib_read_space(&l1);
    bool point_success = alpha_success && bib_read_point(&l1);
    bool blank_success = alpha_success && !space_success && !point_success && bib_peek_break(&l1);

    bool success = (space_success || point_success || blank_success) && bib_advance_strbuf(lexer, &l0);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_specification_ordinal_suffix(bib_word_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }

    bib_strbuf_t l0 = *lexer;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);
    memset(buffer, 0, sizeof(bib_word_b));

    size_t alphalen = bib_lex_alpha_n(outbuf0, outlen0, &l0);
    bool alpha_success = (alphalen > 0) && bib_advance_step(alphalen, (char const **)&outbuf0, &outlen0);

    bool stop = false;
    bool needs_point = true;
    bool success = alpha_success;
    while ((l0.len > 0) && (outlen0 > 1) && success && !stop) {
        bib_strbuf_t l1 = l0;
        char  *outbuf1 = outbuf0;
        size_t outlen1 = outlen0;

        if (!needs_point && bib_read_space(&l1)) {
            success = true;
            stop = true;
            l0 = l1;
            break;
        }
        bool point_success = bib_read_point(&l1);
        if (needs_point && !point_success) {
            success = false;
            stop = true;
            break;
        }
        if (point_success) {
            outbuf1[0] = '.';
            bib_advance_step(1, (char const **)&outbuf1, &outlen1);
        }

        bib_strbuf_t l2 = l1;
        char  *outbuf2 = outbuf1;
        size_t outlen2 = outlen1;
        size_t alphalen = bib_lex_alpha_n(outbuf2, outlen2, &l2);
        bool alpha_success = (alphalen > 0) && bib_advance_step(alphalen, (char const **)&outbuf2, &outlen2);

        bib_strbuf_t l3 = (alpha_success) ? l2 : l1;
        if (alpha_success) {
            needs_point = true;
            outbuf0 = outbuf2;
            outlen0 = outlen2;
            l0 = l3;
            continue;
        } else if (point_success) {
            needs_point = false;
            if (bib_peek_break(&l2)) {
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
                l0 = l3;
            }
            continue;
        } else {
            stop = true;
            success = false;
            break;
        }
    }

    bool final_success = success && bib_advance_strbuf(lexer, &l0);
    if (!final_success) {
        memset(buffer, 0, sizeof(bib_word_b));
    }
    return final_success;
}

bool bib_lex_volume_prefix(bib_word_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }

    bib_strbuf_t l0 = *lexer;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);

    size_t alphalen = bib_lex_char_n(outbuf0, outlen0, bib_islower, &l0);
    bool alpha_success = (alphalen > 0);

    bib_strbuf_t l1 = l0;
    bool point_success = alpha_success && bib_read_point(&l1);

    bool success = point_success && bib_advance_strbuf(lexer, &l1);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_supplement_prefix(bib_word_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l0 = *lexer;
    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_word_b);
    bool success = bib_read_char(buffer, bib_isupper, &l0)
                && bib_advance_step(1, (char const **)&outbuf0, &outlen0);
    if (success) {
        bib_strbuf_t l1 = l0;
        char  *outbuf1 = outbuf0;
        size_t outlen1 = outlen0;
        size_t length = bib_lex_char_n(outbuf1, outlen1, bib_islower, &l1);
        if (bib_advance_step(length, (char const **)&outbuf1, &outlen1)) {
            outbuf0 = outbuf1;
            outlen0 = outlen1;
            l0 = l1;
        }
    }
    success = success && bib_advance_strbuf(lexer, &l0);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

bool bib_lex_longword(bib_longword_b buffer, bib_strbuf_t *const lexer)
{
    if (buffer == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }

    bib_strbuf_t l = *lexer;

    char  *outbuf0 = buffer;
    size_t outlen0 = sizeof(bib_longword_b);

    size_t wordlen = bib_lex_char_n(outbuf0, outlen0, bib_notspace, &l);
    bool word_success = (wordlen > 0);

    bool success = word_success && bib_advance_strbuf(lexer, &l);
    if (!success) {
        memset(buffer, 0, outlen0);
    }
    return success;
}

#pragma mark - lex primitives

size_t bib_lex_digit_n(char *const buffer, size_t const buffer_len, bib_strbuf_t *const lexer)
{
    return bib_lex_char_n(buffer, buffer_len, bib_isnumber, lexer);
}

size_t bib_lex_alpha_n(char *const buffer, size_t const buffer_len, bib_strbuf_t *const lexer)
{
    return bib_lex_char_n(buffer, buffer_len, bib_isalpha, lexer);
}

size_t bib_lex_char_n(char *const buffer, size_t const buffer_len, bool (*const pred)(char),
                      bib_strbuf_t *const lexer)
{
    if (buffer == NULL || buffer_len < 1 || pred == NULL || lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;

    size_t string_index = 0;
    size_t buffer_index = 0;
    size_t const buffer_max_index = buffer_len - 1;
    while ((buffer_index < buffer_max_index) && (string_index < l.len)) {
        const char current_char = l.str[string_index];
        if (pred(current_char)) {
            buffer[buffer_index] = current_char;
            buffer_index += 1;
            string_index += 1;
        } else {
            break;
        }
    }
    bool success = bib_advance_step(buffer_index, &(lexer->str), &(lexer->len));
    if (!success) {
        memset(buffer, 0, buffer_len);
    }
    return (success) ? buffer_index : 0;
}

#pragma mark - read

bool bib_read_space(bib_strbuf_t *const lexer)
{
    if (lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;

    bool stop = false;
    size_t string_index = 0;
    while ((string_index < l.len) && !stop) {
        char current_char = l.str[string_index];
        if (isspace(current_char)) {
            string_index += 1;
        } else {
            stop = true;
        }
    }
    return bib_advance_step(string_index, &(lexer->str), &(lexer->len));
}

bool bib_read_point(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_ispoint, lexer);
}

bool bib_read_dash(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_isdash, lexer);
}

bool bib_read_slash(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_isslash, lexer);
}

bool bib_read_etc(bib_strbuf_t *const lexer)
{
    if (lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    bib_strbuf_t l = *lexer;
    char word[4] = { 0, 0, 0, 0 };
    bool comma_success = bib_read_char(NULL, bib_iscomma, &l);
    bool space_success = comma_success && bib_read_space(&l);
    bool  word_success = false;
    if (space_success) {
        size_t length = bib_lex_char_n(word, sizeof(word), bib_islower, &l);
        word_success = (length > 0) && (strcmp(word, "etc") == 0);
    }
    bool point_success = word_success && bib_read_point(&l);
    return point_success && bib_advance_strbuf(lexer, &l);
}

bool bib_read_comma(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_iscomma, lexer);
}

bool bib_read_colon(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_iscolon, lexer);
}

bool bib_read_openangle(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_isopenangle, lexer);
}

bool bib_read_closeangle(bib_strbuf_t *const lexer)
{
    return bib_read_char(NULL, bib_iscloseangle, lexer);
}


#pragma mark - read primitives

bool bib_read_char(char *const c, bool (*const pred)(char), bib_strbuf_t *const lexer)
{
    if (lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    char v = '\0';
    bool success = bib_peek_char(&v, pred, lexer) && bib_advance_step(1, &(lexer->str), &(lexer->len));
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

bool bib_isspace(char c) {
    return isspace(c);
}

bool bib_notspace(char c) {
    return !isspace(c) && (c != '\0');
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

bool bib_iscomma(char c)
{
    return c == ',';
}

bool bib_iscolon(char c)
{
    return c == ':';
}

bool bib_isopenangle(char c)
{
    return c == '<';
}

bool bib_iscloseangle(char c)
{
    return c == '>';
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

bool bib_peek_char(char *const c, bib_cpred_f const pred, bib_strbuf_t const *const lexer)
{
    if (lexer == NULL || lexer->str == NULL || lexer->len == 0) {
        return false;
    }
    char v = lexer->str[0];
    bool success = (pred == NULL) || pred(v);
    if (success && c != NULL) {
        *c = v;
    }
    return success;
}

bool bib_peek_break(bib_strbuf_t const *const lexer)
{
    if (lexer == NULL || lexer->str == NULL) { return false; }
    if (lexer->len == 0) { return true; }

    bib_strbuf_t l = *lexer;
    if (bib_read_space(&l)) {
        return true;
    }
    char c = '\0';
    return bib_read_char(&c, bib_isstop, &l);
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
