//
//  bibparse.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#ifndef bibparse_h
#define bibparse_h

#include <Bibliotek/bibtype.h>

__BEGIN_DECLS

#pragma mark - cutter

extern bool bib_parse_cutter(bib_cutter_t *cut, char const **str, size_t *len);

#pragma mark - lc call number

extern bool bib_parse_lc_callnum(bib_lc_callnum_t *num, char const **str, size_t *len);
extern bool bib_parse_lc_callnum_base (bib_lc_callnum_t *num, char const **str, size_t *len);
extern bool bib_parse_lc_callnum_shelf(bib_lc_callnum_t *num, char const **str, size_t *len);

#pragma mark - lc caption

extern bool bib_parse_lc_caption(bib_lc_caption_t *cap, char const **str, size_t *len);
extern bool bib_parse_lc_caption_root   (bib_lc_caption_t *cap, char const **str, size_t *len);
extern bool bib_parse_lc_caption_ordinal(bib_ordinal_t    *ord, char const **str, size_t *len);
extern bool bib_parse_lc_caption_ordinal_suffix(char buffer[bib_suffix_size + 2], char const **str, size_t *len);

#pragma mark - lc cutter

extern bool bib_parse_lc_cutter(bib_cutter_t cutters[3], char const **str, size_t *len);
extern bool bib_parse_lc_dated_cutter(bib_cutter_t *cut, char const **str, size_t *len);

#pragma mark - lc special

extern bool bib_parse_lc_special(bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len);
extern bool bib_parse_lc_special_date    (bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len);
extern bool bib_parse_lc_special_workmark(bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len);
extern bool bib_parse_lc_special_ordinal (bib_lc_special_t **spc_list, size_t *spc_size, char const **str, size_t *len);
extern bool bib_parse_lc_special_ordinal_root(bib_ordinal_t *ord, char const **str, size_t *len);

__END_DECLS

#endif /* bib_parse_h */
