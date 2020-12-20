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
    char const *string = str;
    size_t      length = strlen(str) + 1;
    bool parse_success = bib_parse_lc_calln(num, &string, &length);
    bool total_success = parse_success && (length == 1);
    if (parse_success && !total_success) {
        bib_lc_calln_deinit(num);
    }
    return total_success;
}

void bib_lc_calln_deinit(bib_lc_calln_t *const num)
{
    if (num == NULL) { return; }
    bib_lc_special_list_deinit(&(num->remainder));
    memset(num, 0, sizeof(bib_lc_calln_t));
}

#pragma mark lc special

void bib_lc_special_init(bib_lc_special_t *const spc, typeof(spc->spec) spec)
{
    if (spc == NULL) { return; }
    memset(spc, 0, sizeof(bib_lc_special_t));
    spc->spec = spec;
}

void bib_lc_special_deinit(bib_lc_special_t *const spc)
{
    if (spc == NULL) { return; }
    memset(spc, 0, sizeof(bib_lc_special_t));
}

void bib_lc_special_list_init(bib_lc_special_list_t *list)
{
    if (list == NULL) { return; }
    memset(list, 0, sizeof(bib_lc_special_list_t));
}

void bib_lc_special_list_append(bib_lc_special_list_t *list, bib_lc_special_t *buff, size_t len)
{
    if (list == NULL || buff == NULL || len == 0) { return; }
    assert(list->buffer != NULL || list->length == 0);
    size_t const prev_end_index = list->length;
    list->length = prev_end_index + len;
    list->buffer = (list->buffer == NULL) ? malloc(sizeof(bib_lc_special_t))
                                          : realloc(list->buffer, list->length * sizeof(bib_lc_special_t));
    memcpy(&(list->buffer[prev_end_index]), buff, len * sizeof(bib_lc_special_t));
}

void bib_lc_special_list_deinit(bib_lc_special_list_t *const list)
{
    if (list == NULL || list->buffer == NULL) { return; }
    free(list->buffer);
    list->buffer = NULL;
    list->length = 0;
}

#pragma mark -

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
    result = bib_lc_number_compare(result, &(left->datenum), &(right->datenum), specify);

    // cutters
    for (size_t index = 0; index < 3; index += 1) {
        bib_lc_cutter_t const *const left_cut = &(left->cutters[index]);
        bib_lc_cutter_t const *const right_cut = &(right->cutters[index]);
        result = bib_lc_cutter_compare(result, left_cut, right_cut, specify);
    }

    // special
    for (size_t index = 0; index < 2; index += 1) {
        bib_lc_special_t const *const left_spc = &(left->special[index]);
        bib_lc_special_t const *const right_spc = &(right->special[index]);
        result = bib_lc_special_compare(result, left_spc, right_spc, specify);
    }

    // remainder
    {
        size_t index = 0;
        size_t const left_len = left->remainder.length;
        size_t const right_len = right->remainder.length;
        for (; (index < left_len) && (index < right_len); index += 1) {
            bib_lc_special_t const *const l = &(left->remainder.buffer[index]);
            bib_lc_special_t const *const r = &(right->remainder.buffer[index]);
            result = bib_lc_special_compare(result, l, r, specify);
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

bib_calln_comparison_t bib_lc_cutter_compare(bib_calln_comparison_t const status,
                                             bib_lc_cutter_t const *const left, bib_lc_cutter_t const *const right,
                                             bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_lc_cutter_is_empty(left);
    bool const right_empty = bib_lc_cutter_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    bib_calln_comparison_t result = status;
    result = bib_cutter_compare(result, &(left->cuttnum), &(right->cuttnum), specify);
    result = bib_lc_number_compare(result, &(left->datenum), &(right->datenum), specify);
    return result;
}

bib_calln_comparison_t bib_lc_number_compare(bib_calln_comparison_t const status,
                                             bib_lc_number_t const *const left, bib_lc_number_t const *const right,
                                             bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_lc_number_is_empty(left);
    bool const right_empty = bib_lc_number_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    if (left->kind != right->kind) {
        return (left->kind == bib_lc_number_ordinal) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    switch (left->kind) {
        case bib_lc_number_date:
            return bib_date_compare(status, &(left->value.date), &(right->value.date), specify);
        case bib_lc_number_ordinal:
            return bib_ordinal_compare(status, &(left->value.ordinal), &(right->value.ordinal), specify);
    }
}

bib_calln_comparison_t bib_lc_special_compare(bib_calln_comparison_t const status,
                                              bib_lc_special_t const *const left, bib_lc_special_t const *const right,
                                              bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bool const left_empty = bib_lc_special_is_empty(left);
    bool const right_empty = bib_lc_special_is_empty(right);
    if (left_empty && right_empty) { return status; }
    else if (left_empty) { return (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending; }
    else if (right_empty) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    switch (left->spec) {
        case bib_lc_special_spec_date:
            switch (right->spec) {
                case bib_lc_special_spec_date:
                    return bib_date_compare(status, &(left->value.date), &(right->value.date), specify);

                case bib_lc_special_spec_word:
                case bib_lc_number_ordinal:
                case bib_lc_special_spec_volume:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_special_spec_word:
            switch (right->spec) {
                case bib_lc_special_spec_date:
                    return bib_calln_ordered_descending;

                case bib_lc_special_spec_word:
                    return bib_string_specify_compare(status, left->value.word, right->value.word, specify);

                case bib_lc_special_spec_ordinal:
                case bib_lc_special_spec_volume:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_special_spec_ordinal:
            switch (right->spec) {
                case bib_lc_special_spec_date:
                case bib_lc_special_spec_word:
                    return  bib_calln_ordered_descending;

                case bib_lc_special_spec_ordinal:
                    return bib_ordinal_compare(status, &(left->value.ordinal), &(right->value.ordinal), specify);

                case bib_lc_special_spec_volume:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_special_spec_volume:
            switch (right->spec) {
                case bib_lc_special_spec_date:
                case bib_lc_special_spec_word:
                case bib_lc_special_spec_ordinal:
                    return bib_calln_ordered_descending;

                case bib_lc_special_spec_volume:
                    return bib_volume_compare(status, &(left->value.volume), &(right->value.volume), specify);
            }
    }
}

bib_calln_comparison_t bib_year_compare(bib_calln_comparison_t const status,
                                        bib_year_t const left, bib_year_t const right, bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    if (status == bib_calln_ordered_specifying && bib_str_is_empty(left)) { return bib_calln_ordered_ascending; }
    int const left_year = (bib_str_is_empty(left) ? 0 : atoi(left));
    int const right_year = (bib_str_is_empty(right) ? 0 : atoi(right));
    if (left_year != right_year) {
        if (specify && left_year == 0) {
            if (status == string_specialized_ordered_same) { return bib_calln_ordered_specifying; }
            if (status == string_specialized_ordered_specifying) { return bib_calln_ordered_specifying; }
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

#pragma mark -

bib_calln_comparison_t string_specialized_compare(bib_calln_comparison_t status,
                                                  char const *const prefix, char const *const string)
{
    switch (status) {
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending: {
            return status;
        }
        case string_specialized_ordered_same:
            if (prefix == NULL && string == NULL) { return bib_calln_ordered_same; }
            else if (prefix == NULL && string != NULL) { return bib_calln_ordered_specifying; }
            else if (prefix != NULL && string == NULL) { return bib_calln_ordered_descending; }
            for (size_t index = 0; true; index += 1) {
                char const prefix_char = prefix[index];
                char const string_char = string[index];
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
        case string_specialized_ordered_specifying: {
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
    bib_calln_comparison_t const result = string_specialized_compare(status, prefix, string);
    return (!specify && result == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : result;
}
