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

static bool bib_parse_lc_calln_caption_root(bib_lc_calln_t *calln, char const **str, size_t *len);

bool bib_parse_lc_calln(bib_lc_calln_t *const calln, char const **const str, size_t *const len)
{
    if (calln == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    /// caption class and number
    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool cap_success = bib_parse_lc_calln_caption_root(calln, &str_0, &len_0);

    /// caption date or ordinal
    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool cap_space_success = cap_success && bib_read_space(&str_1, &len_1);
    bool cap_other_success = cap_space_success && bib_parse_dateord(&(calln->dateord),
                                                                    bib_lex_caption_ordinal_suffix,
                                                                    &str_1, &len_1);

    /// cutter numbers
    char const *str_2 = (cap_other_success) ? str_1 : str_0;
    size_t      len_2 = (cap_other_success) ? len_1 : len_0;
    bool __unused  _ = cap_success && bib_read_space(&str_2, &len_2);
    bool cut_success = cap_success && bib_parse_cuttseg_list(calln->cutters, &str_2, &len_2);

    // specifications[0]
    char const *str_3 = (cut_success) ? str_2 : str_1;
    size_t      len_3 = (cut_success) ? len_2 : len_1;
    bool spc_0_space_success = cut_success && bib_read_space(&str_3, &len_3);
    bool spc_0_parse_success = spc_0_space_success
                            && bib_parse_lc_specification(&(calln->specifications[0]), &str_3, &len_3);

    // specifications[1]
    char const *str_4 = (spc_0_parse_success) ? str_3 : str_2;
    size_t      len_4 = (spc_0_parse_success) ? len_3 : len_2;
    bool spc_1_space_success = spc_0_parse_success && bib_read_space(&str_4, &len_4);
    bool spc_1_parse_success = spc_1_space_success
                            && bib_parse_lc_specification(&(calln->specifications[1]), &str_4, &len_4);

    // remainder
    char const *str_5 = (spc_1_parse_success) ? str_4 : str_3;
    size_t      len_5 = (spc_1_parse_success) ? len_4 : len_3;
    bool rem_space_success = spc_1_parse_success && bib_read_space(&str_5, &len_5);
    bool rem_parse_success = rem_space_success && bib_parse_lc_remainder(&(calln->remainder), &str_5, &len_5);

    size_t final_len = (rem_parse_success)   ? len_5
                     : (spc_1_parse_success) ? len_4
                     : (spc_0_parse_success) ? len_3
                     : (cut_success)         ? len_2
                     : (cap_other_success)   ? len_1
                     : (cap_success)         ? len_0
                     : *len;
    bool success = bib_advance_step(*len - final_len, str, len);
    if (!success) {
        bib_lc_specification_list_deinit(&(calln->remainder));
    }
    return success;
}

static bool bib_parse_lc_calln_caption_root(bib_lc_calln_t *const calln, char const **const str, size_t *const len)
{
    if (calln == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    // caption class
    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool cls_success = bib_lex_subclass(calln->letters, &str_0, &len_0);

    // caption number
    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool __unused __ = cls_success && bib_read_space(&str_1, &len_1); // optional space
    bool int_success = cls_success && bib_lex_integer(calln->integer, &str_1, &len_1);
    bool __unused  _ = int_success && bib_lex_decimal(calln->decimal, &str_1, &len_1);

    size_t final_len = (int_success) ? len_1 : len_0;
    bool success = cls_success && bib_advance_step(*len - final_len, str, len);
    if (!success) {
        memset(calln->letters, 0, sizeof(bib_alpah03_b));
        memset(calln->integer, 0, sizeof(bib_digit04_b));
        memset(calln->decimal, 0, sizeof(bib_digit16_b));
    }
    return success;
}

bool bib_parse_cuttseg_list(bib_cuttseg_t segs[3], char const **const str, size_t *const len)
{
    if (segs == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool point_success = bib_read_point(&str_0, &len_0);

    bool stop = false;
    size_t index = 0;
    bool success = point_success;
    while (index < 3 && success && !stop) {
        char const *str_1 = str_0;
        size_t      len_1 = len_0;
        bool first = (index == 0);
        bool has_prev_date = !first && !bib_dateord_is_empty(&(segs[index - 1].dateord));
        bool has_prev_mark = !first && !(segs[index - 1].cutter.mark[0] == '\0');
        bool space_success = !first && bib_read_space(&str_1, &len_1);
        bool require_space = (has_prev_date || has_prev_mark);

        if (require_space && !space_success) {
            success = bib_peek_break(str_1, len_1);
            stop = true;
            break;
        } else if (bib_parse_cuttseg(&(segs[index]), &str_1, &len_1)) {
            str_0 = str_1;
            len_0 = len_1;
            index += 1;
        } else {
            success = !first || space_success || bib_peek_break(str_1, len_1);
            stop = true;
        }
    }

    success = success && bib_advance_step(*len - len_0, str, len);
    if (!success) {
        memset(segs, 0, sizeof(bib_cuttseg_t) * 3);
    }
    return success;
}

bool bib_parse_dateord(bib_dateord_t *const dord, bib_lex_word_f const lex_ord_suffix,
                       char const **const str, size_t *const len)
{
    if (dord == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;

    bib_date_t date = {};
    bool date_success = bib_parse_date(&date, &str_0, &len_0)
                     && bib_dateord_init_date(dord, &date);

    char const *str_1 = *str;
    size_t      len_1 = *len;

    bib_ordinal_t ord = {};
    bool ordl_success = !date_success
                     && bib_parse_ordinal(&ord, lex_ord_suffix, &str_1, &len_1)
                     && bib_dateord_init_ordinal(dord, &ord);

    size_t final_len = (date_success) ? len_0
                     : (ordl_success) ? len_1
                     : *len;
    bool success = (date_success || ordl_success) && bib_advance_step(*len - final_len, str, len);
    if (!success) {
        memset(dord, 0, sizeof(bib_dateord_t));
    }
    return success;
}

bool bib_parse_cuttseg(bib_cuttseg_t *seg, char const **const str, size_t *const len)
{
    if (seg == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool cutter_success = bib_parse_cutter(&(seg->cutter), &str_0, &len_0);

    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool  space_success = cutter_success && bib_read_space(&str_1, &len_1);
    bool number_success = space_success && bib_parse_dateord(&(seg->dateord),
                                                             bib_lex_cutter_ordinal_suffix,
                                                             &str_1, &len_1);

    size_t final_len = (number_success) ? len_1 : (cutter_success) ? len_0 : *len;
    bool success = (number_success || cutter_success) && bib_advance_step(*len - final_len, str, len);
    if (!success) {
        memset(seg, 0, sizeof(bib_cuttseg_t));
    }
    return success;
}

bool bib_parse_lc_specification(bib_lc_specification_t *const spc, char const **const str, size_t *const len)
{
    if (spc == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool date_success = bib_parse_date(&(spc->date), &str_0, &len_0);
    bool  ord_success = !date_success && bib_parse_specification_ordinal(&(spc->ordinal), &str_0, &len_0);
    bool  vol_success = !date_success && !ord_success && bib_parse_volume(&(spc->volume), &str_0, &len_0);
    bool word_success = !date_success && !ord_success && !vol_success && bib_lex_longword(spc->word, &str_0, &len_0);

    spc->kind = (date_success) ? bib_lc_specification_kind_date
              :  (ord_success) ? bib_lc_specification_kind_ordinal
              :  (vol_success) ? bib_lc_specification_kind_volume
              : (word_success) ? bib_lc_specification_kind_word
              : 0;
    bool success = (spc->kind != 0) && bib_advance_step(*len - len_0, str, len);
    if (!success) {
        bib_lc_specification_deinit(spc);
    }
    return success;
}

bool bib_parse_lc_remainder(bib_lc_specification_list_t *const rem, char const **const str, size_t *const len)
{
    if (rem == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;

    size_t index = 0;
    bool stop = false;
    bool success = true;
    bib_lc_specification_list_init(rem);
    while ((len_0 != 0) && success && !stop) {
        char const *str_1 = str_0;
        size_t      len_1 = len_0;
        bib_lc_specification_t special = {};
        bool pre_success = (index == 0) || bib_read_space(&str_1, &len_1);
        bool spc_success = pre_success && bib_parse_lc_specification(&special, &str_1, &len_1);
        success = spc_success || (index > 0);
        stop = !spc_success;
        if (spc_success) {
            bib_lc_specification_list_append(rem, &special);
            str_0 = str_1;
            len_0 = len_1;
            index += 1;
        }
    }

    success = success && bib_advance_step(*len - len_0, str, len);
    if (!success) {
        bib_lc_specification_list_deinit(rem);
    }
    return success;
}

bool bib_parse_cutter(bib_cutter_t *cut, char const **str, size_t *len)
{
    if (cut == NULL || str == NULL || *str == NULL || len == NULL || len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool cutter_success = bib_lex_initial(&(cut->letter), &str_0, &len_0)
                       && bib_lex_digit16(cut->number, &str_0, &len_0);

    char const *str_1 = str_0;
    size_t      len_1 = len_0;
    bool __unused _ = cutter_success && bib_lex_mark(cut->mark, &str_1, &len_1);

    bool success = cutter_success && bib_advance_step(*len - len_0, str, len);
    if (!success) {
        memset(cut, 0, sizeof(bib_cutter_t));
    }
    return success;
}

bool bib_parse_date(bib_date_t *const date, char const **const str, size_t *const len)
{
    if (date == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool year_success = bib_lex_year(date->year, &str_0, &len_0);

    char const *str_1 = (year_success) ? str_0 : *str;
    size_t      len_1 = (year_success) ? len_0 : *len;
    bool dash_success = year_success && bib_read_dash(&str_1, &len_1);
    bool slsh_success = year_success && !dash_success && bib_read_slash(&str_1, &len_1);
    bool span_success = (dash_success || slsh_success)
                     && (bib_lex_year(date->span, &str_1, &len_1) || bib_lex_year_abv(date->span, &str_1, &len_1));

    if (span_success) {
        date->separator = (dash_success) ? '-'
                        : (slsh_success) ? '/'
                        : '-';
    }

    char const *str_2 = (span_success) ? str_1 : str_0;
    size_t      len_2 = (span_success) ? len_1 : len_0;
    bool mark_success = year_success && bib_lex_mark(date->mark, &str_2, &len_2);

    size_t final_len = (mark_success) ? len_2
                     : (span_success) ? len_1
                     : len_0;
    bool success = year_success && bib_advance_step(*len - final_len, str, len);
    if (!success) {
        memset(date, 0, sizeof(bib_date_t));
    }
    return success;
}

bool bib_parse_ordinal(bib_ordinal_t *ord, bib_lex_word_f lex_suffix, char const **str, size_t *len)
{
    if (ord == NULL || lex_suffix == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool success = bib_lex_digit16(ord->number, &str_0, &len_0)
                && lex_suffix(ord->suffix, &str_0, &len_0)
                && bib_advance_step(*len - len_0, str, len);

    if (!success) {
        memset(ord, 0, sizeof(bib_ordinal_t));
    }
    return success;
}

bool bib_parse_cutter_ordinal(bib_ordinal_t *const ord, char const **const str, size_t *const len)
{
    return bib_parse_ordinal(ord, bib_lex_cutter_ordinal_suffix, str, len);
}

bool bib_parse_caption_ordinal(bib_ordinal_t *const ord, char const **const str, size_t *const len)
{
    return bib_parse_ordinal(ord, bib_lex_caption_ordinal_suffix, str, len);
}

bool bib_parse_specification_ordinal(bib_ordinal_t *const ord, char const **const str, size_t *const len)
{
    return bib_parse_ordinal(ord, bib_lex_specification_ordinal_suffix, str, len);
}

bool bib_parse_volume(bib_volume_t *const vol, char const **const str, size_t *const len)
{
    if (vol == NULL || str == NULL || *str == NULL || len == NULL || *len == 0) {
        return false;
    }

    char const *str_0 = *str;
    size_t      len_0 = *len;
    bool prefix_success = bib_lex_volume_prefix(vol->prefix, &str_0, &len_0);
    bool __unused space = bib_read_space(&str_0, &len_0);
    bool number_success = prefix_success && bib_lex_digit16(vol->number, &str_0, &len_0);

    bool success = number_success && bib_advance_step(*len - len_0, str, len);
    if (!success) {
        memset(vol, 0, sizeof(bib_volume_t));
    }
    return success;
}
