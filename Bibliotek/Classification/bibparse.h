//
//  bibparse.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#ifndef bibparse_h
#define bibparse_h

#include "bibtype.h"

__BEGIN_DECLS

extern bool bib_parse_lc_calln(bib_lc_calln_t *calln, char const **str, size_t *len);

extern bool bib_parse_lc_number(bib_lc_number_t *num, char const **str, size_t *len);
extern bool bib_parse_lc_cutter(bib_lc_cutter_t *cut, char const **str, size_t *len);
extern bool bib_parse_lc_spacial(bib_lc_special_t *spc, char const **str, size_t *len);
extern bool bib_parse_lc_remainder(bib_lc_special_list_t *rem, char const **str, size_t *len);

extern bool bib_parse_date(bib_date_t *date, char const **str, size_t *len);
extern bool bib_parse_cutter(bib_cutter_t *cut, char const **str, size_t *len);
extern bool bib_parse_caption_ordinal(bib_ordinal_t *ord, char const **str, size_t *len);
extern bool bib_parse_special_ordinal(bib_ordinal_t *ord, char const **str, size_t *len);
extern bool bib_parse_volume(bib_volume_t *vol, char const **str, size_t *len);

__END_DECLS

#endif /* bib_parse_h */
