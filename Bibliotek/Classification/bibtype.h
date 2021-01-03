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

#pragma mark -

/// A single alphabetic character.
typedef char bib_initial_t;

/// A string of at most three alphabetic characters.
typedef char bib_alpah03_b[4];

/// A string of at most six decimal digits 0 through 9.
typedef char bib_digit06_b[7];

/// A string of at most 16 decimal digits 0 through 9.
typedef char bib_digit16_b[17];

/// A string of at most 16 non-whitespace characters.
typedef char bib_word_b[17];

/// A string of at most 14 non-whitespace characters.
typedef char bib_longword_b[25];

/// A string of either two or four decimal digits 0 through 9.
typedef char bib_year_b[5];

/// A string of at most four alphabetic characters
typedef char bib_mark_b[5];

#pragma mark - date

/// A year or range of years used within a call number.
typedef struct bib_date {
    /// The initial year of the date range, or the exact year for single year values.
    bib_year_b year;

    /// The character used to separate the year from the end of the range.
    ///
    /// This is the null character for single year values.
    char separator;

    /// The last year in the range.
    bib_year_b span;

    /// Some short optional alhpabetic suffix attached to the date.
    bib_mark_b mark;
} bib_date_t;

extern bool bib_date_init(bib_date_t *date, char const *str);
extern bool bib_date_is_empty(bib_date_t const *date);
extern bool bib_date_has_span(bib_date_t const *date);

#pragma mark - cutter

/// A cutter number string.
typedef char bib_cutter_b[18];

/// A cutter number.
typedef struct bib_cutter {
    union {
        /// The cutter number string value, combining the initial letter with its trailing number.
        bib_cutter_b string;

        struct {
            /// The initial alphabetic character for the number.
            bib_initial_t letter;

            /// The decimal digits following the initial letter in the number.
            bib_digit16_b number;
        };
    };

    /// Some short optional alphabetic suffix attached to the cutter number.
    bib_mark_b mark;
} bib_cutter_t;

extern bool bib_cutter_init(bib_cutter_t *cut, char const *str);
extern bool bib_cutter_is_empty(bib_cutter_t const *cut);

#pragma mark - ordinal

/// An integer value followed by an alphabetic suffix. i.e. "15th"
typedef struct bib_ordinal {
    /// The integer value of the ordinal.
    bib_digit16_b number;

    /// The alphabetic suffix following the number.
    bib_word_b    suffix;
} bib_ordinal_t;

extern bool bib_ordinal_is_empty(bib_ordinal_t const *ord);

#pragma mark - volume

/// An integer value preceeded by some alphabetic marker. i.e. "vol. 1"
typedef struct bib_volume {
    /// The alphabetic prefix denoting the type of "volume".
    bib_word_b    prefix;

    /// The integer value following the "volume" type.
    bib_digit16_b number;
} bib_volume_t;

bool bib_volume_init(bib_volume_t *vol, char const *str);
extern bool bib_volume_is_empty(bib_volume_t const *vol);

#pragma mark - lc specification

/// A flag indicating the type of data within a specification segment.
typedef enum bib_lc_specification_kind {
    bib_lc_specification_kind_date = 1,
    bib_lc_specification_kind_ordinal,
    bib_lc_specification_kind_volume,
    bib_lc_specification_kind_word
} bib_lc_specification_kind_t;

/// A value within the specification section of a Library of Congress call number.
typedef struct bib_lc_specification {
    /// The type of data within the specification segment.
    bib_lc_specification_kind_t kind;

    union {
        /// A date value, marked by \c bib_lc_specification_kind_date
        bib_date_t     date;

        /// An ordinal value, marked by \c bib_lc_specification_kind_ordinal
        bib_ordinal_t  ordinal;

        /// A volume value, marked by \c bib_lc_specification_kind_volume
        bib_volume_t   volume;

        /// A long word value, marked by \c bib_lc_specification_kind_word
        bib_longword_b word;
    };
} bib_lc_specification_t;

extern void bib_lc_specification_init(bib_lc_specification_t *spc, bib_lc_specification_kind_t spec);
extern void bib_lc_specification_deinit(bib_lc_specification_t *spc);
extern bool bib_lc_specification_is_empty(bib_lc_specification_t const *spc);

/// A list of specification segment values.
typedef struct bib_lc_specification_list {
    /// The raw heap-allocated buffer contianing the heap-allocated segments.
    bib_lc_specification_t *buffer;

    /// The amount of specification segments within this list.
    size_t            length;
} bib_lc_specification_list_t;

extern void bib_lc_specification_list_init  (bib_lc_specification_list_t *list);
extern void bib_lc_specification_list_append(bib_lc_specification_list_t *list, bib_lc_specification_t *spc);
extern void bib_lc_specification_list_deinit(bib_lc_specification_list_t *list);
extern bool bib_lc_specification_list_is_empty(bib_lc_specification_list_t const *list);

#pragma mark - dateord

/// A flag indicating the type of data within a date-or-other value.
typedef enum bib_dateord_kind {
    bib_dateord_kind_date = 1,
    bib_dateord_kind_ordinal
} bib_dateord_kind_t;

/// A date or ordinal value within the caption section or a cutter segment in a Library of Congress call number.
typedef struct bib_dateord {
    /// The type of data within the date-or-ordinal value.
    bib_dateord_kind_t kind;

    union {
        /// A date value, marked by \c bib_dateord_kind_date
        bib_date_t date;

        /// An ordinal value, marked by \c bib_dateord_kind_ordinal
        bib_ordinal_t ordinal;
    };
} bib_dateord_t;


extern bool bib_dateord_init_date(bib_dateord_t *dord, bib_date_t const *date);
extern bool bib_dateord_init_ordinal(bib_dateord_t *dord, bib_ordinal_t const *ord);

extern bib_date_t const *bib_dateord_get_date(bib_dateord_t *const dord);
extern bib_ordinal_t const *bib_dateord_get_ordinal(bib_dateord_t *const dord);

extern bool bib_dateord_is_empty(bib_dateord_t const *dord);


#pragma mark - cuttseg

/// A cutter segment within a Library of Congress call number.
typedef struct bib_cuttseg {
    /// The cutter number.
    bib_cutter_t cutter;

    /// The date or ordinal value trailing the cutter number.
    bib_dateord_t dateord;
} bib_cuttseg_t;

extern bool bib_cuttseg_init(bib_cuttseg_t *seg, bib_cutter_t const *num, bib_dateord_t const *dord);
extern bool bib_cuttseg_is_empty(bib_cuttseg_t const *seg);

#pragma mark - lc calln

/// A Library of Congress call number.
///
/// This structure is based in part on the sorting strategy described in "A Comprehensive
/// Approach to Algorithmic Machine Sorting of Library of Congress Call Numbers" by Scott Wagner
/// and Corey Wetherington \a https://doi.org/10.6017/ital.v38i4.11585
///
/// Other parts of this structure are based on description found in the OCLC's documentation on
/// the MARC bibliographic field 050 Library of Congress Call Number
/// \a https://www.oclc.org/bibformats/en/0xx/050.html
typedef struct bib_lc_calln {
    /// The at most three letter initial of the subject matter class.
    bib_alpah03_b letters;

    /// The integer value of the subject matter subclass.
    bib_digit06_b integer;

    /// The decimal portion of the subject matter subclass.
    bib_digit16_b decimal;

    /// The date or ordinal value within the subject matter section.
    bib_dateord_t dateord;

    /// The three cutter segments.
    bib_cuttseg_t cutters[3];

    /// The first two specification segments.
    bib_lc_specification_t specifications[2];

    /// The remaining sepcifiation segments.
    bib_lc_specification_list_t remainder;
} bib_lc_calln_t;

extern bool bib_lc_calln_init  (bib_lc_calln_t *num, char const *str);
extern void bib_lc_calln_deinit(bib_lc_calln_t *num);

#pragma mark - lc comparison

/// The ordering relationship between two call number components.
typedef enum bib_calln_comparison {
    /// The leading value is ordered before the trailing value, and therefore does not specialize it.
    bib_calln_ordered_descending = -1,

    /// The leading value is the same as the trailing value.
    bib_calln_ordered_same       =  0,

    /// The leading value is ordered after the trailing value in a way that does not specialize it.
    bib_calln_ordered_ascending  =  1,

    /// The leading value is a superset of the trailing value, but they are not equal.
    bib_calln_ordered_specifying =  2

} bib_calln_comparison_t;

/// Get the ordering relationship between two call numbers.
/// \param left The call number at the first location.
/// \param right The call number at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
///
/// Sorting strategy based on that described in "A Comprehensive Approach to Algorithmic Machine Sorting
/// of Library of Congress Call Numbers" by Scott Wagner and Corey Wetherington.
/// \a https://doi.org/10.6017/ital.v38i4.11585
extern bib_calln_comparison_t bib_lc_calln_compare(bib_calln_comparison_t status,
                                                   bib_lc_calln_t const *left, bib_lc_calln_t const *right,
                                                   bool specify);

/// Get the ordering relationship between two cutter segments.
/// \param left The cutter segment at the first location.
/// \param right The cutter segment at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_cuttseg_compare(bib_calln_comparison_t status,
                                                  bib_cuttseg_t const *left, bib_cuttseg_t const *right,
                                                  bool specify);

/// Get the ordering relationship between two date-or-ordinal values.
/// \param left The date-or-ordinal value at the first location.
/// \param right The date-or-ordinal value at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_dateord_compare(bib_calln_comparison_t status,
                                                  bib_dateord_t const *left, bib_dateord_t const *right,
                                                  bool specify);

/// Get the ordering relationship between two specification segments.
/// \param left The specification segment at the first location.
/// \param right The specification segment at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_specification_compare(bib_calln_comparison_t status,
                                                        bib_lc_specification_t const *left,
                                                        bib_lc_specification_t const *right,
                                                        bool specify);
/// Get the ordering relationship between two dates.
/// \param left The date at the first location.
/// \param right The date at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_date_compare(bib_calln_comparison_t status,
                                               bib_date_t const *left, bib_date_t const *right,
                                               bool specify);

/// Get the ordering relationship between two cutter numbers.
/// \param left The cutter number at the first location.
/// \param right The cutter number at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_cutter_compare(bib_calln_comparison_t status,
                                                 bib_cutter_t const *left, bib_cutter_t const *right,
                                                 bool specify);

/// Get the ordering relationship between two volume numbers.
/// \param left The volume number at the first location.
/// \param right The volume number at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_volume_compare(bib_calln_comparison_t status,
                                                 bib_volume_t const *left, bib_volume_t const *right,
                                                 bool specify);

/// Get the ordering relationship between two ordinal values.
/// \param left The ordinal value at the first location.
/// \param right The ordinal value at the last location.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param specify Pass \c true when the comparison should include specialization ordering.
/// \returns The ordering relationship between the \c left and \c right objects.
extern bib_calln_comparison_t bib_ordinal_compare(bib_calln_comparison_t status,
                                                  bib_ordinal_t const *left, bib_ordinal_t const *right,
                                                  bool specify);

#pragma mark - string comparison

/// Determine if the given \c string begins with the given \c prefix and whether or not they are equal.
/// \param status The result of previous specialization comparisons. This is used to continue matching
///               prefixes for subsequent segments that have been completly equivalend thus far.
/// \param prefix A prefix string search for.
/// \param string A string that may or may not begin with or euqal to the given prefix
/// \param specify Pass \c true when the comparison should include specialization ordering.
extern bib_calln_comparison_t bib_string_specify_compare(bib_calln_comparison_t status,
                                                         char const *prefix, char const *string, bool specify);

__END_DECLS

#endif /* bibtype_h */
