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

/// Read between one and three digits from 0-9 from the input stream into the given buffer.
/// \param buffer Allocated space for the number. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a number between 0 and 999 is successfully read from the input string.
extern bool bib_lex_integer (bib_digit04_b buffer, char const **str, size_t *len);

/// Read between one and 16 digits from 0-9 from the input stream into the given buffer.
/// \param buffer Allocated space for the number. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a number between one and 16 digits in length is successfully read from the input string.
extern bool bib_lex_digit16 (bib_digit16_b buffer, char const **str, size_t *len);

/// Read between one and 16 digits following a decimal point from the input stream into the given buffer.
/// \param buffer Allocated space for the number. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a period followed by one to 16 digits is successfully read from the input string.
/// \note The decimal point will not be written to the buffer.
extern bool bib_lex_decimal (bib_digit16_b buffer, char const **str, size_t *len);

/// Read a four-digit year from the input stream into the given buffer.
/// \param buffer Allocated space for a four-digit year. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a four-digit year is successfully read from the input string.
extern bool bib_lex_year    (bib_year_b    buffer, char const **str, size_t *len);

/// Read a two-digit abbreviated year from the input stream into the given buffer.
/// \param buffer Allocated space for a two-digit abbreviated year. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a two-digit abbreviated year is successfully read from the input string.
extern bool bib_lex_year_abv(bib_year_b    buffer, char const **str, size_t *len);

/// Read a mark suffix with between one and four letters from the input stream into the given buffer.
/// \param buffer Allocated space for a mark suffix. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a mark suffix is successfully read from the input string.
extern bool bib_lex_mark    (bib_mark_b    buffer, char const **str, size_t *len);

/// Read between one and three letters from the input stream into the given buffer.
/// \param buffer Allocated space for up to three letters. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when between one and three letters are successfully read from the input string.
extern bool bib_lex_subclass(bib_alpah03_b buffer, char const **str, size_t *len);

/// A function that can parse some word-length value from the input stream.
/// \param word A buffer to write the parsed string into. The written value will contain a null terminator.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when lexing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream's buffer.
/// \returns \c true when a word was successfully parsed from the input stream.
typedef bool (*bib_lex_word_f)(bib_word_b word, char const **str, size_t *len);

/// Read the suffix for a cutter segment's ordinal number from the input stream into the given buffer.
/// \param buffer Allocated space for an ordinal suffix. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a cutter segment's ordinal's suffix is successfully read from the input string.
/// \note Cutter segments' ordinals' suffixes must not end with a period.
extern bool bib_lex_cutter_ordinal_suffix(bib_word_b buffer, char const **str, size_t *len);

/// Read the suffix for the caption segment's ordinal number from the input stream into the given buffer.
/// \param buffer Allocated space for an ordinal suffix. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when the caption segment's ordinal's suffix is successfully read from the input string.
/// \note Caption segments' ordinals' suffixes must not end with a period, but they should preceed the first
///       cutter number's leading period.
extern bool bib_lex_caption_ordinal_suffix(bib_word_b buffer, char const **str, size_t *len);

/// Read the suffix for an ordinal number in the specification segment from the input stream into the given buffer.
/// \param buffer Allocated space for an ordinal suffix. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when the suffix for an ordinal number in the specification segment is successfully read from the
///          input string.
/// \note Suffixes for ordinal numbers in the sepcification section must end with a period.
extern bool bib_lex_specification_ordinal_suffix(bib_word_b buffer, char const **str, size_t *len);

/// Read the a volume prefix from the input stream into the given buffer.
/// \param buffer Allocated space for a volume prefix. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a volume prefix is successfully read from the input string.
extern bool bib_lex_volume_prefix(bib_word_b buffer, char const **str, size_t *len);

/// Read the value of a long word from the input stream into the given buffer.
/// \param buffer Allocated space for a long word. The written value will contain a null terminator.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns \c true when a long word is successfully read from the input string.
extern bool bib_lex_longword(bib_longword_b buffer, char const **str, size_t *len);

#pragma mark - lex primitives

/// Read up to \c buffer_len-1 decimal digits from the input stream into the given buffer.
/// \param buffer Allocated space to write the lexed number string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_digit_n (char *buffer, size_t buffer_len, char const **str, size_t *len);

/// Read up to \c buffer_len-1  alphabetic characters from the input stream into the given buffer.
/// \param buffer Allocated space to write the lexed string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_alpha_n (char *buffer, size_t buffer_len, char const **str, size_t *len);

/// A function that filters for characters to include in a lexed value.
/// \param c The character to check for inclusion.
/// \returns \c true when the given character should be included in the lexed value.
typedef bool (*bib_cpred_f)(char c);

/// Read up to \c buffer_len characters of any value from the input stream into the given buffer.
/// \param buffer Allocated space to write the lexed string. The written value will contain a null terminator.
/// \param buffer_len The length of available space in the buffer.
/// \param pred A function that filters for characters to include in the lexed string.
/// \param str A pointer to the input string. Characters read from the string are removed only if lexing was successful.
/// \param len The length of the input string, including the null terminator.
/// \returns The amount of characters read from the input string. This does not include the null terminator.
extern size_t bib_lex_char_n  (char *buffer, size_t buffer_len, bib_cpred_f pred, char const **str, size_t *len);

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

#pragma mark - read primitives

/// Consume a single character from the input string matching the given predicate.
/// \param c Pointer to allocated space to set the read character.
///          Pass \c NULL to ignore the consumed value.
/// \param pred A function that filters for characters that indicate a "successful" read.
///             Pass \c NULL to accept any character value.
/// \param str Pointer to the current reading position in the input stream.
/// \param len Pointer to the amount of bytes remaining in the input stream's buffer.
/// \returns \c true when a character matching the given predicate is consumed from the input stream.
extern bool bib_read_char(char *c, bib_cpred_f pred, char const **str, size_t *len);

extern bool bib_read_alpha(char *c, char const **str, size_t *len);

#pragma mark - character predicates

/// An ASCII latin alphabet character.
extern bool bib_isalpha(char c);

/// A number from 0 to 9.
extern bool bib_isnumber(char c);

/// Not a whitespace character.
extern bool bib_notspace(char c);

/// Period character "."
extern bool bib_ispoint(char c);

/// Dash character "-"
extern bool bib_isdash(char c);

/// Forward-slash character "/"
extern bool bib_isslash(char c);

/// Characters representing the end of data in a stream.
/// \returns \c true when the given character represents the end of data from a stream.
extern bool bib_isstop(char c);

#pragma mark - peek

extern bool bib_peek_char(char *c, bib_cpred_f pred, char const *str, size_t len);

/// Check if the next character seprates one word from another—such as whitespace, the null terminator, or EOF.
/// \param str The current reading position in the input string.
/// \param len The amount of bytes remaining in the input string's buffer.
/// \returns \c true when the input string begins with a word-seperating character.
extern bool bib_peek_break(char const *str, size_t len);

#pragma mark - advance

/// Consume some amount of characters from the input stream.
/// \param step The amount of characters to consume from the input stream.
/// \param str The current reading position in the input stream.
/// \param len The amount of bytes remaining in the input stream's buffer.
/// \returns \c true when \c step amount of characters is successfully consumed from the input stream.
///          \c false is returned when the input stream is is empty, or when \c step is less than or equal to \c 0.
extern bool bib_advance_step(size_t step, char const **str, size_t *len);

__END_DECLS

#endif /* biblex_h */
