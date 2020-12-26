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
#include "biblex.h"

__BEGIN_DECLS

#pragma mark - parse lc

/// Read a Library of Congress call number from the given input stream.
/// \param calln Allocated space for a structure representing the parsed call number.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a Library of Congress call number is successfully read from the input stream.
/// \post \c calln is set to a data structure representing the call number when parsing is successful.
extern bool bib_parse_lc_calln(bib_lc_calln_t *calln, char const **str, size_t *len);

#pragma mark - parse lc components

/// Read a date or an ordinal value appearing within the caption or a cutter segment in a Library of Congress call
/// number from the given input stream.
/// \param num Allocated space for a structure representing the parsed date-or-ordinal segment.
/// \param lex_ord_suffix A function defining the lexing strategy used for the suffix of a possible ordinal value.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a date or ordinal value is successfully read from the input stream.
/// \post \c num is set to a data structure representing the date or ordinal value when parsing is successful.
extern bool bib_parse_lc_number(bib_lc_number_t *num, bib_lex_word_f lex_ord_suffix, char const **str, size_t *len);

/// Read a cutter segment for a Library of Congress call number from the given input stream.
/// \param cut Allocated space for a structure representing the parsed cutter segment.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a cutter segment is successfully read from the input stream.
/// \post \c cut is set to a data structure representing the cutter segment when parsing is successful.
extern bool bib_parse_lc_cutter(bib_lc_cutter_t *cut, char const **str, size_t *len);

/// Read a specification segment for a Library of Conrgess call number from the given input stream.
/// \param spc Allocated space for a structure representing the parsed specification segment.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a specification segment is successfully read from the input stream.
/// \post \c spc is set to a data structure representing the specification value when parsing is successful.
extern bool bib_parse_lc_spacial(bib_lc_special_t *spc, char const **str, size_t *len);

/// Read a list of specification segments for a Library of Congress call number from the given input stream.
/// \param rem Allocated space for a list of specification segments in a call number.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a list of specification segments is successfully read from the input stream.
/// \post \c rem is populated with heap-allocated data structures representing each specification segment
///       when parsing is successful.
extern bool bib_parse_lc_remainder(bib_lc_special_list_t *rem, char const **str, size_t *len);

#pragma mark - parse components

/// Read a year or date span value from the given input stream.
/// \param date Allocated space for a structure representing the parsed date value.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a date value is successfully read from the input stream.
/// \post \c date is set to a data structure representing the date value when parsing is successful.
extern bool bib_parse_date(bib_date_t *date, char const **str, size_t *len);

/// Read a cutter number from the given input stream.
/// \param cut Allocated space for a structure representing the parsed cutter value.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when a cutter value is successfully read from the input stream.
/// \post \c cut is set to a data structure representing the cutter value when parsing is successful.
extern bool bib_parse_cutter(bib_cutter_t *cut, char const **str, size_t *len);

/// Read an ordinal value for a call number's cutter segment from the given input stream.
/// \param ord Allocated space for a structure representing the parsed ordinal value in a cutter segment.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when an ordinal value is successfully read from the input stream.
/// \post \c ord is set to a data structure representing the ordinal value when parsing is successful.
extern bool bib_parse_cutter_ordinal(bib_ordinal_t *ord, char const **str, size_t *len);

/// Read an ordinal value for a call number's caption sction from the given input stream.
/// \param ord Allocated space for a structure representing the parsed ordinal value in the caption section.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when an ordinal value is successfully read from the input stream.
/// \post \c ord is set to a data structure representing the ordinal value when parsing is successful.
extern bool bib_parse_caption_ordinal(bib_ordinal_t *ord, char const **str, size_t *len);

/// Read an ordinal value for a call number's specification segment from the given input stream.
/// \param ord Allocated space for a structure representing the parsed ordinal value in a specification segment.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when an ordinal value is successfully read from the input stream.
/// \post \c ord is set to a data structure representing the ordinal value when parsing is successful.
extern bool bib_parse_special_ordinal(bib_ordinal_t *ord, char const **str, size_t *len);

/// Read an ordinal value from the given input stream.
/// \param ord Allocated space for a structure representing the parsed ordinal value.
/// \param lex_suffix A function defining the lexing strategy used for the ordinal's suffix value.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
/// \returns \c true when an ordinal value is successfully read from the input stream.
/// \post \c ord is set to a data structure representing the ordinal value when parsing is successful.
extern bool bib_parse_ordinal(bib_ordinal_t *ord, bib_lex_word_f lex_suffix, char const **str, size_t *len);

/// Read a call number's volume value from the given input stream.
/// \param vol Allocated space for a structure representing the parsed volume value.
/// \param str Pointer to the current reading position in the input stream.
///            Characters read from the stream are removed only when parsing is successful.
/// \param len Pointer to the amount of bytes remaining in the input stream.
extern bool bib_parse_volume(bib_volume_t *vol, char const **str, size_t *len);

__END_DECLS

#endif /* bibparse_h */
