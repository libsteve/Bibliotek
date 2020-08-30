//
//  bibparse.c
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#include "bibparse.h"
#include "biblex.h"
#include <string.h>

#pragma mark - cutter

bool bib_parse_cutter(bib_cutter_t *const cut, char const **const str, size_t *const len)
{
    return bib_lex_cutter(cut->number, str, len);
}

#pragma mark - lc call number

bool bib_parse_lc_callnum(bib_lc_callnum_t *const num, char const **const str, size_t *const len)
{
    if (num == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t      length = *len;

    bool base_success  = bib_parse_lc_callnum_base(num, &string, &length);
    bool __unused _    = base_success && bib_parse_lc_callnum_shelf(num, &string, &length);

    bool success = base_success && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(num, 0, sizeof(bib_lc_callnum_t));
    }
    return success;
}

bool bib_parse_lc_callnum_base(bib_lc_callnum_t *const num, char const **const str, size_t *const len)
{
    if (num == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *str_0 = *str;
    size_t      len_0 = *len;

    bool caption_success = bib_parse_lc_caption(&(num->caption), &str_0, &len_0);

    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool period_success = caption_success && bib_read_point(&str_1, &len_1);
    bool cutter_success = period_success  && bib_parse_lc_cutter(num->cutters, &str_1, &len_1);

    size_t final_length = (cutter_success) ? len_1 : len_0;
    bool success = caption_success && bib_advance_step(*len - final_length, str, len);
    if (!success) {
        memset(&(num->caption),    0, sizeof(num->caption));
        memset(&(num->cutters[0]), 0, sizeof(num->cutters[0]));
    }
    return success;
}

bool bib_parse_lc_callnum_shelf(bib_lc_callnum_t *num, char const **str, size_t *len)
{
    // TODO: parse shelf
    return false;
}

#pragma mark - lc caption

bool bib_parse_lc_caption(bib_lc_caption_t *const cap, char const **const str, size_t *const len)
{
    if (cap == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string_0 = *str;
    size_t      length_0 = *len;

    bool root_success = bib_parse_lc_caption_root(cap, &string_0, &length_0);

    char const *string_1 = string_0;
    size_t      length_1 = length_0;
    bool date_success = root_success
                     && bib_read_space(&string_1, &length_1)
                     && bib_lex_date(cap->date, &string_1, &length_1);

    char const *string_2 = (date_success) ? string_1 : string_0;
    size_t      length_2 = (date_success) ? length_1 : length_0;
    bool ordn_success = root_success
                     && bib_read_space(&string_2, &length_2)
                     && bib_parse_lc_caption_ordinal(&(cap->ordinal), &string_2, &length_2);

    size_t final_length = (ordn_success) ? length_2 : length_1;
    bool success = root_success && bib_advance_step(*len - final_length, str, len);
    if (!success) {
        memset(cap, 0, sizeof(bib_lc_caption_t));
    }
    return success;
}

bool bib_parse_lc_caption_root(bib_lc_caption_t *const cap, char const **const str, size_t *const len)
{
    if (cap == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t length = *len;

    bool cls_success = bib_lex_subclass(cap->letters, &string, &length);
    bib_read_space(&string, &length); // optional space
    bool int_success = cls_success && bib_lex_integer(cap->integer, &string, &length);
    bool __unused _  = int_success && bib_lex_integer(cap->decimal, &string, &length);

    bool success = cls_success && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(cap, 0, sizeof(bib_lc_caption_t));
    }
    return success;
}

bool bib_parse_lc_caption_ordinal_suffix(char buffer[bib_suffix_size + 2], char const **const str, size_t *const len)
{
    if (buffer == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t      length = *len;

    bool suffix_success = bib_lex_suffix(buffer, &string, &length);
    bool point_success  = suffix_success && bib_read_point(&string, &length);
    bool __unused _     = point_success  && bib_read_space(&string, &length);

    if (point_success) {
        size_t last_index = strlen(buffer);
        buffer[last_index    ] = '.';
        buffer[last_index + 1] = '\0';
    }

    bool success = suffix_success && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(buffer, 0, sizeof(char) * (bib_suffix_size + 2));
    }
    return success;
}

bool bib_parse_lc_caption_ordinal(bib_ordinal_t *ord, char const **const str, size_t *const len)
{
    if (ord == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t      length = *len;

    bool number_success = bib_lex_digit16(ord->number, &string, &length);
    bool space_success  = number_success && bib_read_space(&string, &length);
    bool suffix_success = bib_parse_lc_caption_ordinal_suffix(ord->suffix, &string, &length);

    bool success = (suffix_success || (number_success && space_success))
                && bib_advance_step(*len - length, str, len);
    if (!success)  {
        memset(ord, 0, sizeof(bib_ordinal_t));
    }
    return success;
}

#pragma mark - lc cutter

bool bib_parse_lc_cutter(bib_cutter_t cutters[3], char const **const str, size_t *const len)
{
    if (cutters == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    bib_cutter_t  *cut_0 = &(cutters[0]);
    bib_cutter_t  *cut_1 = &(cutters[1]);
    bib_cutter_t  *cut_2 = &(cutters[2]);

    char const    *str_0 = *str;
    size_t         len_0 = *len;
    bool point_success_0 = bib_read_point(&str_0, &len_0);
    bool  date_success_0 = point_success_0 && bib_parse_lc_dated_cutter(cut_0, &str_0, &len_0);
    bool  cutt_success_0 = !date_success_0 && point_success_0 && bib_parse_cutter(cut_0, &str_0, &len_0);
    bool parse_success_0 =  date_success_0 || cutt_success_0;

    char const    *str_1 = (parse_success_0) ? str_0 : *str;
    size_t         len_1 = (parse_success_0) ? len_0 : *len;
    bool      __unused _ =  parse_success_0 && (bib_read_space(&str_1, &len_1) || cutt_success_0);
    bool  date_success_1 =  parse_success_0 &&  bib_parse_lc_dated_cutter(cut_1, &str_1, &len_1);
    bool  cutt_success_1 =  parse_success_0 && !date_success_1 && bib_parse_cutter(cut_1, &str_1, &len_1);
    bool parse_success_1 =   date_success_1 ||  cutt_success_1;

    char const    *str_2 = (parse_success_1) ? str_1 : str_0;
    size_t         len_2 = (parse_success_1) ? len_1 : len_0;
    bool     __unused __ =  parse_success_1 && (bib_read_space(&str_2, &len_2) || cutt_success_1);
    bool  date_success_2 =  parse_success_1 &&  bib_parse_lc_dated_cutter(cut_2, &str_2, &len_2);
    bool  cutt_success_2 =  parse_success_1 && !date_success_2 && bib_parse_cutter(cut_2, &str_2, &len_2);
    bool parse_success_2 =   date_success_2 ||  cutt_success_2;

    size_t  final_length = (parse_success_2) ? len_2 : len_1;
    bool         success =  parse_success_0 && bib_advance_step(*len - final_length, str, len);
    return success;
}

bool bib_parse_lc_dated_cutter(bib_cutter_t *cut, char const **const str, size_t *const len)
{
    if (cut == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t      length = *len;

    bool success = bib_lex_cutter(cut->number, &string, &length)
                && bib_read_space(&string, &length)
                && bib_lex_cutter(cut->date, &string, &length)
                && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(cut, 0, sizeof(bib_cutter_t));
    }
    return success;
}

#pragma mark - lc special

bool bib_parse_lc_special(bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len)
{
    // TODO: parse special
    return false;
}

bool bib_parse_lc_special_date   (bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len)
{
    // TODO: parse special date
    return false;
}

bool bib_parse_lc_special_ordinal(bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len)
{
    if (spc_list == NULL || spc_size == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    if (spc_list == NULL && *spc_size != 0) {
        return false;
    }
    bool finished = false;
    size_t ordinals_count = 0;
    bib_ordinal_t *ordinals = NULL;

    char const *prev_string = *str;
    size_t      prev_length = *len;
    char const *curr_string = *str;
    size_t      curr_length = *len;
    while (!finished) {
        size_t index = ordinals_count;
        if (index > 0) {
            bib_read_space(&curr_string, &curr_length);
        }
        bib_ordinal_t current;
        memset(&current, 0, sizeof(bib_ordinal_t));
        if (bib_parse_lc_special_ordinal_root(&current, &curr_string, &curr_length)) {
            prev_string = curr_string;
            prev_length = curr_length;
            ordinals_count += 1;
            ordinals = (ordinals)
                     ? realloc(ordinals, ordinals_count * sizeof(bib_ordinal_t))
                     : calloc(ordinals_count, sizeof(bib_ordinal_t));
            ordinals[index] = current;
        } else {
            finished = true;
        }
    }

    bool success = (ordinals != NULL) && (ordinals_count > 0) && bib_advance_step(*len - prev_length, str, len);
    if (success) {
        bib_lc_special_t spc_ordinals[ordinals_count];
        for (size_t index = 0; index < ordinals_count; index += 1) {
            bib_lc_special_init(&(spc_ordinals[index]), bib_lc_special_spec_ordinal);
            memcpy(&(spc_ordinals[index].value.ordinal), &(ordinals[index]), sizeof(bib_ordinal_t));
        }
        bib_lc_special_list_append(spc_list, spc_size, spc_ordinals, ordinals_count);
    }
    if (ordinals != NULL) {
        free(ordinals);
    }
    return false;
}

bool bib_parse_lc_special_ordinal_root(bib_ordinal_t *ord, char const **str, size_t *len)
{
    if (ord == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *string = *str;
    size_t      length = *len;

    bool  digit_success = bib_lex_digit16(ord->number, &string, &length);
    bool __unused     _ = digit_success && bib_read_space(&string, &length);
    bool success = bib_lex_suffix(ord->suffix, &string, &length)
                && bib_lex_suffix(ord->suffix, &string, &length)
                && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(ord, 0, sizeof(bib_ordinal_t));
    }
    return success;
}
