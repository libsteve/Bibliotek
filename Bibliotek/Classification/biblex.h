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

extern bool bib_lex_integer (bib_digit04_t buffer, char const **str, size_t *len);
extern bool bib_lex_digit16 (bib_digit16_t buffer, char const **str, size_t *len);
extern bool bib_lex_decimal (bib_digit16_t buffer, char const **str, size_t *len);
extern bool bib_lex_year    (bib_year_t    buffer, char const **str, size_t *len);
extern bool bib_lex_year_abv(bib_year_t    buffer, char const **str, size_t *len);
extern bool bib_lex_mark    (bib_mark_t    buffer, char const **str, size_t *len);
extern bool bib_lex_subclass(bib_alpah03_t buffer, char const **str, size_t *len);

extern bool bib_lex_caption_ordinal_suffix(bib_word_t buffer, char const **str, size_t *len);
extern bool bib_lex_special_ordinal_suffix(bib_word_t buffer, char const **str, size_t *len);
extern bool bib_lex_volume_prefix(bib_word_t buffer, char const **str, size_t *len);
extern bool bib_lex_longword(bib_longword_t buffer, char const **str, size_t *len);

/// \param buffer Allocated space to write the lexed number string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_digit_n (char *buffer, size_t buffer_len, char const **str, size_t *len);

/// \param buffer Allocated space to write the lexed string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_alpha_n (char *buffer, size_t buffer_len, char const **str, size_t *len);

/// \param buffer Allocated space to write the lexed string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param pred A function that filters for characters to include in the lexed string.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_char_n  (char *buffer, size_t buffer_len, bool (*pred)(char), char const **str, size_t *len);

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

/// Consume a single forward-slash character from the input string.
/// \param str Pointer to the current reading position in the input string.
/// \param len Pointer to the amount of bytes remaining in the input string's buffer.
/// \returns \c true when the input string begins with a dash.
/// \post \c str will point to the character after the consumed forward-slash when \c true is returned.
/// \post \c len will point to the number of bytes remaining in the input string.
extern bool bib_read_slash(char const **str, size_t *len);

extern bool bib_read_char (char *c, char const **str, size_t *len);
extern size_t bib_read_buff (char *buffer, size_t buflen, bool (*pred)(char), char const **str, size_t *len);

/// Check if the next character seprates one word from another—such as whitespace, the null terminator, or EOF.
/// \param str The current reading position in the input string.
/// \param len The amount of bytes remaining in the input string's buffer.
/// \returns \c true when the input string begins with a word-seperating character.
extern bool bib_peek_break(char const *str, size_t len);

#pragma mark - advance

extern bool bib_advance_step(size_t step, char const **str, size_t *len);

__END_DECLS

#endif /* bib_lex_h */
