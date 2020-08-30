//
//  biblex.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#ifndef biblex_h
#define biblex_h

#include <Bibliotek/bibtype.h>

__BEGIN_DECLS

#pragma mark - lex

extern bool bib_lex_integer (char buffer[bib_integer_size + 1], char const **str, size_t *len);
extern bool bib_lex_digit16 (char buffer[bib_digit16_size + 1], char const **str, size_t *len);
extern bool bib_lex_decimal (char buffer[bib_digit16_size + 1], char const **str, size_t *len);
extern bool bib_lex_suffix  (char buffer[bib_suffix_size  + 1], char const **str, size_t *len);
extern bool bib_lex_date    (char buffer[bib_datenum_size + 1], char const **str, size_t *len);
extern bool bib_lex_cutter  (char buffer[bib_cuttern_size + 1], char const **str, size_t *len);
extern bool bib_lex_subclass(char buffer[bib_lcalpha_size + 1], char const **str, size_t *len);
extern bool bib_lex_workmark(char buffer[bib_suffix_size  + 1], char const **str, size_t *len);

extern size_t bib_lex_digit_n (char *buffer, size_t buffer_len, char const **str, size_t *len);

#pragma mark - read

extern bool bib_read_space(char const **str, size_t *len);
extern bool bib_read_point(char const **str, size_t *len);
extern bool bib_read_dash (char const **str, size_t *len);

#pragma mark - advance

extern bool bib_advance_step(size_t step, char const **str, size_t *len);

__END_DECLS

#endif /* bib_lex_h */
