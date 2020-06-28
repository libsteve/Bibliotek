//
//  BibCharacterConversion.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/24/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import "BibCharacterConversion.h"
#import <yaz/yaz-iconv.h>

bib_char_encoding_t const bib_char_encoding_utf8 = "utf8";
bib_char_encoding_t const bib_char_encoding_marc8 = "marc8";

typedef struct bib_char_converter {
    yaz_iconv_t cp;
    int errorno;
} *bib_char_converter_t;

bib_char_converter_t bib_char_converter_open(bib_char_encoding_t const to, bib_char_encoding_t const from)
{
    bib_char_converter_t converter = malloc(sizeof(struct bib_char_converter));
    converter->cp = yaz_iconv_open(to, from);
    converter->errorno = 0;
    return converter;
}

void bib_char_converter_close(bib_char_converter_t const converter)
{
    yaz_iconv_close(converter->cp);
    free(converter);
}

int bib_char_converter_error(bib_char_converter_t const converter)
{
    return converter->errorno;
}

/// Convert the given string to another encoding, using the given converter.
/// \param converter The iconv converter handle provided by yaz.
/// \param string A string of characters to represent using an alternate encoding scheme.
/// \returns The converted string value of the original string. This value must be freed by the caller.
///          \c NULL is returned when there is an error converting the given string.
/// \post Call \c yaz_iconv_error() to get the error code when \c NULL is returned.
extern char *bib_char_convert(bib_char_converter_t const converter, char const *string)
{
    char const *in_buffer = string;
    size_t in_length = strlen(in_buffer) + 1;

    size_t length = in_length;
    char *result = malloc(length);

    char *out_buffer = result;
    size_t out_length = length;

    size_t iteraton = 0;
    size_t conversion_count;
    do {
        conversion_count = yaz_iconv(converter->cp, (char **)&in_buffer, &in_length, &out_buffer, &out_length);
        if (conversion_count == -1) {
            int errorno = yaz_iconv_error(converter->cp);
            if (errorno == YAZ_ICONV_E2BIG || errorno == 0) {
                iteraton += 1;
                size_t const extra_size = iteraton * 32;
                size_t const offset = length - out_length;
                length += extra_size;
                out_length += extra_size;
                result = realloc(result, length);
                out_buffer = &(result[offset]);
            } else {
                switch (errorno) {
                    case YAZ_ICONV_EILSEQ:
                        converter->errorno = EILSEQ;
                        break;
                    case YAZ_ICONV_EINVAL:
                        converter->errorno = EINVAL;
                        break;
                    default:
                        converter->errorno = errno;
                        break;
                }
                // clear any state left in the converter
                yaz_iconv(converter->cp, NULL, NULL, NULL, NULL);
                free(result);
                return NULL;
            }
        }
    } while (conversion_count == -1);

    do {
        // flush out any state and store remaining characters into the output buffer
        conversion_count = yaz_iconv(converter->cp, NULL, NULL, &out_buffer, &out_length);
        if (conversion_count == -1) {
            int errorno = yaz_iconv_error(converter->cp);
            if (errorno == YAZ_ICONV_E2BIG || errorno == 0) {
                iteraton += 1;
                size_t const extra_size = iteraton * 32;
                size_t const offset = length - out_length;
                length += extra_size;
                out_length += extra_size;
                result = realloc(result, length);
                out_buffer = &(result[offset]);
            } else {
                switch (errorno) {
                    case YAZ_ICONV_EILSEQ:
                        converter->errorno = EILSEQ;
                        break;
                    case YAZ_ICONV_EINVAL:
                        converter->errorno = EINVAL;
                        break;
                    default:
                        converter->errorno = errno;
                        break;
                }
                // clear any state left in the converter
                yaz_iconv(converter->cp, NULL, NULL, NULL, NULL);
                free(result);
                return NULL;
            }
        }
    } while (conversion_count == -1);

    // make sure the result is null-terminated
    size_t result_length = length - out_length;
    if (result[result_length - 1] != '\0') {
        if (out_length == 0) {
            result = realloc(result, length + 1);
            result[length] = '\0';
        } else {
            result[result_length] = '\0';
        }
    }

    return result;

}

NSString *bib_char_convert_marc8(bib_char_converter_t const converter, char const *const string)
{
    char *const result = bib_char_convert(converter, string);
    NSCAssert(result != NULL, @"Error converting MARC8 string to UTF8: %s", strerror(converter->errorno));
    return [[NSString alloc] initWithBytesNoCopy:result length:strlen(result)
                                        encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

char *bib_char_convert_utf8(bib_char_converter_t const converter, NSString *const string)
{
    char *const result = bib_char_convert(converter, [string UTF8String]);
    NSCAssert(result != NULL, @"Error converting UTF8 string to MARC8: %s", strerror(converter->errorno));
    return result;
}
