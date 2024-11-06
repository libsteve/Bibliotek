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

bool bib_supplement_is_empty(bib_supplement_t const *supl)
{
    return (supl == NULL) || (supl->prefix[0] == '\0');
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

static bib_calln_comparison_t bib_integer_compare(bib_calln_comparison_t status, char const *left, char const *right,
                                                  bool specify);

/// Given that the left or right values may be empty, determine whether or not a comparison function
/// should return early with the updated comparison result.
/// - parameter status: A pointer to the comparison result leading up to the current segment's comparison.
/// - parameter left_empty: A flag indicating that the left-hand value is empty.
/// - parameter right_empty: A flag indicating that the right-hand value is empty.
/// - parameter specify: A flag indicating that the comparison should include specializing and generalizing values.
/// - returns: `true` when the comparison function should return early with the current `status` value.
/// - postcondition: `status` is set to the appropriate comparison value for the given `status`, `left_empty`,
///                  `right_empty`, and `specify` values.
static bool bib_should_return_empty_comparison(bib_calln_comparison_t *status, bool left_empty, bool right_empty,
                                               bool specify);

/// Given that the comparison function may consider further segments, determine whether or not it should
/// return early with the updated comparison result.
/// - parameter status: A pointer to the comparison result leading up to the current segment's comparison.
/// - parameter same_result: The value that `status` should be set to if it is equal to `bib_calln_ordered_same`.
/// - parameter specify: A flag indicating that the comparison should include specializing and generalizing values.
/// - returns: `true` when the comparison function should return early with the current `status` value.
/// - postcondition: `status` is set to the appropriate comparison value for the given `status`, `same_result`, and
///                  `specify` values.
/// - note: If `same_result` is set to either `bib_calln_ordered_generalizing` or `bib_calln_ordered_specifying`
///         when `specify` is `false`, then `status` will be set to `bib_calln_ordered_descending` and
///        `bib_calln_ordered_ascending` respectively instead of their exact value.
static bool bib_should_return_after_normalization(bib_calln_comparison_t *status, bib_calln_comparison_t same_result,
                                                  bool specify);

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
    result = bib_decimal_specify_compare(result, left->decimal, right->decimal, specify);

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
                result = (specify) ? bib_calln_ordered_generalizing : bib_calln_ordered_descending;
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
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_cuttseg_is_empty(left);
    bool const right_empty = bib_cuttseg_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    result = bib_cutter_compare(result, &(left->cutter), &(right->cutter), specify);
    result = bib_dateord_compare(result, &(left->dateord), &(right->dateord), specify);
    return result;
}

bib_calln_comparison_t bib_dateord_compare(bib_calln_comparison_t const status,
                                           bib_dateord_t const *const left, bib_dateord_t const *const right,
                                           bool specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_dateord_is_empty(left);
    bool const right_empty = bib_dateord_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
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
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_lc_specification_is_empty(left);
    bool const right_empty = bib_lc_specification_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    switch (left->kind) {
        case bib_lc_specification_kind_date:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                    return bib_date_compare(result, &(left->date), &(right->date), specify);

                case bib_lc_specification_kind_word:
                case bib_lc_specification_kind_ordinal:
                case bib_lc_specification_kind_volume:
                case bib_lc_specification_kind_supplement:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_word:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                    return bib_calln_ordered_descending;

                case bib_lc_specification_kind_word:
                    return bib_string_specify_compare(result, left->word, right->word, specify);

                case bib_lc_specification_kind_ordinal:
                case bib_lc_specification_kind_volume:
                case bib_lc_specification_kind_supplement:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_ordinal:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                case bib_lc_specification_kind_word:
                    return  bib_calln_ordered_descending;

                case bib_lc_specification_kind_ordinal:
                    return bib_ordinal_compare(result, &(left->ordinal), &(right->ordinal), specify);

                case bib_lc_specification_kind_volume:
                case bib_lc_specification_kind_supplement:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_volume:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                case bib_lc_specification_kind_word:
                case bib_lc_specification_kind_ordinal:
                    return bib_calln_ordered_descending;

                case bib_lc_specification_kind_volume:
                    return bib_volume_compare(result, &(left->volume), &(right->volume), specify);

                case bib_lc_specification_kind_supplement:
                    return bib_calln_ordered_ascending;
            }

        case bib_lc_specification_kind_supplement:
            switch (right->kind) {
                case bib_lc_specification_kind_date:
                case bib_lc_specification_kind_word:
                case bib_lc_specification_kind_ordinal:
                case bib_lc_specification_kind_volume:
                    return bib_calln_ordered_descending;

                case bib_lc_specification_kind_supplement:
                    return bib_supplement_compare(result, &(left->supplement), &(right->supplement), specify);
            }
    }
}

bib_calln_comparison_t bib_year_compare(bib_calln_comparison_t const status,
                                        bib_year_b const left, bib_year_b const right, bool const specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_str_is_empty(left);
    bool const right_empty = bib_str_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    int const left_year = (left_empty ? 0 : atoi(left));
    int const right_year = (right_empty ? 0 : atoi(right));
    if (left_year != right_year) {
        if (specify) {
            if (left_empty) {
                switch (result) {
                    case bib_calln_ordered_same: return bib_calln_ordered_specifying;
                    case bib_calln_ordered_specifying: return bib_calln_ordered_specifying;
                    case bib_calln_ordered_generalizing: return bib_calln_ordered_descending;
                    default: return result;
                }
            } else if (right_empty) {
                switch (result) {
                    case bib_calln_ordered_same: return bib_calln_ordered_generalizing;
                    case bib_calln_ordered_generalizing: return bib_calln_ordered_generalizing;
                    case bib_calln_ordered_specifying: return bib_calln_ordered_ascending;
                    default: return result;
                }
            }
        }
        return (left_year < right_year) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }
    return status;
}

bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t const status,
                                        bib_date_t const *const left, bib_date_t const *const right, bool const specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_date_is_empty(left);
    bool const right_empty = bib_date_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    result = bib_year_compare(result, left->year, right->year, specify);
    switch (result) {
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending: return result;
        default: break;
    }
    if (left->isspan) {
        if (right->isspan) {
            result = bib_year_compare(result, left->span, right->span, specify);
        } else if (right->isdate) {
            if (bib_should_return_after_normalization(&result, bib_calln_ordered_specifying, specify)) {
                return result;
            }
        } else {
            if (bib_should_return_after_normalization(&result, bib_calln_ordered_specifying, specify)) {
                return result;
            }
        }
    } else if (left->isdate) {
        if (right->isspan) {
            if (bib_should_return_after_normalization(&result, bib_calln_ordered_generalizing, specify)) {
                return result;
            }
        } else if (right->isdate) {

            if (left->month != right->month) {
                if (bib_should_return_after_normalization(&result, bib_calln_ordered_same, specify)) {
                    return result;
                } else {
                    return (left->month < right->month) ? bib_calln_ordered_ascending
                                                        : bib_calln_ordered_descending;
                }
            } else {
                if (left->day != right->day) {
                    switch (result) {
                        case bib_calln_ordered_same:
                            if (left->day == 0 && specify) {
                                result = bib_calln_ordered_specifying;
                            } else if (right->day == 0 && specify) {
                                result = bib_calln_ordered_generalizing;
                            } else {
                                return (left->day < right->day) ? bib_calln_ordered_ascending
                                                                : bib_calln_ordered_descending;
                            }
                            break;
                        case bib_calln_ordered_specifying:
                            if (left->day > 0 || !specify) {
                                return bib_calln_ordered_ascending;
                            }
                            break;
                        case bib_calln_ordered_generalizing:
                            if (right->day > 0 || !specify) {
                                return bib_calln_ordered_ascending;
                            }
                            break;
                        case bib_calln_ordered_ascending:
                        case bib_calln_ordered_descending:
                            return result;
                    }
                }
            }
        } else {
            if (bib_should_return_after_normalization(&result, bib_calln_ordered_generalizing, specify)) {
                return result;
            }
        }
    } else {
        if (right->isspan) {
            if (bib_should_return_after_normalization(&result, bib_calln_ordered_generalizing, specify)) {
                return result;
            }
        } else if (right->isdate) {
            if (bib_should_return_after_normalization(&result, bib_calln_ordered_specifying, specify)) {
                return result;
            }
        }
    }
    result = bib_string_specify_compare(result, left->mark, right->mark, specify);
    return result;
}

bib_calln_comparison_t bib_cutter_compare(bib_calln_comparison_t const status,
                                          bib_cutter_t const *const left, bib_cutter_t const *const right,
                                          bool const specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_cutter_is_empty(left);
    bool const right_empty = bib_cutter_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    char const lefta = toupper(left->letter);
    char const righta = toupper(right->letter);
    if (lefta < righta) {
        return (status == bib_calln_ordered_generalizing) ? bib_calln_ordered_descending : bib_calln_ordered_ascending;
    } else if (lefta > righta) {
        return (status == bib_calln_ordered_specifying) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }
    result = bib_decimal_specify_compare(result, left->number, right->number, false);
    result = bib_decimal_specify_compare(result, left->mark, right->mark, specify);
    return result;
}

bib_calln_comparison_t bib_volume_compare(bib_calln_comparison_t const status,
                                          bib_volume_t const *const left, bib_volume_t const *const right,
                                          bool const specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_volume_is_empty(left);
    bool const right_empty = bib_volume_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    result = bib_string_specify_compare(result, left->prefix, right->prefix, specify);
    result = bib_string_specify_compare(result, left->number, right->number, specify);
    if (left->hasetc != right->hasetc) {
        switch (result) {
            case bib_calln_ordered_ascending:
            case bib_calln_ordered_descending:
                break;
            case bib_calln_ordered_same:
                if (specify) {
                    result = (left->hasetc) ? bib_calln_ordered_generalizing : bib_calln_ordered_specifying;
                } else {
                    result = (left->hasetc) ? bib_calln_ordered_descending : bib_calln_ordered_ascending;
                }
                break;
            case bib_calln_ordered_specifying:
                result = (right->hasetc) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending;
                break;
            case bib_calln_ordered_generalizing:
                result = (left->hasetc) ? bib_calln_ordered_generalizing : bib_calln_ordered_descending;
                break;
        }
    }
    return result;
}

bib_calln_comparison_t bib_ordinal_compare(bib_calln_comparison_t status,
                                           bib_ordinal_t const *const left, bib_ordinal_t const *const right,
                                           bool specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_ordinal_is_empty(left);
    bool const right_empty = bib_ordinal_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    result = bib_string_specify_compare(result, left->number, right->number, specify);
    result = bib_string_specify_compare(result, left->suffix, right->suffix, specify);
    return result;
}

bib_calln_comparison_t bib_supplement_compare(bib_calln_comparison_t status,
                                              bib_supplement_t const *const left, bib_supplement_t const *const right,
                                              bool specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_supplement_is_empty(left);
    bool const right_empty = bib_supplement_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    result = bib_string_specify_compare(result, left->prefix, right->prefix, specify);
    result = bib_string_specify_compare(result, left->number, right->number, specify);
    if (left->hasetc != right->hasetc) {
        switch (result) {
            case bib_calln_ordered_ascending:
            case bib_calln_ordered_descending:
                break;
            case bib_calln_ordered_same:
                result = (left->hasetc) ? bib_calln_ordered_descending : bib_calln_ordered_ascending;
                break;
            case bib_calln_ordered_specifying:
                result = (right->hasetc) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending;
                break;
            case bib_calln_ordered_generalizing:
                result = (left->hasetc) ? bib_calln_ordered_generalizing : bib_calln_ordered_descending;
                break;
        }
    }
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
                    return bib_calln_ordered_generalizing;
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
        case bib_calln_ordered_generalizing: {
            bool empty_suffix = (string == NULL) || (string[0] == '\0');
            return (empty_suffix) ? bib_calln_ordered_generalizing : bib_calln_ordered_descending;
        }
    }
}

bib_calln_comparison_t bib_string_specify_compare(bib_calln_comparison_t const status,
                                                  char const *const prefix, char const *const string,
                                                  bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }
    bib_calln_comparison_t const result = bib_string_specify_compare_base(status, prefix, string);
    switch (result) {
        case bib_calln_ordered_specifying: return (specify) ? result : bib_calln_ordered_ascending;
        case bib_calln_ordered_generalizing: return (specify) ? result : bib_calln_ordered_descending;
        default: return result;
    }
}

#pragma mark decimal comparison

static bib_calln_comparison_t bib_decimal_specify_compare_base(bib_calln_comparison_t status,
                                                               char const *const left, char const *const right)
{
    bool const left_is_empty = (left == NULL || left[0] == '\0');
    bool const right_is_empty = (right == NULL || right[0] == '\0');
    switch (status) {
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending: {
            return status;
        }
        case bib_calln_ordered_same:
            if (left_is_empty && right_is_empty) { return bib_calln_ordered_same; }
            else if (left_is_empty && !right_is_empty) { return bib_calln_ordered_specifying; }
            else if (!left_is_empty && right_is_empty) { return bib_calln_ordered_generalizing; }
            for (size_t index = 0; true; index += 1) {
                char const prefix_char = toupper(left[index]);
                char const string_char = toupper(right[index]);
                if (prefix_char == '\0') {
                    return (string_char == '\0') ? bib_calln_ordered_same
                                                 : bib_calln_ordered_ascending;
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
            bool empty_prefix = (left == NULL) || (left[0] == '\0');
            return (empty_prefix) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending;
        }
        case bib_calln_ordered_generalizing: {
            bool empty_suffix = (right == NULL) || (right[0] == '\0');
            return (empty_suffix) ? bib_calln_ordered_generalizing : bib_calln_ordered_descending;
        }
    }
}

bib_calln_comparison_t bib_decimal_specify_compare(bib_calln_comparison_t const status,
                                                   char const *const left, char const *const right,
                                                   bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }
    bib_calln_comparison_t const result = bib_decimal_specify_compare_base(status, left, right);
    switch (result) {
        case bib_calln_ordered_specifying: return (specify) ? result : bib_calln_ordered_ascending;
        case bib_calln_ordered_generalizing: return (specify) ? result : bib_calln_ordered_descending;
        default: return result;
    }
}

#pragma mark -

static bib_calln_comparison_t bib_integer_compare(bib_calln_comparison_t const status,
                                                  char const *const left, char const *const right,
                                                  bool const specify)
{
    bib_calln_comparison_t result = status;
    bool const left_empty = bib_str_is_empty(left);
    bool const right_empty = bib_str_is_empty(right);
    if (bib_should_return_empty_comparison(&result, left_empty, right_empty, specify)) {
        return result;
    }
    int const left_int = atoi(left);
    int const right_int = atoi(right);
    switch (result) {
        case bib_calln_ordered_same:
            if (left_int != right_int) {
                return (left_int < right_int) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
            } else {
                return bib_calln_ordered_same;
            }
        case bib_calln_ordered_specifying:
            return bib_calln_ordered_ascending;
        case bib_calln_ordered_generalizing:
            return bib_calln_ordered_descending;
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending:
            return result;
    }
}


static bool bib_should_return_empty_comparison(bib_calln_comparison_t *const status,
                                               bool const left_empty, bool const right_empty,
                                               bool const specify)
{
    if (status == NULL) {
        return false;
    }
    if (left_empty && right_empty) {
        return true;
    }
    switch (*status) {
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending:
            return true;
        case bib_calln_ordered_same:
            if (left_empty) {
                *status = (specify) ? bib_calln_ordered_specifying : bib_calln_ordered_ascending;
                return true;
            } else if (right_empty) {
                *status = (specify) ? bib_calln_ordered_generalizing : bib_calln_ordered_descending;
                return true;
            } else {
                return false;
            }
            return false;
        case bib_calln_ordered_specifying:
            if (left_empty) {
                *status = (specify) ? *status : bib_calln_ordered_ascending;
                return true;
            } else if (right_empty) {
                *status = bib_calln_ordered_ascending;
                return true;
            } else {
                return false;
            }
        case bib_calln_ordered_generalizing:
            if (right_empty) {
                *status = (specify) ? *status : bib_calln_ordered_descending;
                return true;
            } else if (left_empty) {
                *status = bib_calln_ordered_descending;
                return true;
            } else {
                return false;
            }
    }
}

static bool bib_should_return_after_normalization(bib_calln_comparison_t *const status,
                                                  bib_calln_comparison_t const same_result,
                                                  bool const specify)
{
    if (status == NULL) {
        return false;
    }
    switch (*status) {
        case bib_calln_ordered_same:
            switch (same_result) {
                case bib_calln_ordered_same:
                    return false;
                case bib_calln_ordered_generalizing:
                    *status = (specify) ? same_result : bib_calln_ordered_descending;
                    return !specify;
                case bib_calln_ordered_specifying:
                    *status = (specify) ? same_result : bib_calln_ordered_ascending;
                    return !specify;
                case bib_calln_ordered_ascending:
                case bib_calln_ordered_descending:
                    *status = same_result;
                    return true;
            }
        case bib_calln_ordered_specifying:
            *status = bib_calln_ordered_ascending;
            return true;
        case bib_calln_ordered_generalizing:
            *status = bib_calln_ordered_descending;
            return true;
        case bib_calln_ordered_ascending:
        case bib_calln_ordered_descending:
            return true;
    }
}
