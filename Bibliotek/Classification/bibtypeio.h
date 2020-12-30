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
    bool split_subject;
    bool split_cutters;
    bool split_sections;
    bool extra_cutpoint;
} bib_lc_calln_style_t;

/// Write the string value of a cutter number into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param cutt The cutter number to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_cutt(char *restrict dst, size_t len, bib_cutter_t  const *restrict cutt);

/// Write the string value of a date into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param date The date value to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_date(char *restrict dst, size_t len, bib_date_t    const *restrict date);

/// Write the string value of a date or ordinal number into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param dord The date or ordinal number to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_dord(char *restrict dst, size_t len, bib_dateord_t const *restrict dord);

/// Write the string value of a ordinal number into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param ordn The ordinal number to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_ordn(char *restrict dst, size_t len, bib_ordinal_t const *restrict ordn);

/// Write the string value of a volume number into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param voln The volume number to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_voln(char *restrict dst, size_t len, bib_volume_t  const *restrict voln);

/// Write the string value of a cutter segment into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param seg The cutter segment to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_cuttseg(char *restrict dst, size_t len, bib_cuttseg_t const *restrict seg);

/// Write the string value of a specification value into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param spcf The specification value to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \post At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_spfcseg(char *restrict dst, size_t len, bib_lc_specification_t const *restrict spcf);


/// Write the string value of a call number into the \c dst buffer.
/// \param dst The buffer to write the cutter numner into.
/// \param len The length of the \c dst buffer.
/// \param calln The call number to write into the buffer.
/// \returns The string length of the value written to the \c dst buffer, excluding the terminating null character.
///          When \c len is set to zero and \c dst is set to the \c NULL pointer, the total amount of characters
///          necessary to write the full string value—excluding the terminating null character—is returned.
/// \note At most \c len-1 characters of the string representation will be written to the \c dst buffer.
extern size_t bib_snprint_lc_calln(char *restrict dst, size_t len, bib_lc_calln_t const *restrict calln,
                                   bib_lc_calln_style_t style);


#endif /* bibtypeio_h */
