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
