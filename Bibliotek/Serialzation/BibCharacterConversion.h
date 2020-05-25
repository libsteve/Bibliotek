//
//  BibCharacterConversion.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/24/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <yaz/yaz-iconv.h>

typedef char const *bib_char_encoding_t NS_TYPED_EXTENSIBLE_ENUM;
extern bib_char_encoding_t const bib_char_encoding_utf8;
extern bib_char_encoding_t const bib_char_encoding_marc8;

typedef struct bib_char_converter *bib_char_converter_t;
extern bib_char_converter_t bib_char_converter_open(bib_char_encoding_t to, bib_char_encoding_t from);
extern void bib_char_converter_close(bib_char_converter_t converter);
extern int bib_char_converter_error(bib_char_converter_t converter);

/// Convert the given string to another encoding, using the given converter.
/// \param converter The iconv converter handle provided by yaz.
/// \param string A string of characters to represent using an alternate encoding scheme.
/// \returns The converted string value of the original string. This value must be freed by the caller.
///          \c NULL is returned when there is an error converting the given string.
/// \post Call \c yaz_iconv_error() to get the error code when \c NULL is returned.
extern char *bib_char_convert(bib_char_converter_t converter, char const *string);

extern NSString *bib_char_convert_marc8(bib_char_converter_t converter, char const *string) NS_RETURNS_RETAINED;
extern char *bib_char_convert_utf8(bib_char_converter_t converter, NSString *string);
