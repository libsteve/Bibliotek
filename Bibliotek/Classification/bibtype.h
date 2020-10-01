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

typedef struct bib_lc_caption {
    char letters[bib_letters_size + 1];
    char integer[bib_integer_size + 1];
    char decimal[bib_digit16_size + 1];
    char date   [bib_datenum_size + 1];
    bib_ordinal_t ordinal;
} bib_lc_caption_t;

typedef struct bib_cutter {
    char number[bib_cuttern_size + 1];
    char date  [bib_datenum_size + 1];
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
        char date    [bib_datenum_size + 1];
        char suffix  [bib_suffix_size  + 1];
        char workmark[bib_suffix_size  + 1];
        bib_ordinal_t ordinal;
        struct {
            char date[bib_datenum_size + 1];
            char span[bib_datenum_size + 1];
        } datespan;
    } value;
} bib_lc_special_t;

typedef struct bib_lc_callnum {
    bib_lc_caption_t caption;
    bib_cutter_t cutters[3];
    char suffix  [bib_suffix_size + 1];
    char workmark[bib_suffix_size + 1];
    bib_lc_special_t *special;
    size_t special_count;
    char *remainder;
} bib_lc_callnum_t;


__BEGIN_DECLS
extern void bib_lc_callnum_init  (bib_lc_callnum_t *num);
extern void bib_lc_callnum_deinit(bib_lc_callnum_t *num);

extern void bib_lc_special_init(bib_lc_special_t *spc, typeof(spc->spec) spec);
extern void bib_lc_special_list_append(bib_lc_special_t **spc_list, size_t *spc_size,
                                       bib_lc_special_t  *spc_buff, size_t  buff_len);
extern void bib_lc_special_list_deinit(bib_lc_special_t **spc_list, size_t *spc_size);
__END_DECLS

#endif /* bibtype_h */
