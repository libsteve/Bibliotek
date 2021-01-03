//
//  bibtypeio.c
//  Bibliotek
//
//  Created by Steve Brunwasser on 12/28/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#include <stdio.h>
#include <stdint.h>

#include "bibtypeio.h"

#ifndef MAX
#define MAX(A, B) ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); (__a > __b) ? __a : __b; })
#endif

#ifndef MIN
#define MIN(A, B) ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); (__a < __b) ? __a : __b; })
#endif

static inline char *restrict strtail(char *restrict str, size_t len, size_t loc) {
    if (str == NULL || len <= 0) {
        return str;
    }
    return &(str[MIN(MAX(loc, 0), len - 1)]);
}

size_t bib_snprint_cutt(char *restrict const dst, size_t const len, bib_cutter_t  const *restrict const cutt) {
    return bib_cutter_is_empty(cutt)
         ? snprintf(dst, len, "")
         : snprintf(dst, len, "%s%s", cutt->string, cutt->mark);
}

size_t bib_snprint_date(char *restrict const dst, size_t const len, bib_date_t    const *restrict const date) {
    if (bib_date_is_empty(date)) {
        return snprintf(dst, len, "");
    }
    if (date->isspan) {
        return snprintf(dst, len, "%s%c%s%s", date->year, date->separator, date->span, date->mark);
    }
    if (date->isdate) {
        return (date->day > 0)
             ? snprintf(dst, len, "%s %d %d", date->year, date->month, date->day)
             : snprintf(dst, len, "%s %d", date->year, date->month);
    }
    return snprintf(dst, len, "%s%s", date->year, date->mark);
}

size_t bib_snprint_dord(char *restrict const dst, size_t const len, bib_dateord_t const *restrict const dord) {
    if (bib_dateord_is_empty(dord)) {
        return snprintf(dst, len, "");
    }
    switch (dord->kind) {
    case bib_dateord_kind_date: return bib_snprint_date(dst, len, &(dord->date));
    case bib_dateord_kind_ordinal: return bib_snprint_ordn(dst, len, &(dord->ordinal));
    }
}

size_t bib_snprint_ordn(char *restrict const dst, size_t const len, bib_ordinal_t const *restrict const ordn) {
    return bib_ordinal_is_empty(ordn)
         ? snprintf(dst, len, "")
         : snprintf(dst, len, "%s%s", ordn->number, ordn->suffix);
}

size_t bib_snprint_supl(char *restrict const dst, size_t const len, bib_supplement_t const *restrict const supl) {
    if (bib_supplement_is_empty(supl)) {
        return snprintf(dst, len, "");
    }
    size_t count = (supl->isabbr)
                 ? snprintf(dst, len, "%s.", supl->prefix)
                 : snprintf(dst, len, "%s", supl->prefix);
    if (supl->number[0] != '\0') {
        char const *const suffix = (supl->hasetc) ? ", etc." : "";
        count += snprintf(strtail(dst, len, count), MAX(len - count, 0), " %s%s", supl->number, suffix);
    }
    return count;
}

size_t bib_snprint_voln(char *restrict const dst, size_t const len, bib_volume_t  const *restrict const voln) {
    if (bib_volume_is_empty(voln)) {
        return snprintf(dst, len, "");
    }
    return (voln->hasetc)
         ? snprintf(dst, len, "%s. %s, etc.", voln->prefix, voln->number)
         : snprintf(dst, len, "%s. %s", voln->prefix, voln->number);
}

/// Write a cutter segment to the \c dst buffer using the given \c style options.
static size_t bib_snprint_cuttseg_(char *restrict const dst, size_t const len,
                                   bib_cuttseg_t const *restrict const seg,
                                   bib_lc_calln_style_t const style) {
    if (bib_cuttseg_is_empty(seg)) {
        return snprintf(dst, len, "");
    }
    if (len == 0 && dst == NULL) {
        return bib_snprint_cutt(NULL, 0, &(seg->cutter)) + 1 + bib_snprint_dord(NULL, 0, &(seg->dateord));
    }
    size_t count = 0;
    count += bib_snprint_cutt(dst, len, &(seg->cutter));
    if (!bib_dateord_is_empty(&(seg->dateord))) {
        count += snprintf(strtail(dst, len, count), MAX(len - count, 0), "%c", style.separator);
        count += bib_snprint_dord(strtail(dst, len, count), MAX(len - count, 0), &(seg->dateord));
    }
    return count;
}

size_t bib_snprint_cuttseg(char *restrict const dst, size_t const len, bib_cuttseg_t const *restrict const seg) {
    return bib_snprint_cuttseg_(dst, len, seg, (bib_lc_calln_style_t){
        .separator = ' ',
        .split_subject = false,
        .split_cutters = false,
        .split_sections = false,
        .extra_cutpoint = false
    });
}

size_t bib_snprint_spfcseg(char *restrict const dst, size_t const len,
                           bib_lc_specification_t const *restrict const seg) {
    if (bib_lc_specification_is_empty(seg)) {
        return snprintf(dst, len, "");
    }
    switch (seg->kind) {
        case bib_lc_specification_kind_date: return bib_snprint_date(dst, len, &(seg->date));
        case bib_lc_specification_kind_ordinal: return bib_snprint_ordn(dst, len, &(seg->ordinal));
        case bib_lc_specification_kind_supplement: return bib_snprint_supl(dst, len, &(seg->supplement));
        case bib_lc_specification_kind_volume: return bib_snprint_voln(dst, len, &(seg->volume));
        case bib_lc_specification_kind_word: return snprintf(dst, len, "%s", seg->word);
    }
}

/// Write an array of cutter segments to the \c dst buffer.
static size_t bib_snprint_cuttseg_lst(char *restrict const dst, size_t const len,
                                      bib_cuttseg_t const *restrict const seglst, size_t const seglen,
                                      bib_lc_calln_style_t const style) {
    if (seglst == NULL || seglen == 0) {
        return snprintf(dst, len, "");
    }

    size_t count = 0;
    bool needs_period = true;
    bool needs_separator = style.split_sections;
    for (size_t index = 0; index < 3; index += 1) {
        bib_cuttseg_t const *restrict const seg = &(seglst[index]);
        if (!bib_cuttseg_is_empty(seg)) {
            if (needs_period) {
                if (needs_separator) {
                    count += snprintf(strtail(dst, len, count), MAX(len - count, 0), "%c.", style.separator);
                    needs_separator = false;
                } else {
                    count += snprintf(strtail(dst, len, count), MAX(len - count, 0), ".");
                }
                needs_period = false;
            } else if (needs_separator) {
                count += snprintf(strtail(dst, len, count), MAX(len - count, 0), "%c", style.separator);
            }
            count += bib_snprint_cuttseg_(strtail(dst, len, count), MAX(len - count, 0), seg, style);
            bool has_date = !bib_dateord_is_empty(&(seg->dateord));
            needs_separator = style.split_cutters || (has_date && (!style.extra_cutpoint || style.split_sections));
            needs_period = has_date && style.extra_cutpoint;
        }
    }
    return count;
}

/// Write an array of specification segments to the \c dst buffer.
static size_t bib_snprint_spfcseg_lst(char *restrict const dst, size_t const len,
                                      bib_lc_specification_t const *restrict const seglst, size_t const seglen,
                                      bib_lc_calln_style_t const style) {
    if (seglst == NULL || seglen <= 0) {
        return snprintf(dst, len, "");
    }
    size_t count = 0;
    for (size_t index = 0; index < seglen; index += 1) {
        bib_lc_specification_t const *restrict const seg = &(seglst[index]);
        if (!bib_lc_specification_is_empty(seg)) {
            count += snprintf(strtail(dst, len, count), MAX(len - count, 0), "%c", style.separator);
            count += bib_snprint_spfcseg(strtail(dst, len, count), MAX(len - count, 0), seg);
        }
    }
    return count;
}

size_t bib_snprint_lc_calln(char *restrict const dst, size_t const len,
                            bib_lc_calln_t const *restrict const calln,
                            bib_lc_calln_style_t const style) {
    if (calln == NULL) {
        return snprintf(dst, len, "");
    }
    size_t count = snprintf(dst, len, "%s", calln->letters);
    if (calln->integer[0] != '\0') {
        if (style.split_subject) {
            count += snprintf(strtail(dst, len, count), MAX(len - count, 0), "%c", style.separator);
        }
        size_t const taillen = MAX(len - count, 0);
        char *restrict const tail = strtail(dst, len, count);
        count += (calln->decimal[0] == '\0')
               ? snprintf(tail, taillen, "%s", calln->integer)
               : snprintf(tail, taillen, "%s.%s", calln->integer,  calln->decimal);
    }
    if (!bib_dateord_is_empty(&(calln->dateord))) {
        count += snprintf(strtail(dst, len, count), MAX(len - count, 0), "%c", style.separator);
        count += bib_snprint_dord(strtail(dst, len, count), MAX(len - count, 0), &(calln->dateord));
    }
    count += bib_snprint_cuttseg_lst(strtail(dst, len, count), MAX(len - count, 0), calln->cutters, 3, style);
    count += bib_snprint_spfcseg_lst(strtail(dst, len, count), MAX(len - count, 0), calln->specifications, 2, style);
    count += bib_snprint_spfcseg_lst(strtail(dst, len, count), MAX(len - count, 0),
                                     calln->remainder.buffer, calln->remainder.length, style);
    return count;
}
