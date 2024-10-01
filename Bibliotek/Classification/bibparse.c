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

static bool bib_parse_date_cpred_isbreak(char c);
static bool bib_parse_month(bib_month_t *month, bib_strbuf_t *parser);
static bool bib_parse_date_date(bib_date_t *date, bib_strbuf_t *parser);
static bool bib_parse_date_span(bib_date_t *date, bib_strbuf_t *parser);

bool bib_parse_lc_calln(bib_lc_calln_t *const calln, bib_strbuf_t *const parser)
{
    if (calln == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    /// subject matter
    bib_strbuf_t p0 = *parser;
    bool sub_success = bib_parse_lc_subject(calln, &p0);

    /// cutter numbers
    bib_strbuf_t p1 = (sub_success) ? p0 : *parser;
    bool __unused  _ = sub_success && bib_read_space(&p1);
    bool cut_success = sub_success && bib_parse_cuttseg_list(calln->cutters, &p1);

    // specifications[0]
    bib_strbuf_t p2 = (cut_success) ? p1 : p0;
    bool spc_0_space_success = sub_success && bib_read_space(&p2);
    bool spc_0_parse_success = spc_0_space_success
                            && bib_parse_lc_specification(&(calln->specifications[0]), &p2);

    // specifications[1]
    bib_strbuf_t p3 = (spc_0_parse_success) ? p2 : p1;
    bool spc_1_space_success = spc_0_parse_success && bib_read_space(&p3);
    bool spc_1_parse_success = spc_1_space_success
                            && bib_parse_lc_specification(&(calln->specifications[1]), &p3);

    // remainder
    bib_strbuf_t p4 = (spc_1_parse_success) ? p3 : p2;
    bool rem_space_success = spc_1_parse_success && bib_read_space(&p4);
    bool rem_parse_success = rem_space_success && bib_parse_lc_remainder(&(calln->remainder), &p4);

    bool success = bib_advance_strbuf(parser, (rem_parse_success)   ? &p4
                                            : (spc_1_parse_success) ? &p3
                                            : (spc_0_parse_success) ? &p2
                                            : (cut_success)         ? &p1
                                            : (sub_success)         ? &p0
                                            : NULL);
    if (!success) {
        bib_lc_specification_list_deinit(&(calln->remainder));
    }
    return success;
}

bool bib_parse_lc_subject(bib_lc_calln_t *const calln, bib_strbuf_t *const parser)
{
    if (calln == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    /// subject matter class and subclass
    bib_strbuf_t p0 = *parser;
    bool base_success = bib_parse_lc_subject_base(calln, &p0);

    /// subject matter date or ordinal
    bib_strbuf_t p1 = p0;
    bool space_success = base_success && bib_read_space(&p1);
    bool dord_success = space_success && bib_parse_dateord(&(calln->dateord),
                                                           bib_lex_caption_ordinal_suffix,
                                                           &p1);
    bool success = bib_advance_strbuf(parser, (dord_success) ? &p1
                                            : (base_success) ? &p0
                                            : NULL);
    if (!success) {
        memset(calln, 0, sizeof(bib_lc_calln_t));
    }
    return success;
}

bool bib_parse_lc_subject_base(bib_lc_calln_t *const calln, bib_strbuf_t *const parser)
{
    if (calln == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    // subject matter class
    bib_strbuf_t p0 = *parser;
    bool cls_success = bib_lex_subclass(calln->letters, &p0);

    // subject matter subclass
    bib_strbuf_t p1 = p0;
    bool __unused __ = cls_success && bib_read_space(&p1); // optional space
    bool int_success = cls_success && bib_lex_integer(calln->integer, &p1);
    bool __unused  _ = int_success && bib_lex_decimal(calln->decimal, &p1);

    bool success = bib_advance_strbuf(parser, (int_success) ? &p1
                                            : (cls_success) ? &p0
                                            : NULL);
    if (!success) {
        memset(calln->letters, 0, sizeof(calln->letters));
        memset(calln->integer, 0, sizeof(calln->integer));
        memset(calln->decimal, 0, sizeof(calln->decimal));
    }
    return success;
}

bool bib_parse_cuttseg_list(bib_cuttseg_t segs[3], bib_strbuf_t *const parser)
{
    if (segs == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;
    bool __unused point_success = bib_read_point(&p0);

    bool stop = false;
    size_t index = 0;
    bool success = true; // point_success;
    while (index < 3 && success && !stop) {
        bib_strbuf_t p1 = p0;
        bool first = (index == 0);
        bool has_prev_date = !first && !bib_dateord_is_empty(&(segs[index - 1].dateord));
        bool has_prev_mark = !first && !(segs[index - 1].cutter.mark[0] == '\0');
        bool space_success = !first && bib_read_space(&p1);
        bool require_space = (has_prev_date || has_prev_mark);
        bool point_success = bib_read_point(&p1);

        if (require_space && !space_success && !point_success) {
            success = bib_peek_break(&p1);
            stop = true;
            break;
        } else if (bib_parse_cuttseg(&(segs[index]), &p1)) {
            p0 = p1;
            index += 1;
        } else {
            success = !first || space_success || bib_peek_break(&p1);
            stop = true;
        }
    }

    success = success && bib_advance_strbuf(parser, &p0);
    if (!success) {
        memset(segs, 0, sizeof(bib_cuttseg_t) * 3);
    }
    return success;
}

bool bib_parse_dateord(bib_dateord_t *const dord, bib_lex_word_f const lex_ord_suffix, bib_strbuf_t *const parser)
{
    if (dord == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;

    bib_date_t date = {};
    bool date_success = bib_parse_date(&date, &p0)
                     && bib_dateord_init_date(dord, &date);

    bib_strbuf_t p1 = *parser;

    bib_ordinal_t ord = {};
    bool ordl_success = !date_success
                     && bib_parse_ordinal(&ord, lex_ord_suffix, &p1)
                     && bib_dateord_init_ordinal(dord, &ord);

    bool success = (date_success || ordl_success) && bib_advance_strbuf(parser, (date_success) ? &p0
                                                                              : (ordl_success) ? &p1
                                                                              : NULL);
    if (!success) {
        memset(dord, 0, sizeof(bib_dateord_t));
    }
    return success;
}

bool bib_parse_cuttseg(bib_cuttseg_t *seg, bib_strbuf_t *const parser)
{
    if (seg == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;
    bool cutter_success = bib_parse_cutter(&(seg->cutter), &p0);

    bib_strbuf_t p1 = p0;
    bool  space_success = cutter_success && bib_read_space(&p1);
    bool number_success = space_success && bib_parse_dateord(&(seg->dateord),
                                                             bib_lex_cutter_ordinal_suffix,
                                                             &p1);

    bool success = (number_success || cutter_success) && bib_advance_strbuf(parser, (number_success) ? &p1
                                                                                  : (cutter_success) ? &p0
                                                                                  : NULL);
    if (!success) {
        memset(seg, 0, sizeof(bib_cuttseg_t));
    }
    return success;
}

bool bib_parse_lc_specification(bib_lc_specification_t *const spc, bib_strbuf_t *const parser)
{
    if (spc == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;
    bool date_success = bib_parse_date(&(spc->date), &p0)
                     && bib_peek_break(&p0);

    bib_strbuf_t p1 = *parser;
    bool  ord_success = !date_success
                     && bib_parse_specification_ordinal(&(spc->ordinal), &p1)
                     && bib_peek_break(&p1);

    bib_strbuf_t p2 = *parser;
    bool supl_success = !date_success
                     && !ord_success
                     && bib_parse_supplement(&(spc->supplement), &p2)
                     && bib_peek_break(&p2);

    bib_strbuf_t p3 = *parser;
    bool  vol_success = !date_success
                     && !ord_success
                     && !supl_success
                     && bib_parse_volume(&(spc->volume), &p3)
                     && bib_peek_break(&p3);

    bib_strbuf_t p4 = *parser;
    bool word_success = !date_success
                     && !ord_success
                     && !supl_success
                     && !vol_success
                     && bib_lex_longword(spc->word, &p4)
                     && bib_peek_break(&p4);

    spc->kind = (date_success) ? bib_lc_specification_kind_date
              :  (ord_success) ? bib_lc_specification_kind_ordinal
              : (supl_success) ? bib_lc_specification_kind_supplement
              :  (vol_success) ? bib_lc_specification_kind_volume
              : (word_success) ? bib_lc_specification_kind_word
              : 0;
    bool success = (spc->kind != 0) && bib_advance_strbuf(parser, (date_success) ? &p0
                                                                :  (ord_success) ? &p1
                                                                : (supl_success) ? &p2
                                                                :  (vol_success) ? &p3
                                                                : (word_success) ? &p4
                                                                : NULL);
    if (!success) {
        bib_lc_specification_deinit(spc);
    }
    return success;
}

bool bib_parse_lc_remainder(bib_lc_specification_list_t *const rem, bib_strbuf_t *const parser)
{
    if (rem == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;

    size_t index = 0;
    bool stop = false;
    bool success = true;
    bib_lc_specification_list_init(rem);
    while ((p0.len != 0) && success && !stop) {
        bib_strbuf_t p1 = p0;
        bib_lc_specification_t special = {};
        bool pre_success = (index == 0) || bib_read_space(&p1);
        bool spc_success = pre_success && bib_parse_lc_specification(&special, &p1);
        success = spc_success || (index > 0);
        stop = !spc_success;
        if (spc_success) {
            bib_lc_specification_list_append(rem, &special);
            p0 = p1;
            index += 1;
        }
    }

    success = success && bib_advance_strbuf(parser, &p0);
    if (!success) {
        bib_lc_specification_list_deinit(rem);
    }
    return success;
}

bool bib_parse_cutter(bib_cutter_t *cut, bib_strbuf_t *const parser)
{
    if (cut == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;
    bool cutter_success = bib_lex_initial(&(cut->letter), &p0);
    bool number_success = cutter_success && bib_lex_digit16(cut->number, &p0);

    bib_strbuf_t p1 = p0;
    bool mark_success = cutter_success && number_success && bib_lex_mark(cut->mark, &p1);
    // if a mark is only one character, we should treat it as cutter
    if (mark_success && (strlen(cut->mark) < 2)) {
        memset(cut->mark, 0, sizeof(bib_mark_b));
        mark_success = false;
        p1 = p0;
    }

    bool success = cutter_success
                && (number_success || bib_peek_char(NULL, bib_isstop, &p1))
                && bib_advance_strbuf(parser, &p1);
    if (!success) {
        memset(cut, 0, sizeof(bib_cutter_t));
    }
    return success;
}

static bool bib_parse_date_cpred_isbreak(char c) {
    return bib_isspace(c) || bib_ispoint(c) || bib_isstop(c);
}

static bool bib_parse_month(bib_month_t *month, bib_strbuf_t *const parser)
{
    if (month == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;

    char abbrev[5];
    memset(abbrev, 0, sizeof(abbrev));
    bool abbrev_success = bib_read_char(&(abbrev[0]), bib_isupper, &p0)
                       && bib_read_char(&(abbrev[1]), bib_islower, &p0)
                       && bib_read_char(&(abbrev[2]), bib_islower, &p0);
    if (!abbrev_success) {
        *month = 0;
        return false;
    }
    bib_month_t result = 0;
    if (bib_peek_char(NULL, bib_parse_date_cpred_isbreak, &p0)) {
        result = (strcmp("Jan", abbrev) == 0) ? bib_month_jan
               : (strcmp("Feb", abbrev) == 0) ? bib_month_feb
               : (strcmp("Mar", abbrev) == 0) ? bib_month_mar
               : (strcmp("Apr", abbrev) == 0) ? bib_month_apr
               : (strcmp("May", abbrev) == 0) ? bib_month_may
               : (strcmp("Jun", abbrev) == 0) ? bib_month_jun
               : (strcmp("Jul", abbrev) == 0) ? bib_month_jul
               : (strcmp("Aug", abbrev) == 0) ? bib_month_aug
               : (strcmp("Oct", abbrev) == 0) ? bib_month_oct
               : (strcmp("Nov", abbrev) == 0) ? bib_month_nov
               : (strcmp("Dec", abbrev) == 0) ? bib_month_dec
               : 0;
    } else {
        bool issept = bib_read_char(&(abbrev[3]), bib_islower, &p0)
                   && bib_peek_char(NULL, bib_parse_date_cpred_isbreak, &p0)
                   && (strcmp("Sept", abbrev) == 0);
        result = (issept) ? bib_month_sept : 0;
    }
    bool success = (result != 0) && bib_advance_strbuf(parser, &p0);
    *month = (success) ? result : 0;
    return success;
}

static bool bib_parse_date_date(bib_date_t *date, bib_strbuf_t *const parser)
{
    if (date == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }
    bib_strbuf_t p0 = *parser;
    bool __unused _cma = bib_read_comma(&p0);
    bool require_space = bib_read_space(&p0);
    bool month_success = require_space && bib_parse_month(&(date->month), &p0);

    bib_strbuf_t p1 = p0;
    bool point_success = month_success && bib_read_point(&p1);
    bool space_success = month_success && bib_read_space(&p1);

    char day[3];
    memset(day, 0, sizeof(day));
    bool day_success = (point_success || space_success)
                    && bib_lex_char_n(day, sizeof(day), bib_isnumber, &p1)
                    && bib_peek_char(NULL, bib_parse_date_cpred_isbreak, &p1);
    date->day = (day_success) ? atoi(day) : 0;
    day_success = day_success && (date->day > 0) && (date->day < 32);

    bib_strbuf_t p2 = p0;
    // consume the decimal point if it's the last element from the input stream
    bool consume_point = month_success && !day_success
                      && bib_read_point(&p0)
                      && bib_peek_char(NULL, bib_isstop, &p2);

    bool success = (day_success || month_success) && bib_advance_strbuf(parser, (consume_point) ? &p2
                                                                              :   (day_success) ? &p1
                                                                              : (month_success) ? &p0
                                                                              : NULL);
    if (success) {
        date->isdate = true;
    } else {
        date->month = 0;
        date->day = 0;
    }
    return success;
}

static bool bib_parse_date_span(bib_date_t *const date, bib_strbuf_t *const parser)
{
    if (date == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }
    bib_year_b span = {};
    bib_strbuf_t p0 = *parser;
    bool dash_success = bib_read_dash(&p0);
    bool slsh_success = !dash_success && bib_read_slash(&p0);
    bool span_success = (dash_success || slsh_success)
                     && (bib_lex_year(span, &p0) || bib_lex_year_abv(span, &p0));
    bool success = span_success && bib_advance_strbuf(parser, &p0);
    if (success) {
        date->isspan = true;
        date->separator = (dash_success) ? '-'
                        : (slsh_success) ? '/'
                        : '-';
        memcpy(date->span, span, sizeof(bib_year_b));
    }
    return success;
}

bool bib_parse_date(bib_date_t *const date, bib_strbuf_t *const parser)
{
    if (date == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;
    bool year_success = bib_lex_year(date->year, &p0);

    bib_strbuf_t p1 = (year_success) ? p0 : *parser;
    bool span_success = year_success && bib_parse_date_span(date, &p1);
    bool mnth_success = year_success && !span_success && bib_parse_date_date(date, &p1);
    bool midl_success = span_success || mnth_success;

    bib_strbuf_t p2 = (midl_success) ? p1 : p0;
    bool mark_success = year_success && !mnth_success && bib_lex_mark(date->mark, &p2);

    bool success = year_success & bib_advance_strbuf(parser, (mark_success) ? &p2
                                                           : (midl_success) ? &p1
                                                           : (year_success) ? &p0
                                                           : NULL);
    if (!success) {
        memset(date, 0, sizeof(bib_date_t));
    }
    return success;
}

bool bib_parse_ordinal(bib_ordinal_t *ord, bib_lex_word_f lex_suffix, bib_strbuf_t *const parser)
{
    if (ord == NULL || lex_suffix == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p = *parser;
    bool success = bib_lex_digit16(ord->number, &p)
                && lex_suffix(ord->suffix, &p)
                && bib_advance_strbuf(parser, &p);

    if (!success) {
        memset(ord, 0, sizeof(bib_ordinal_t));
    }
    return success;
}

bool bib_parse_cutter_ordinal(bib_ordinal_t *const ord, bib_strbuf_t *const parser)
{
    return bib_parse_ordinal(ord, bib_lex_cutter_ordinal_suffix, parser);
}

bool bib_parse_caption_ordinal(bib_ordinal_t *const ord, bib_strbuf_t *const parser)
{
    return bib_parse_ordinal(ord, bib_lex_caption_ordinal_suffix, parser);
}

bool bib_parse_specification_ordinal(bib_ordinal_t *const ord, bib_strbuf_t *const parser)
{
    return bib_parse_ordinal(ord, bib_lex_specification_ordinal_suffix, parser);
}

bool bib_parse_volume(bib_volume_t *const vol, bib_strbuf_t *const parser)
{
    if (vol == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p = *parser;
    bool prefix_success = bib_lex_volume_prefix(vol->prefix, &p);
    bool __unused space = prefix_success && bib_read_space(&p);
    bool number_success = prefix_success && bib_lex_digit16(vol->number, &p);
    vol->hasetc = number_success && bib_read_etc(&p);

    bool success = number_success && bib_advance_strbuf(parser, &p);
    if (!success) {
        memset(vol, 0, sizeof(bib_volume_t));
    }
    return success;
}

bool bib_parse_supplement(bib_supplement_t *supl, bib_strbuf_t *parser)
{
    if (supl == NULL || parser == NULL || parser->str == NULL || parser->len == 0) {
        return false;
    }

    bib_strbuf_t p0 = *parser;
    bool prefix_success = bib_lex_supplement_prefix(supl->prefix, &p0);
    supl->isabbr = prefix_success && bib_read_point(&p0);

    bib_strbuf_t p1 = p0;
    bool required_space = prefix_success && bib_read_space(&p1);
    bool number_success = prefix_success && required_space && bib_lex_digit16(supl->number, &p1);

    bib_strbuf_t p2 = p1;
    supl->hasetc = number_success && bib_read_etc(&p2);

    bool success = number_success && bib_advance_strbuf(parser, (supl->hasetc)    ? &p2
                                                              : (number_success) ? &p1
                                                              : (prefix_success) ? &p0
                                                              : NULL);
    if (!success) {
        memset(supl, 0, sizeof(bib_supplement_t));
    }
    return success;
}
