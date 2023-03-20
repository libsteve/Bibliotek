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

typedef struct bib_char_conversion_context {
    char const *in_buffer;
    size_t in_length;

    char  *result_buffer;
    size_t result_length;

    char  *out_buffer;
    size_t out_length;

    size_t expansion_factor;
} bib_char_conversion_context_t;

static void bib_char_conversion_context_init(bib_char_conversion_context_t *context, char const *string);
static void bib_char_conversion_context_finalize(bib_char_conversion_context_t *context);
static void bib_char_conversion_context_expand(bib_char_conversion_context_t *context);

static bool bib_char_converter_handle_error(bib_char_converter_t converter,
                                            bib_char_conversion_context_t *context,
                                            int errorno);

/// Convert the given string to another encoding, using the given converter.
/// - parameter converter: The iconv converter handle provided by yaz.
/// - parameter string: A string of characters to represent using an alternate encoding scheme.
/// - returns: The converted string value of the original string. This value must be freed by the caller.
///            `NULL` is returned when there is an error converting the given string.
/// - postcondition: Call `yaz_iconv_error()` to get the error code when `NULL` is returned.
char *bib_char_convert(bib_char_converter_t const converter, char const *const string)
{
    bib_char_conversion_context_t context;
    bib_char_conversion_context_init(&context, string);

    size_t conversion_count;
    do {
        conversion_count = yaz_iconv(converter->cp, (char **)&context.in_buffer, &context.in_length,
                                                             &context.out_buffer, &context.out_length);
        if (conversion_count == -1) {
            int const errorno = yaz_iconv_error(converter->cp);
            if (! bib_char_converter_handle_error(converter, &context, errorno)) {
                return NULL;
            }
        }
    } while (conversion_count == -1);

    do {
        // flush out any state and store remaining characters into the output buffer
        conversion_count = yaz_iconv(converter->cp, NULL, NULL, &context.out_buffer, &context.out_length);
        if (conversion_count == -1) {
            int const errorno = yaz_iconv_error(converter->cp);
            if (! bib_char_converter_handle_error(converter, &context, errorno)) {
                return NULL;
            }
        }
    } while (conversion_count == -1);

    bib_char_conversion_context_finalize(&context);
    return context.result_buffer;

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

static void bib_char_conversion_context_init(bib_char_conversion_context_t *const context, char const *const string)
{
    size_t const string_len = strlen(string) + 1;

    context->in_buffer = string;
    context->in_length = string_len;

    context->result_buffer = malloc(string_len);
    context->result_length = string_len;

    context->out_buffer = context->result_buffer;
    context->out_length = context->result_length;

    context->expansion_factor = 0;
}

static void bib_char_conversion_context_finalize(bib_char_conversion_context_t *const context)
{
    // make sure the result is null-terminated
    size_t const final_length = context->result_length - context->out_length;
    if (context->result_buffer[final_length - 1] != '\0') {
        if (context->out_length == 0) {
            context->result_buffer = realloc(context->result_buffer, final_length + 1);
            context->result_buffer[final_length] = '\0';
            context->result_length = final_length;
        } else {
            context->result_buffer[final_length] = '\0';
        }
    }

    context->in_buffer = NULL;
    context->in_length = 0;

    context->out_buffer = NULL;
    context->out_length = 0;
}

static void bib_char_conversion_context_expand(bib_char_conversion_context_t *const context)
{
    context->expansion_factor += 1;
    size_t const extra_size = context->expansion_factor * 32;
    size_t const offset = context->result_length - context->out_length;
    context->result_length += extra_size;
    context->out_length += extra_size;
    context->result_buffer = realloc(context->result_buffer, context->result_length);
    context->out_buffer = &(context->result_buffer[offset]);
}

static void bib_char_conversion_context_destroy(bib_char_conversion_context_t *context)
{
    if (context->result_buffer != NULL) {
        free(context->result_buffer);
    }

    context->in_buffer = NULL;
    context->out_buffer = 0;

    context->result_buffer = NULL;
    context->result_length = 0;

    context->out_buffer = NULL;
    context->out_length = 0;

    context->expansion_factor = 0;
}

static bool bib_char_converter_handle_error(bib_char_converter_t const converter,
                                            bib_char_conversion_context_t *const context,
                                            int const errorno)
{
    if (errorno == YAZ_ICONV_E2BIG || errorno == 0) {
        bib_char_conversion_context_expand(context);
        return true;
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
        bib_char_conversion_context_destroy(context);
        return false;
    }
}
