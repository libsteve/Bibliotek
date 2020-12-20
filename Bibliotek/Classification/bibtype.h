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

#pragma mark -

typedef char bib_initial_t;
typedef char bib_alpah03_t[4];
typedef char bib_digit04_t[5];
typedef char bib_digit16_t[17];

typedef char bib_word_t[17];
typedef char bib_numeral_t[17];
typedef char bib_longword_t[25];

typedef char bib_year_t[5];
typedef char bib_mark_t[5];

#pragma mark -

typedef struct bib_date {
    bib_year_t year;
    char separator;
    bib_year_t span;
    bib_mark_t mark;
} bib_date_t;

static inline bool bib_date_is_empty(bib_date_t const *const date) { return (date == NULL) || (date->year[0] == '\0'); }
static inline bool bib_date_has_span(bib_date_t const *const date) { return (date != NULL) && (date->separator != '\0'); }

#pragma mark -

typedef struct bib_cutter {
    bib_initial_t letter;
    bib_digit16_t number;
    bib_mark_t mark;
} bib_cutter_t;

static inline bool bib_cutter_is_empty(bib_cutter_t const *const cut) { return (cut == NULL) || (cut->letter == '\0'); }

#pragma mark -

typedef struct bib_ordinal {
    bib_digit16_t number;
    bib_word_t    suffix;
} bib_ordinal_t;

static inline bool bib_ordinal_is_empty(bib_ordinal_t const *const ord) { return (ord == NULL) || (ord->number[0] == '\0'); }

typedef struct bib_volume {
    bib_word_t    prefix;
    bib_digit16_t number;
} bib_volume_t;

static inline bool bib_volume_is_empty(bib_volume_t const *const vol) { return (vol == NULL) || (vol->prefix[0] == '\0'); }

#pragma mark -

typedef struct bib_lc_special {
    enum {
        bib_lc_special_spec_date = 1,
        bib_lc_special_spec_ordinal,
        bib_lc_special_spec_volume,
        bib_lc_special_spec_word
    } spec;
    union {
        bib_date_t     date;
        bib_ordinal_t  ordinal;
        bib_volume_t   volume;
        bib_longword_t word;
    } value;
} bib_lc_special_t;

static inline bool bib_lc_special_is_empty(bib_lc_special_t const *const spc) { return (spc == NULL) || (spc->spec == 0); }

extern void bib_lc_special_init(bib_lc_special_t *spc, typeof(spc->spec) spec);
extern void bib_lc_special_deinit(bib_lc_special_t *spc);

typedef struct bib_lc_special_list {
    bib_lc_special_t *buffer;
    size_t            length;
} bib_lc_special_list_t;

static inline bool bib_lc_special_list_is_empty(bib_lc_special_list_t const *const list) {
    return (list == NULL) || (list->buffer == NULL) || (list->length == 0);
}

extern void bib_lc_special_list_init  (bib_lc_special_list_t *list);
extern void bib_lc_special_list_append(bib_lc_special_list_t *list, bib_lc_special_t *buff, size_t len);
extern void bib_lc_special_list_deinit(bib_lc_special_list_t *list);

#pragma mark -

typedef struct bib_lc_number {
    enum {
        bib_lc_number_date = 1,
        bib_lc_number_ordinal
    } kind;
    union {
        bib_date_t    date;
        bib_ordinal_t ordinal;
    } value;
} bib_lc_number_t;

static inline bool bib_lc_number_is_empty(bib_lc_number_t const *const num) { return (num == NULL) || (num->kind == 0); }

#pragma mark -

typedef struct bib_lc_cutter {
    bib_cutter_t    cuttnum;
    bib_lc_number_t datenum;
} bib_lc_cutter_t;

static inline bool bib_lc_cutter_is_empty(bib_lc_cutter_t const *const cut) {
    return (cut == NULL) || bib_cutter_is_empty(&(cut->cuttnum));
}

#pragma mark -

typedef struct bib_lc_calln {
    bib_alpah03_t letters;
    bib_digit04_t integer;
    bib_digit16_t decimal;
    bib_lc_number_t datenum;
    bib_lc_cutter_t cutters[3];
    bib_lc_special_t special[2];
    bib_lc_special_list_t remainder;
} bib_lc_calln_t;

extern bool bib_lc_calln_init  (bib_lc_calln_t *num, char const *str);
extern void bib_lc_calln_deinit(bib_lc_calln_t *num);

#pragma mark -

typedef enum bib_calln_comparison {
    bib_calln_ordered_descending = -1,
    bib_calln_ordered_same       =  0,
    bib_calln_ordered_ascending  =  1,
    bib_calln_ordered_specifying =  2
} bib_calln_comparison_t;

extern bib_calln_comparison_t bib_lc_calln_compare(bib_calln_comparison_t status, bib_lc_calln_t const *left, bib_lc_calln_t const *right, bool specify);
extern bib_calln_comparison_t bib_lc_cutter_compare(bib_calln_comparison_t status, bib_lc_cutter_t const *left, bib_lc_cutter_t const *right, bool specify);
extern bib_calln_comparison_t bib_lc_number_compare(bib_calln_comparison_t status, bib_lc_number_t const *left, bib_lc_number_t const *right, bool specify);
extern bib_calln_comparison_t bib_lc_special_compare(bib_calln_comparison_t status, bib_lc_special_t const *left, bib_lc_special_t const *right, bool specify);

extern bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t status, bib_date_t const *left, bib_date_t const *right, bool specify);
extern bib_calln_comparison_t bib_cutter_compare(bib_calln_comparison_t status, bib_cutter_t const *left, bib_cutter_t const *right, bool specify);
extern bib_calln_comparison_t bib_volume_compare(bib_calln_comparison_t status, bib_volume_t const *left, bib_volume_t const *right, bool specify);
extern bib_calln_comparison_t bib_ordinal_compare(bib_calln_comparison_t status, bib_ordinal_t const *left, bib_ordinal_t const *right, bool specify);

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

extern bib_calln_comparison_t bib_string_specify_compare(bib_calln_comparison_t status,
                                                         char const *prefix, char const *string, bool specify);

__END_DECLS

#endif /* bibtype_h */
