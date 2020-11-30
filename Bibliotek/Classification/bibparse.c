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
    bool cutter_success = caption_success  && bib_parse_lc_cutter(num->cutters, &str_1, &len_1);

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
    if (num == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    char const *str_0 = *str;
    size_t      len_0 = *len;

    bool suffix_success_0 = bib_lex_suffix(num->suffix, &str_0, &len_0);
    bool   work_success_0 = !suffix_success_0 && bib_lex_workmark(num->workmark, &str_0, &len_0);
    bool  space_success_0 = !suffix_success_0 && !work_success_0 && bib_read_space(&str_0, &len_0);

    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool  space_success_1 = suffix_success_0 && bib_read_space(&str_1, &len_1);
    bool   work_success_1 = !space_success_1 && space_success_0 && bib_lex_workmark(num->workmark, &str_1, &len_1);
    bool   spec_success_1 = !space_success_1 && !work_success_1 && space_success_0
                         && bib_parse_lc_special(&(num->special), &(num->special_count), &str_1, &len_1);

    char const *str_2 = str_1;
    size_t      len_2 = len_1;
    bool  space_success_2 =   work_success_1 && bib_read_space(&str_2, &len_2);
    bool   spec_success_2 = !space_success_2 && space_success_1
                         && bib_parse_lc_special(&(num->special), &(num->special_count), &str_2, &len_2);
    bool   spec_success_3 = space_success_2
                         && bib_parse_lc_special(&(num->special), &(num->special_count), &str_2, &len_2);

    size_t  final_length = (  spec_success_2 || spec_success_3) ? len_2
                         : (  spec_success_1 || work_success_1) ? len_1
                         : (suffix_success_0 || work_success_0) ? len_0
                         :                                       *len; 
    bool success = (final_length != *len) && bib_advance_step(*len - final_length, str, len);
    if (!success) {
        memset(num->suffix,   0, sizeof(num->suffix));
        memset(num->workmark, 0, sizeof(num->workmark));
        bib_lc_special_list_deinit(&(num->special), &(num->special_count));
    }
    return success;
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

    // if we could parse both a date and an ordinal, we'll prefer the ordinal
    if (date_success && !ordn_success) {
        char const *string_3 = string_0;
        size_t      length_3 = length_0;
        bool success = root_success
                    && bib_read_space(&string_3, &length_3)
                    && bib_parse_lc_caption_ordinal(&(cap->ordinal), &string_3, &length_3);\
        if (success) {
            memset(cap->date, 0, sizeof(char) * bib_datenum_size);
            date_success = false;
            string_1 = string_0;
            length_1 = length_0;
            ordn_success = success;
            string_2 = string_3;
            length_2 = length_3;
        }
    }

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
    char const *string_0 = *str;
    size_t length_0 = *len;

    bool cls_success = bib_lex_subclass(cap->letters, &string_0, &length_0);

    char const *string_1 = string_0;
    size_t length_1 = length_0;

    bool __unused __ = cls_success && bib_read_space(&string_1, &length_1); // optional space
    bool int_success = cls_success && bib_lex_integer(cap->integer, &string_1, &length_1);
    bool  __unused _ = int_success && bib_lex_decimal(cap->decimal, &string_1, &length_1);

    size_t final_length = (int_success) ? length_1 : length_0;
    bool success = cls_success && bib_advance_step(*len - final_length, str, len);
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
    bool  point_success = suffix_success && bib_read_point(&string, &length);
    bool     __unused _ =  point_success && bib_read_space(&string, &length);

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
    bib_read_space(&str_0, &len_0);
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
                && bib_lex_date(cut->date, &string, &length)
                && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(cut, 0, sizeof(bib_cutter_t));
    }
    return success;
}

#pragma mark - lc special

bool bib_parse_lc_special(bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len)
{
    if (spc_list == NULL || spc_size == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    if (spc_list == NULL && *spc_size != 0) {
        return false;
    }

    bib_lc_special_t *new_list = NULL;
    size_t            new_size = 0;

    char const *prev_str = *str;
    size_t      prev_len = *len;
    char const *curr_str = prev_str;
    size_t      curr_len = prev_len;

    bool loop_continue = true;
    while (loop_continue) {
        bool date_success = bib_parse_lc_special_date(&new_list, &new_size, &curr_str, &curr_len);
        bool  ord_success = !date_success && bib_parse_lc_special_ordinal(&new_list, &new_size, &curr_str, &curr_len);
        bool work_success = (date_success || ord_success)
                          && bib_parse_lc_special_workmark(&new_list, &new_size, &curr_str, &curr_len);
        bool loop_success = work_success || date_success || ord_success;
        if (loop_success) {
            prev_str = curr_str;
            prev_len = curr_len;
        }
        loop_continue = loop_success && bib_read_space(&curr_str, &curr_len);
    }

    bool parse_success = (new_list != NULL) && (new_size != 0) && bib_advance_step(*len - prev_len, str, len);
    if (parse_success) {
        bib_lc_special_list_append(spc_list, spc_size, new_list, new_size);
    }
    bib_lc_special_list_deinit(&new_list, &new_size);
    return parse_success;
}

bool bib_parse_lc_special_date(bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len)
{
    if (spc_list == NULL || spc_size == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    if (spc_list == NULL && *spc_size != 0) {
        return false;
    }

    char const *string = *str;
    size_t      length = *len;

    char date[bib_datenum_size + 1];
    memset(date, 0, sizeof(date));

    char span[bib_datenum_size + 1];
    memset(span, 0, sizeof(span));

    char suffix[bib_suffix_size + 1];
    memset(suffix, 0, sizeof(suffix));

    bool   date_success_0 = bib_lex_date(date, &string, &length);
    bool   dash_success_0 = date_success_0 && bib_read_dash(&string, &length);
    bool suffix_success_0 = date_success_0 && !dash_success_0 && bib_lex_suffix(suffix, &string, &length);

    bool   date_success_1 = date_success_0 && dash_success_0 && bib_lex_date(span, &string, &length);
    bool suffix_success_1 = date_success_1 && bib_lex_suffix(suffix, &string, &length);

    bool success = date_success_0 && bib_advance_step(*len - length, str, len);
    if (success) {
        if (dash_success_0) {
            bib_lc_special_t spc_span;
            bib_lc_special_init(&spc_span, bib_lc_special_spec_datespan);
            memcpy(spc_span.value.datespan.date, date, sizeof(date));
            memcpy(spc_span.value.datespan.span, span, sizeof(span));
            bib_lc_special_list_append(spc_list, spc_size, &spc_span, 1);
        } else if (date_success_0) {
            bib_lc_special_t spc_date;
            bib_lc_special_init(&spc_date, bib_lc_special_spec_date);
            memcpy(spc_date.value.date, date, sizeof(date));
            bib_lc_special_list_append(spc_list, spc_size, &spc_date, 1);
        }
        if (suffix_success_0 || suffix_success_1) {
            bib_lc_special_t spc_suffix;
            bib_lc_special_init(&spc_suffix, bib_lc_special_spec_suffix);
            memcpy(spc_suffix.value.suffix, suffix, sizeof(suffix));
        }
    }
    return success;
}

bool bib_parse_lc_special_workmark(bib_lc_special_t **const spc_list, size_t *const spc_size,
                                   char const **const str, size_t *const len)
{
    if (spc_list == NULL || spc_size == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }
    if (spc_list == NULL && *spc_size != 0) {
        return false;
    }

    bib_lc_special_t work;
    bib_lc_special_init(&work, bib_lc_special_spec_workmark);
    bool success = bib_lex_workmark(work.value.workmark, str, len);
    if (success) {
        bib_lc_special_list_append(spc_list, spc_size, &work, 1);
    }
    return success;
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
    bool     __unused _ = digit_success && bib_read_space(&string, &length);
    bool success = bib_lex_suffix(ord->suffix, &string, &length)
                && bib_lex_suffix(ord->suffix, &string, &length)
                && bib_advance_step(*len - length, str, len);
    if (!success) {
        memset(ord, 0, sizeof(bib_ordinal_t));
    }
    return success;
}
