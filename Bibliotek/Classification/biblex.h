//
//  biblex.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/22/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#ifndef biblex_h
#define biblex_h

#include "bibtype.h"

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

/// \param buffer Allocated space to write the lexed number string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_digit_n (char *buffer, size_t buffer_len, char const **str, size_t *len);

#pragma mark - read

/// Consume all adjacent whitespace characters in the input string.
/// \param str Pointer to the current reading position in the input string.
/// \param len Pointer to the amount of bytes remaining in the input string's buffer.
/// \returns \c true when at least one whitespace character was read from the input string.
/// \post \c str will point to the first non-whitespace character when \c true is returned.
/// \post \c len will point to the number of bytes remaining in the input string.
extern bool bib_read_space(char const **str, size_t *len);

/// Consume a single period character from the input string.
/// \param str Pointer to the current reading position in the input string.
/// \param len Pointer to the amount of bytes remaining in the input string's buffer.
/// \returns \c true when the input string begins with a period.
/// \post \c str will point to the character after the consumed period when \c true is returned.
/// \post \c len will point to the number of bytes remaining in the input string.
extern bool bib_read_point(char const **str, size_t *len);

/// Consume a single dash character from the input string.
/// \param str Pointer to the current reading position in the input string.
/// \param len Pointer to the amount of bytes remaining in the input string's buffer.
/// \returns \c true when the input string begins with a dash.
/// \post \c str will point to the character after the consumed dash when \c true is returned.
/// \post \c len will point to the number of bytes remaining in the input string.
extern bool bib_read_dash (char const **str, size_t *len);

#pragma mark - advance

extern bool bib_advance_step(size_t step, char const **str, size_t *len);

__END_DECLS

#endif /* bib_lex_h */
