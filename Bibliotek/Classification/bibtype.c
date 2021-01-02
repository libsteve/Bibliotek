//
//  bibtype.c
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#include "bibtype.h"
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "bibparse.h"

#pragma mark lc calln

bool bib_lc_calln_init(bib_lc_calln_t *const num, char const *const str)
{
    if (num == NULL || str == NULL) { return false; }
    memset(num, 0, sizeof(bib_lc_calln_t));
    bib_strbuf_t strbuf = bib_strbuf(str, 0);
    bool parse_success = bib_parse_lc_calln(num, &strbuf);
    bool total_success = parse_success && (strbuf.len == 1);
    if (parse_success && !total_success) {
        bib_lc_calln_deinit(num);
    }
    return total_success;
}

void bib_lc_calln_deinit(bib_lc_calln_t *const num)
{
    if (num == NULL) { return; }
    bib_lc_specification_list_deinit(&(num->remainder));
    memset(num, 0, sizeof(bib_lc_calln_t));
}

#pragma mark - date

bool bib_date_init(bib_date_t *const date, char const *const str)
{
    bib_strbuf_t parser = { .str = str, .len = strlen(str) };
    return bib_parse_date(date, &parser);
}

bool bib_date_is_empty(bib_date_t const *const date)
{
    return (date == NULL) || (date->year[0] == '\0');
}

bool bib_date_has_span(bib_date_t const *const date)
{
    return (date != NULL) && (date->separator != '\0');
}

#pragma mark - cutter

bool bib_cutter_init(bib_cutter_t *cut, char const *str)
{
    bib_strbuf_t parser = { .str = str, .len = strlen(str) };
    return bib_parse_cutter(cut, &parser);
}

bool bib_cutter_is_empty(bib_cutter_t const *const cut)
{
    return (cut == NULL) || (cut->letter == '\0');
}

#pragma mark - ordinal

bool bib_ordinal_is_empty(bib_ordinal_t const *const ord)
{
    return (ord == NULL) || (ord->number[0] == '\0');
}

#pragma mark - volume

bool bib_volume_init(bib_volume_t *const vol, char const *const str)
{
    bib_strbuf_t parser = { .str = str, .len = strlen(str) };
    return bib_parse_volume(vol, &parser);
}

bool bib_volume_is_empty(bib_volume_t const *const vol)
{
    return (vol == NULL) || (vol->prefix[0] == '\0');
}

#pragma mark - lc specification

void bib_lc_specification_init(bib_lc_specification_t *const spc, bib_lc_specification_kind_t kind)
{
    if (spc == NULL) { return; }
    memset(spc, 0, sizeof(bib_lc_specification_t));
    spc->kind = kind;
}

void bib_lc_specification_deinit(bib_lc_specification_t *const spc)
{
    if (spc == NULL) { return; }
    memset(spc, 0, sizeof(bib_lc_specification_t));
}

bool bib_lc_specification_is_empty(bib_lc_specification_t const *const spc)
{
    return (spc == NULL) || (spc->kind == 0);
}

void bib_lc_specification_list_init(bib_lc_specification_list_t *list)
{
    if (list == NULL) { return; }
    memset(list, 0, sizeof(bib_lc_specification_list_t));
}

void bib_lc_specification_list_append(bib_lc_specification_list_t *list, bib_lc_specification_t *spc)
{
    if (list == NULL || spc == NULL) { return; }
    assert(list->buffer != NULL || list->length == 0);
    size_t const prev_end_index = list->length;
    list->length = prev_end_index + 1;
    list->buffer = (list->buffer == NULL) ? malloc(sizeof(bib_lc_specification_t))
                                          : realloc(list->buffer, list->length * sizeof(bib_lc_specification_t));
    list->buffer[prev_end_index] = *spc;
}

void bib_lc_specification_list_deinit(bib_lc_specification_list_t *const list)
{
    if (list == NULL || list->buffer == NULL) { return; }
    free(list->buffer);
    list->buffer = NULL;
    list->length = 0;
}

bool bib_lc_specification_list_is_empty(bib_lc_specification_list_t const *const list) {
    return (list == NULL) || (list->buffer == NULL) || (list->length == 0);
}

#pragma mark - lc dateord

bool bib_dateord_init_date(bib_dateord_t *const dord, bib_date_t const *const date)
{
    if (dord == NULL || date == NULL || bib_date_is_empty(date)) {
        return false;
    }
    memset(dord, 0, sizeof(bib_dateord_t));
    dord->kind = bib_dateord_kind_date;
    dord->date = *date;
    return true;
}

bool bib_dateord_init_ordinal(bib_dateord_t *const dord, bib_ordinal_t const *const ord)
{
    if (dord == NULL || ord == NULL || bib_ordinal_is_empty(ord)) {
        return false;
    }
    memset(dord, 0, sizeof(bib_dateord_t));
    dord->kind = bib_dateord_kind_ordinal;
    dord->ordinal = *ord;
    return true;
}

bib_date_t const *bib_dateord_get_date(bib_dateord_t *const dord)
{
    if (dord == NULL || dord->kind != bib_dateord_kind_date) {
        return NULL;
    }
    return &(dord->date);
}

bib_ordinal_t const *bib_dateord_get_ordinal(bib_dateord_t *const dord)
{
    if (dord == NULL || dord->kind != bib_dateord_kind_ordinal) {
        return NULL;
    }
    return &(dord->ordinal);
}

bool bib_dateord_is_empty(bib_dateord_t const *const num)
{
    return (num == NULL) || (num->kind == 0);
}

#pragma mark - lc cutter

bool bib_cuttseg_init(bib_cuttseg_t *const seg, bib_cutter_t const *const num, bib_dateord_t const *const dord)
{
    if (seg == NULL || bib_cutter_is_empty(num)) {
        return false;
    }
    seg->cutter = *num;
    if (!bib_dateord_is_empty(dord)) {
        seg->dateord = *dord;
    }
    return true;
}

bool bib_cuttseg_is_empty(bib_cuttseg_t const *const seg)
{
    return (seg == NULL) || bib_cutter_is_empty(&(seg->cutter));
}

#pragma mark - lc comparison

static inline bool bib_str_is_empty(char const *const str) { return str == NULL || str[0] == '\0'; }

bib_calln_comparison_t bib_integer_compare(bib_calln_comparison_t const status,
                                           char const *const left, char const *const right, bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }
    if (status == bib_calln_ordered_specifying && !bib_str_is_empty(left)) { return bib_calln_ordered_ascending; }

    int const left_int = bib_str_is_empty(left) ? 0 : atoi(left);
    int const right_int = bib_str_is_empty(right) ? 0 : atoi(right);
    if (left_int != right_int) {
        return (left_int < right_int) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }
    return bib_calln_ordered_same;
}

#pragma mark -

bib_calln_comparison_t bib_lc_calln_compare(bib_calln_comparison_t const status,
                                            bib_lc_calln_t const *const left, bib_lc_calln_t const *const right,
                                            bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }
    else if (left  == NULL && right == NULL) { return status; }
    else if (left  == NULL) { return bib_calln_ordered_ascending; }
    else if (right == NULL) { return bib_calln_ordered_descending; }

    bib_calln_comparison_t result = status;
    // letters
    result = bib_string_specify_compare(result, left->letters, right->letters, specify);

    // integer
    result = bib_integer_compare(result, left->integer, right->integer, specify);

    // decimal
    result = bib_string_specify_compare(result, left->decimal, right->decimal, specify);

    // datenum
    result = bib_dateord_compare(result, &(left->dateord), &(right->dateord), specify);

    // cutters
    for (size_t index = 0; index < 3; index += 1) {
        bib_cuttseg_t const *const left_cut = &(left->cutters[index]);
        bib_cuttseg_t const *const right_cut = &(right->cutters[index]);
        result = bib_cuttseg_compare(result, left_cut, right_cut, specify);
    }

    // specifications
    for (size_t index = 0; index < 2; index += 1) {
        bib_lc_specification_t const *const left_spc = &(left->specifications[index]);
        bib_lc_specification_t const *const right_spc = &(right->specifications[index]);
        result = bib_specification_compare(result, left_spc, right_spc, specify);
    }

    // remainder
    {
        size_t index = 0;
        size_t const left_len = left->remainder.length;
        size_t const right_len = right->remainder.length;
        for (; (index < left_len) && (index < right_len); index += 1) {
            bib_lc_specification_t const *const l = &(left->remainder.buffer[index]);
            bib_lc_specification_t const *const r = &(right->remainder.buffer[index]);
            result = bib_specification_compare(result, l, r, specify);
        }
        if (result == bib_calln_ordered_same) {
            if (left_len > right_len) {
                result = bib_calln_ordered_descending;
            } else if (left_len < right_len) {
                result = (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending;
            }
        }
    }

    return result;
}

bib_calln_comparison_t bib_cuttseg_compare(bib_calln_comparison_t const status,
                                           bib_cuttseg_t const *const left, bib_cuttseg_t const *const right,
                                           bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_cuttseg_is_empty(left);
    bool const right_empty = bib_cuttseg_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    bib_calln_comparison_t result = status;
    result = bib_cutter_compare(result, &(left->cutter), &(right->cutter), specify);
    result = bib_dateord_compare(result, &(left->dateord), &(right->dateord), specify);
    return result;
}

bib_calln_comparison_t bib_dateord_compare(bib_calln_comparison_t const status,
                                           bib_dateord_t const *const left, bib_dateord_t const *const right,
                                           bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_dateord_is_empty(left);
    bool const right_empty = bib_dateord_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    if (left->kind != right->kind) {
        return (left->kind == bib_dateord_kind_ordinal) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    switch (left->kind) {
        case bib_dateord_kind_date:
            return bib_date_compare(status, &(left->date), &(right->date), specify);
        case bib_dateord_kind_ordinal:
            return bib_ordinal_compare(status, &(left->ordinal), &(right->ordinal), specify);
    }
}

bib_calln_comparison_t bib_specification_compare(bib_calln_comparison_t const status,
                                                 bib_lc_specification_t const *const left,
                                                 bib_lc_specification_t const *const right,
                                                 bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_lc_specification_is_empty(left);
    bool const right_empty = bib_lc_specification_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    switch (left->kind) {
        case bib_lc_specification_kind_date:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                    return bib_date_compare(status, &(left->date), &(right->date), specify);

                case bib_lc_specification_kind_word:
                case bib_lc_specification_kind_ordinal:
                case bib_lc_specification_kind_volume:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_word:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                    return bib_calln_ordered_descending;

                case bib_lc_specification_kind_word:
                    return bib_string_specify_compare(status, left->word, right->word, specify);

                case bib_lc_specification_kind_ordinal:
                case bib_lc_specification_kind_volume:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_ordinal:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                case bib_lc_specification_kind_word:
                    return  bib_calln_ordered_descending;

                case bib_lc_specification_kind_ordinal:
                    return bib_ordinal_compare(status, &(left->ordinal), &(right->ordinal), specify);

                case bib_lc_specification_kind_volume:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_volume:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                case bib_lc_specification_kind_word:
                case bib_lc_specification_kind_ordinal:
                    return bib_calln_ordered_descending;

                case bib_lc_specification_kind_volume:
                    return bib_volume_compare(status, &(left->volume), &(right->volume), specify);
            }
    }
}

bib_calln_comparison_t bib_year_compare(bib_calln_comparison_t const status,
                                        bib_year_b const left, bib_year_b const right, bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    if (status == bib_calln_ordered_specifying && bib_str_is_empty(left)) { return bib_calln_ordered_ascending; }
    int const left_year = (bib_str_is_empty(left) ? 0 : atoi(left));
    int const right_year = (bib_str_is_empty(right) ? 0 : atoi(right));
    if (left_year != right_year) {
        if (specify && left_year == 0) {
            if (status == bib_calln_ordered_same) { return bib_calln_ordered_specifying; }
            if (status == bib_calln_ordered_specifying) { return bib_calln_ordered_specifying; }
        }
        return (left_year < right_year) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    return status;
}

bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t const status,
                                        bib_date_t const *const left, bib_date_t const *const right, bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_date_is_empty(left);
    bool const right_empty = bib_date_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    bib_calln_comparison_t result = status;
    result = bib_year_compare(result, left->year, right->year, specify);
    result = bib_year_compare(result, left->span, right->span, specify);
    result = bib_string_specify_compare(result, left->mark, right->mark, specify);
    return result;
}

bib_calln_comparison_t bib_cutter_compare(bib_calln_comparison_t const status,
                                          bib_cutter_t const *const left, bib_cutter_t const *const right,
                                          bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_cutter_is_empty(left);
    bool const right_empty = bib_cutter_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    char const lefta = toupper(left->letter);
    char const righta = toupper(right->letter);
    if (lefta < righta) {
        return bib_calln_ordered_ascending;
    } else if (lefta > righta) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    bib_calln_comparison_t result = status;
    result = bib_string_specify_compare(result, left->number, right->number, specify);
    result = bib_string_specify_compare(result, left->mark, right->mark, specify);
    return result;
}

bib_calln_comparison_t bib_volume_compare(bib_calln_comparison_t const status,
                                          bib_volume_t const *const left, bib_volume_t const *const right,
                                          bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_volume_is_empty(left);
    bool const right_empty = bib_volume_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    bib_calln_comparison_t result = status;
    result = bib_string_specify_compare(result, left->prefix, right->prefix, specify);
    result = bib_string_specify_compare(result, left->number, right->number, specify);
    return result;
}

bib_calln_comparison_t bib_ordinal_compare(bib_calln_comparison_t status,
                                           bib_ordinal_t const *const left, bib_ordinal_t const *const right,
                                           bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_ordinal_is_empty(left);
    bool const right_empty = bib_ordinal_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    bib_calln_comparison_t result = status;
    result = bib_string_specify_compare(result, left->number, right->number, specify);
    result = bib_string_specify_compare(result, left->suffix, right->suffix, specify);
    return result;
}

#pragma mark - string comparison

static bib_calln_comparison_t bib_string_specify_compare_base(bib_calln_comparison_t status,
                                                              char const *const prefix, char const *const string)
{
    switch (status) {
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending: {
            return status;
        }
        case bib_calln_ordered_same:
            if (prefix == NULL && string == NULL) { return bib_calln_ordered_same; }
            else if (prefix == NULL && string != NULL) { return bib_calln_ordered_specifying; }
            else if (prefix != NULL && string == NULL) { return bib_calln_ordered_descending; }
            for (size_t index = 0; true; index += 1) {
                char const prefix_char = toupper(prefix[index]);
                char const string_char = toupper(string[index]);
                if (prefix_char == '\0') {
                    return (string_char == '\0') ? bib_calln_ordered_same
                                                 : bib_calln_ordered_specifying;
                }
                if (string_char == '\0') {
                    return bib_calln_ordered_descending;
                }
                if (prefix_char < string_char) {
                    return bib_calln_ordered_ascending;
                }
                if (prefix_char > string_char) {
                    return bib_calln_ordered_descending;
                }
            }
        case bib_calln_ordered_specifying: {
            bool empty_prefix = (prefix == NULL) || (prefix[0] == '\0');
            return (empty_prefix) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending;
        }
    }
}

bib_calln_comparison_t bib_string_specify_compare(bib_calln_comparison_t const status,
                                                  char const *const prefix, char const *const string,
                                                  bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }
    bib_calln_comparison_t const result = bib_string_specify_compare_base(status, prefix, string);
    return (!specify && result == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : result;
}
