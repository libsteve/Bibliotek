//
//  bibtype.c
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#include "bibtype.h"
#include <stdlib.h>
#include <string.h>
#include "bibparse.h"

bool bib_lc_callnum_init(bib_lc_callnum_t *const num, char const *const str)
{
    if (num == NULL || str == NULL) { return false; }
    memset(num, 0, sizeof(bib_lc_callnum_t));
    char const *string = str;
    size_t      length = strlen(str) + 1;
    bool parse_success = bib_parse_lc_callnum(num, &string, &length);
    bool total_success = parse_success && (length == 1);
    if (parse_success && !total_success) {
        bib_lc_callnum_deinit(num);
    }
    return total_success;
}

void bib_lc_callnum_deinit(bib_lc_callnum_t *const num)
{
    if (num == NULL) { return; }
    if (num->special   != NULL) { free(num->special);   num->special   = NULL; }
    if (num->remainder != NULL) { free(num->remainder); num->remainder = NULL; }
}

#pragma mark lc special

void bib_lc_special_init(bib_lc_special_t *const spc, typeof(spc->spec) spec) {
    if (spc == NULL) { return; }
    memset(spc, 0, sizeof(bib_lc_special_t));
    spc->spec = spec;
}

void bib_lc_special_list_append(bib_lc_special_t **const spc_list, size_t *const spc_size,
                                bib_lc_special_t  *const spc_buff, size_t  const buff_len) {
    if (spc_list == NULL || spc_size == NULL || spc_buff == NULL || buff_len == 0) {
        return;
    }
    if (*spc_list == NULL && *spc_size != 0) {
        return;
    }
    size_t const prev_end_index = *spc_size;
    *spc_size = prev_end_index + buff_len;
    *spc_list = (*spc_list == NULL) ? malloc(sizeof(bib_lc_special_t))
                                    : realloc(*spc_list, *spc_size * sizeof(bib_lc_special_t));
    memcpy(&((*spc_list)[prev_end_index]), spc_buff, buff_len * sizeof(bib_lc_special_t));
}

void bib_lc_special_list_deinit(bib_lc_special_t **const spc_list, size_t *const spc_size)
{
    if (spc_list == NULL || spc_size == NULL || *spc_list == NULL || *spc_size == 0) {
        return;
    }
    free(*spc_list);
    *spc_size = 0;
}

#pragma mark -

bib_calln_comparison_t bib_lc_callnum_compare(bib_calln_comparison_t const status,
                                              bib_lc_callnum_t const *left, bib_lc_callnum_t const *right,
                                              bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bib_calln_comparison_t result = status;

    // caption
    result = bib_lc_caption_compare(result, &(left->caption), &(right->caption), specify);
    if (result == bib_calln_ordered_ascending) { return result; }
    if (result == bib_calln_ordered_descending) { return result; }
    if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }

    // cutters
    for (size_t index = 0; index < 3; index += 1) {
        result = bib_cutter_compare(result, &(left->cutters[index]), &(right->cutters[index]), specify);
        if (result == bib_calln_ordered_ascending) { return result; }
        if (result == bib_calln_ordered_descending) { return result; }
        if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }
    }

    // suffix
    result = string_specialized_compare(result, left->suffix, right->suffix);
    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
    if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }

    // work mark
    result = string_specialized_compare(result, left->workmark, right->workmark);
    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
    if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }

    // special

    return (bib_calln_comparison_t)result;
}

bib_calln_comparison_t bib_lc_caption_compare(bib_calln_comparison_t const status,
                                              bib_lc_caption_t const *left, bib_lc_caption_t const *right,
                                              bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bib_calln_comparison_t result = status;

    // letter
    result = string_specialized_compare(result, left->letters, right->letters);
    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
    if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }

    // integer
    if (result == string_specialized_ordered_specifying && (left->integer[0] != '\0')) { return bib_calln_ordered_ascending; }
    int const left_num = (left->integer[0] == '\0') ? 0 : atoi(left->integer);
    int const right_num = (right->integer[0] == '\0') ? 0 : atoi(right->integer);
    if (left_num != right_num) { return (left_num < right_num) ? bib_calln_ordered_ascending : bib_calln_ordered_descending; }

    // decimal
    result = string_specialized_compare(result, left->decimal, right->decimal);
    if (!specify && result == string_specialized_ordered_specifying) { return bib_calln_ordered_ascending; }

    // date
    result = bib_date_compare(result, &(left->date), &(right->date), specify);
    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
    if (!specify && result == string_specialized_ordered_specifying) { return bib_calln_ordered_ascending; }

    // ordinal
    result = bib_ordinal_compare(result, &(left->ordinal), &(right->ordinal), specify);
    if (!specify && result == string_specialized_ordered_specifying) { return bib_calln_ordered_ascending; }

    return (bib_calln_comparison_t)result;
}

bib_calln_comparison_t bib_lc_special_compare(bib_calln_comparison_t const status,
                                              bib_lc_special_t const *left, bib_lc_special_t const *right, bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    bib_calln_comparison_t result = status;

    switch (left->spec) {
        case bib_lc_special_spec_date:
            switch (right->spec) {
                case bib_lc_special_spec_date: {
                    result = bib_date_compare(result, &(left->value.date), &(right->value.date), specify);
                    return result;
                }
                case bib_lc_special_spec_suffix: return bib_calln_ordered_ascending;
                case bib_lc_special_spec_ordinal: return bib_calln_ordered_ascending;
                case bib_lc_special_spec_datespan: return bib_calln_ordered_ascending;
                case bib_lc_special_spec_workmark: return bib_calln_ordered_ascending;
            }
        case bib_lc_special_spec_suffix:
            switch (right->spec) {
                case bib_lc_special_spec_date: return bib_calln_ordered_descending;
                case bib_lc_special_spec_suffix: {
                    result = string_specialized_compare(result, left->value.suffix, right->value.suffix);
                    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
                    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
                    if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }
                    return result;
                }
                case bib_lc_special_spec_ordinal: return bib_calln_ordered_ascending;
                case bib_lc_special_spec_datespan: return bib_calln_ordered_ascending;
                case bib_lc_special_spec_workmark: return bib_calln_ordered_ascending;
            }
        case bib_lc_special_spec_ordinal:
            switch (right->spec) {
                case bib_lc_special_spec_date: return bib_calln_ordered_descending;
                case bib_lc_special_spec_suffix: return bib_calln_ordered_descending;
                case bib_lc_special_spec_ordinal: {
                    return bib_ordinal_compare(result, &(left->value.ordinal), &(right->value.ordinal), specify);
                }
                case bib_lc_special_spec_datespan: return bib_calln_ordered_ascending;
                case bib_lc_special_spec_workmark: return bib_calln_ordered_ascending;
            }
        case bib_lc_special_spec_datespan:
            switch (right->spec) {
                case bib_lc_special_spec_date: return bib_calln_ordered_descending;
                case bib_lc_special_spec_suffix: return bib_calln_ordered_descending;
                case bib_lc_special_spec_ordinal: return bib_calln_ordered_descending;
                case bib_lc_special_spec_datespan: {
                    result = bib_date_compare(result, &(left->value.datespan.year), &(right->value.datespan.year), specify);
                    result = bib_date_compare(result, &(left->value.datespan.span), &(right->value.datespan.span), specify);
                    return result;
                }
                case bib_lc_special_spec_workmark: return bib_calln_ordered_ascending;
            }
        case bib_lc_special_spec_workmark:
            switch (right->spec) {
                case bib_lc_special_spec_date: return bib_calln_ordered_descending;
                case bib_lc_special_spec_suffix: return bib_calln_ordered_descending;
                case bib_lc_special_spec_ordinal: return bib_calln_ordered_descending;
                case bib_lc_special_spec_datespan: return bib_calln_ordered_descending;
                case bib_lc_special_spec_workmark:  {
                    result = string_specialized_compare(result, left->value.workmark, right->value.workmark);
                    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
                    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
                    if (!specify && result == bib_calln_ordered_specifying) { return bib_calln_ordered_ascending; }
                    return result;
                }
            }
    }
    return (bib_calln_comparison_t)status;
}

bib_calln_comparison_t bib_ordinal_compare(bib_calln_comparison_t const status,
                                           bib_ordinal_t const *left, bib_ordinal_t const *right, bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    int const left_num = (left->number[0] == '\0') ? 0 : atoi(left->number);
    int const right_num = (right->number[0] == '\0') ? 0 : atoi(right->number);
    if (left_num != right_num) { return (left_num < right_num) ? bib_calln_ordered_ascending : bib_calln_ordered_descending; }

    bib_calln_comparison_t result = status;
    result = string_specialized_compare(result, left->suffix, right->suffix);
    if (!specify && result == string_specialized_ordered_specifying) { return bib_calln_ordered_ascending; }

    return (bib_calln_comparison_t)result;
}

bib_calln_comparison_t bib_cutter_compare(bib_calln_comparison_t const status,
                                          bib_cutter_t const *left, bib_cutter_t const *right, bool specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    if (left->number[0] == '\0' && right->number[0] == '\0') { return status; }

    bib_calln_comparison_t result = status;

    result = string_specialized_compare(result, left->number, right->number);
    if (result == string_specialized_ordered_ascending) { return result; }
    if (result == string_specialized_ordered_descending) { return result; }
    if (!specify && result == string_specialized_ordered_specifying) { return bib_calln_ordered_ascending; }

    result = bib_date_compare(result, &(left->date), &(right->date), specify);
    if (result == string_specialized_ordered_ascending) { return bib_calln_ordered_ascending; }
    if (result == string_specialized_ordered_descending) { return bib_calln_ordered_descending; }
    if (!specify && result == string_specialized_ordered_specifying) { return bib_calln_ordered_ascending; }

    return (bib_calln_comparison_t)result;
}

bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t const status,
                                        bib_date_t const *left, bib_date_t const *right, bool const specify)
{
    if (status == bib_calln_ordered_ascending || status == bib_calln_ordered_descending) { return status; }

    if (status == string_specialized_ordered_specifying && ((*left)[0] != '\0')) { return bib_calln_ordered_ascending; }
    int const left_date = ((*left)[0] == '\0') ? 0 : atoi(*left);
    int const right_date = ((*right)[0] == '\0') ? 0 : atoi(*right);
    if (left_date != right_date) {
        if (specify && left_date == 0) {
            if (status == string_specialized_ordered_same) { return bib_calln_ordered_specifying; }
            if (status == string_specialized_ordered_specifying) { return bib_calln_ordered_specifying; }
        }
        return (left_date < right_date) ? bib_calln_ordered_ascending : bib_calln_ordered_descending;
    }

    return status;
}

//bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t const status,
//                                        bib_date_t const *left, bib_date_t const *right, bool const specify)
//{
//    bib_calln_comparison_t result = status;
//    result = bib_date_compare__(result, left->year, right->year, specify);
//    result = bib_date_compare__(result, left->span, right->span, specify);
//    return result;
//}

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
