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

void bib_lc_callnum_init(bib_lc_callnum_t *const num)
{
    if (num == NULL) { return; }
    memset(num, 0, sizeof(bib_lc_callnum_t));
}

void bib_lc_callnum_deinit(bib_lc_callnum_t *const num)
{
    if (num == NULL) { return; }
    if (num->special   != NULL) { free(num->special);   }
    if (num->remainder != NULL) { free(num->remainder); }
}

#pragma mark lc special

void bib_lc_special_init(bib_lc_special_t *const spc, typeof(spc->spec) spec) {
    if (spc == NULL) { return; }
    memset(spc, 0, sizeof(bib_lc_special_t));
    spc->spec = spec;
}

void bib_lc_special_list_append(bib_lc_special_t **const spc_list, size_t *const spc_size,
                                bib_lc_special_t *const spc_buff, size_t const buff_len) {
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
