//
//  bibtype.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#ifndef bibtype_h
#define bibtype_h

#include <stdlib.h>
#include <stddef.h>
#include <stdbool.h>

__BEGIN_DECLS

static size_t const bib_letters_size =  3;
static size_t const bib_integer_size =  4;
static size_t const bib_digit16_size = 16;
static size_t const bib_datenum_size =  4;
static size_t const bib_suffix_size  =  3;
static size_t const bib_lcalpha_size =  3;
static size_t const bib_cuttern_size = bib_digit16_size;

typedef struct bib_ordinal {
    char number[bib_digit16_size + 1];
    char suffix[bib_suffix_size  + 2];
} bib_ordinal_t;

typedef char bib_date_t[bib_datenum_size + 1];

typedef struct bib_datespan {
    bib_date_t year;
    char separator;
    bib_date_t span;
} bib_datespan_t;

typedef struct bib_cutter {
    char number[bib_cuttern_size + 1];
    char date  [bib_datenum_size + 1];
    char suffix[bib_suffix_size  + 2];
} bib_cutter_t;

typedef struct bib_lc_special {
    enum {
        bib_lc_special_spec_date = 1,
        bib_lc_special_spec_suffix,
        bib_lc_special_spec_workmark,
        bib_lc_special_spec_ordinal,
        bib_lc_special_spec_datespan
    } spec;
    union {
        bib_date_t date;
        char suffix  [bib_suffix_size  + 1];
        char workmark[bib_suffix_size  + 1];
        bib_ordinal_t ordinal;
        bib_datespan_t datespan;
    } value;
} bib_lc_special_t;

typedef struct bib_lc_caption {
    char letters[bib_letters_size + 1];
    char integer[bib_integer_size + 1];
    char decimal[bib_digit16_size + 1];
    char date   [bib_datenum_size + 1];
    bib_ordinal_t ordinal;
} bib_lc_caption_t;

typedef struct bib_lc_callnum {
    bib_lc_caption_t caption;
    bib_cutter_t cutters[3];
    char suffix  [bib_suffix_size + 1];
    char workmark[bib_suffix_size + 1];
    bib_lc_special_t *special;
    size_t special_count;
    char *remainder;
} bib_lc_callnum_t;

#pragma mark -

extern bool bib_lc_callnum_init  (bib_lc_callnum_t *num, char const *str);
extern void bib_lc_callnum_deinit(bib_lc_callnum_t *num);

extern void bib_lc_special_init(bib_lc_special_t *spc, typeof(spc->spec) spec);
extern void bib_lc_special_list_append(bib_lc_special_t **spc_list, size_t *spc_size,
                                       bib_lc_special_t  *spc_buff, size_t  buff_len);
extern void bib_lc_special_list_deinit(bib_lc_special_t **spc_list, size_t *spc_size);

#pragma mark -

typedef enum bib_calln_comparison {
    bib_calln_ordered_descending = -1,
    bib_calln_ordered_same       =  0,
    bib_calln_ordered_ascending  =  1,
    bib_calln_ordered_specifying =  2
} bib_calln_comparison_t;

extern bib_calln_comparison_t bib_lc_callnum_compare(bib_calln_comparison_t status, bib_lc_callnum_t const *left, bib_lc_callnum_t const *right, bool specify);
extern bib_calln_comparison_t bib_lc_caption_compare(bib_calln_comparison_t status, bib_lc_caption_t const *left, bib_lc_caption_t const *right, bool specify);
extern bib_calln_comparison_t bib_lc_special_compare(bib_calln_comparison_t status, bib_lc_special_t const *left, bib_lc_special_t const *right, bool specify);
extern bib_calln_comparison_t bib_ordinal_compare(bib_calln_comparison_t status, bib_ordinal_t const *left, bib_ordinal_t const *right, bool specify);
extern bib_calln_comparison_t bib_cutter_compare(bib_calln_comparison_t status, bib_cutter_t const *left, bib_cutter_t const *right, bool specify);
extern bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t status, bib_date_t const *left, bib_date_t const *right, bool specify);

#pragma mark -

typedef enum string_specialized_comparison_result {
    /// The \c string is lexically ordered before the \c prefix and therefore does not specialize it.
    string_specialized_ordered_descending = -1,

    /// The \c string does begin with \c prefix and they are equal.
    string_specialized_ordered_same       =  0,

    /// The \c string is lexically ordered after the \c prefix in a way that does not specialize it.
    string_specialized_ordered_ascending  =  1,

    /// The \c string does begin with \c prefix but they are not equal.
    string_specialized_ordered_specifying =  2
} string_specialized_comparison_result_t;

/// Determine if the given \c string begins with the given \c prefix and whether or not they are equal.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param prefix A prefix string search for.
/// \param string A string that may or may not begin with or euqal to the given prefix
/// \returns \c string_specialization_none when the string does begin with the given prefix
/// \returns \c string_specialization_none when the status is set to \c string_specialization_none
/// \returns \c string_specialization_none when the status is \c string_specialization_found
///          and the given prefix is not the empty string.
/// \returns \c string_specialization_maybe when the status is set to \c string_specialization_maybe
///          and the string and prefix are equivalent.
/// \returns \c string_specialization_found when the string begins with, but is not equal to, the given prefix.
/// \returns \c string_specialization_found when the status is set to \c string_specialization_found
///          and the given prefix is empty the empty string.
extern bib_calln_comparison_t string_specialized_compare(bib_calln_comparison_t status,
                                                                         char const *prefix,
                                                                         char const *string);

__END_DECLS

#endif /* bibtype_h */
