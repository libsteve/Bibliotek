//
//  BibLCCallNumber+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//
//  See https://www.oclc.org/bibformats/en/0xx/050.html for details about the Library of Congress Call Number format.
//

#include <stdlib.h>
#include <stdint.h>
#include <strings.h>
#include <stdbool.h>
#include <ctype.h>

static size_t const alpha_len = 3;
static size_t const whole_len = 4;
static size_t const decml_len = 3;
static size_t const daten_len = 4;
static size_t const cuttr_len = 4;

typedef struct bib_lc_calln {
    char alphabetic_segment  [alpha_len + 1];
    char whole_number        [whole_len + 1];
    char decimal_number      [decml_len + 1];
    char date_or_other_number[daten_len + 1];
    char first_cutter_number [cuttr_len + 1];
    char date_or_other_number_after_first_cutter[daten_len + 1];
    char second_cutter_number[cuttr_len + 1];
    char **remaing_segments;
    size_t remaing_segments_length;
} bib_lc_calln_t;

extern bool bib_lc_calln_init   (bib_lc_calln_t *call_number, char const *string);
extern void bib_lc_calln_deinit (bib_lc_calln_t *call_number);

extern bool bib_lc_calln_read_alphabetic_segment    (bib_lc_calln_t *call_number, char const **str, unsigned long *len);
extern bool bib_lc_calln_read_whole_number          (bib_lc_calln_t *call_number, char const **str, unsigned long *len);
extern bool bib_lc_calln_read_decimal_number        (bib_lc_calln_t *call_number, char const **str, unsigned long *len);
extern bool bib_lc_calln_read_date_or_other_number  (bib_lc_calln_t *call_number, char const **str, unsigned long *len);
extern bool bib_lc_calln_read_first_cutter_number   (bib_lc_calln_t *call_number, char const **str, unsigned long *len);
extern bool bib_lc_calln_read_number_after_cutter   (bib_lc_calln_t *call_number, char const **str, unsigned long *len);
extern bool bib_lc_calln_read_second_cutter_number  (bib_lc_calln_t *call_number, char const **str, unsigned long *len);

extern bool bib_read_lc_calln_alphabetic_segment    (char buffer[alpha_len], char const **str, unsigned long *len);
extern bool bib_read_lc_calln_whole_number          (char buffer[whole_len], char const **str, unsigned long *len);
extern bool bib_read_lc_calln_decimal_number        (char buffer[decml_len], char const **str, unsigned long *len);
extern bool bib_read_lc_calln_date_or_other_number  (char buffer[daten_len], char const **str, unsigned long *len);
extern bool bib_read_lc_calln_cutter_number         (char buffer[cuttr_len], char const **str, unsigned long *len);
