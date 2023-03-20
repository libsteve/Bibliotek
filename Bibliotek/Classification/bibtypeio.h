//
//  bibtypeio.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 12/28/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#ifndef bibtypeio_h
#define bibtypeio_h

#include "bibtype.h"

typedef struct bib_lc_calln_style {
    char separator;
    bool split_subject : 1;
    bool split_cutters : 1;
    bool split_sections : 1;
    bool extra_cutpoint : 1;
} bib_lc_calln_style_t;

/// Write the string value of a cutter number into the `dst` buffer.
/// - parameter dst: The buffer to write the cutter number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter cutt: The cutter number to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_cutt(char *restrict dst, size_t len, bib_cutter_t  const *restrict cutt);

/// Write the string value of a date into the `dst` buffer.
/// - parameter dst: The buffer to write the date into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter date: The date value to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_date(char *restrict dst, size_t len, bib_date_t    const *restrict date);

/// Write the string value of a date or ordinal number into the `dst` buffer.
/// - parameter dst: The buffer to write the ordinal number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter dord: The date or ordinal number to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_dord(char *restrict dst, size_t len, bib_dateord_t const *restrict dord);

/// Write the string value of a ordinal number into the `dst` buffer.
/// - parameter dst: The buffer to write the ordinal number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter ordn: The ordinal number to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_ordn(char *restrict dst, size_t len, bib_ordinal_t const *restrict ordn);

/// Write the string value of a supplementary work number into the `dst` buffer.
/// - parameter dst: The buffer to write the supplementary work number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter supl: The supplementary work number to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_supl(char *restrict dst, size_t len, bib_supplement_t const *restrict supl);

/// Write the string value of a volume number into the `dst` buffer.
/// - parameter dst: The buffer to write the volume number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter voln: The volume number to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_voln(char *restrict dst, size_t len, bib_volume_t  const *restrict voln);

/// Write the string value of a cutter segment into the `dst` buffer.
/// - parameter dst: The buffer to write the cutter number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter seg: The cutter segment to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_cuttseg(char *restrict dst, size_t len, bib_cuttseg_t const *restrict seg);

/// Write the string value of a specification value into the `dst` buffer.
/// - parameter dst: The buffer to write the specification value into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter spcf: The specification value to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - postcondition: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_spfcseg(char *restrict dst, size_t len, bib_lc_specification_t const *restrict spcf);


/// Write the string value of a call number into the `dst` buffer.
/// - parameter dst: The buffer to write the call number into.
/// - parameter len: The length of the `dst` buffer.
/// - parameter calln: The call number to write into the buffer.
/// - returns: The string length of the value written to the `dst` buffer, excluding the terminating null character.
///            When `len` is set to zero and `dst` is set to the `NULL` pointer, the total amount of characters
///            necessary to write the full string value—excluding the terminating null character—is returned.
/// - note: At most `len - 1` characters of the string representation will be written to the `dst` buffer.
extern size_t bib_snprint_lc_calln(char *restrict dst, size_t len, bib_lc_calln_t const *restrict calln,
                                   bib_lc_calln_style_t style);


#endif /* bibtypeio_h */
