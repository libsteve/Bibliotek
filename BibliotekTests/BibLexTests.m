//
//  BibLexTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 9/29/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "biblex.h"
#import "bibtype.h"

#define BibAssertEqualStrings(expression1, expression2, ...) \
    _XCTPrimitiveAssertEqualObjects(self, @(expression1), @#expression1, @(expression2), @#expression2, __VA_ARGS__)

@interface BibLexTests : XCTestCase

@end

@implementation BibLexTests

- (void)test_lex_integer {
    {
        bib_digit06_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("1234", 0);
        XCTAssertTrue(bib_lex_integer(buffer, &lexer), @"should read string starting with digits");
        BibAssertEqualStrings(buffer, "1234", @"buffer should contain all the numbers");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("123456789", 0);
        XCTAssertTrue(bib_lex_integer(buffer, &lexer), @"should read the first four difits");
        BibAssertEqualStrings(buffer, "123456", @"buffer should only the first six  digits");
        BibAssertEqualStrings(lexer.str, "789", @"the input string should still contain the remaining digits");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("12", 0);
        XCTAssertTrue(bib_lex_integer(buffer, &lexer), @"should read less than four digits");
        BibAssertEqualStrings(buffer, "12", @"buffer should only the first four  digits");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("A1", 0);
        XCTAssertFalse(bib_lex_integer(buffer, &lexer), @"should not read string with non-digit prefix as integer");
        BibAssertEqualStrings(buffer, "", @"buffer should remain empty");
        BibAssertEqualStrings(lexer.str, "A1", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_lex_integer(buffer, &lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_digit16 {
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("1234567812345678", 0);
        XCTAssertTrue(bib_lex_digit16(buffer, &lexer), @"should read string starting with digits");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("abc1234567812345", 0);
        XCTAssertFalse(bib_lex_digit16(buffer, &lexer), @"numbers must begin with at least one digit");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(lexer.str, "abc1234567812345", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("12345", 0);
        XCTAssertTrue(bib_lex_digit16(buffer, &lexer), @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("12345abcdefg", 0);
        XCTAssertTrue(bib_lex_digit16(buffer, &lexer), @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(lexer.str, "abcdefg", @"the non-numeral characters should not be consumed");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_lex_digit16(buffer, &lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_decimal {
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf(".1234567812345678", 0);
        XCTAssertTrue(bib_lex_decimal(buffer, &lexer), @"should read string starting with decimal and numbers");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain the numbers without the period");
        BibAssertEqualStrings(lexer.str, "", @"there should be no characters left in the input string");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("1234567812345678", 0);
        XCTAssertFalse(bib_lex_decimal(buffer, &lexer), @"decimals must begin with a period");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(lexer.str, "1234567812345678", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf(".abcdefg", 0);
        XCTAssertFalse(bib_lex_decimal(buffer, &lexer), @"decimals have at least one digit after the period");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(lexer.str, ".abcdefg", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf(".12345", 0);
        XCTAssertTrue(bib_lex_decimal(buffer, &lexer), @"a decimal can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(lexer.str, "", @"there should be no characters left in the input string");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf(".12345abcdefg", 0);
        XCTAssertTrue(bib_lex_decimal(buffer, &lexer), @"a decimal can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(lexer.str, "abcdefg", @"the non-numeral characters after the decomal should remain");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_lex_decimal(buffer, &lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_subclass {
    {
        bib_alpah03_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("A", 0);
        XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass can contain one capital letter");
        BibAssertEqualStrings(buffer, "A", @"buffer should contain the read character");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("AB", 0);
        XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass can contain two capital letters");
        BibAssertEqualStrings(buffer, "AB", @"buffer should contain the read characters");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("ABC", 0);
        XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass can contain three capital letters");
        BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the read characters");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("ABCD", 0);
        XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass contains at most three characters");
        BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the first three characters");
        BibAssertEqualStrings(lexer.str, "D", @"the input string should contain the fourth character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_lex_subclass(buffer, &lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_digit_n {
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("1234567812345678", 0);
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 16,
                       @"return the count of all numeral characters read");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("abc1234567812345", 0);
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 0,
                       @"numbers must begin with at least one digit");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(lexer.str, "abc1234567812345", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("12345", 0);
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 5,
                       @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("12345abcdefg", 0);
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 5,
                       @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(lexer.str, "abcdefg", @"the non-numeral characters should not be consumed");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_space {
    {
        bib_strbuf_t lexer = bib_strbuf(" ", 0);
        XCTAssertTrue(bib_read_space(&lexer), @"should consume space character");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("\n", 0);
        XCTAssertTrue(bib_read_space(&lexer), @"should consume newline character");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("\t", 0);
        XCTAssertTrue(bib_read_space(&lexer), @"should consume tab character");
        BibAssertEqualStrings(lexer.str, "", @"the remaining input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf(" \n\t", 0);
        XCTAssertTrue(bib_read_space(&lexer), @"should consume all adjacent spaces");
        BibAssertEqualStrings(lexer.str, "", @"the remaining input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("  n ", 0);
        XCTAssertTrue(bib_read_space(&lexer), @"should consume only adjacnet spaces");
        BibAssertEqualStrings(lexer.str, "n ", @"the remaining input string should contain the first non-space character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("a  ", 0);
        XCTAssertFalse(bib_read_space(&lexer), @"should only consume initial space characters");
        BibAssertEqualStrings(lexer.str, "a  ", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_read_space(&lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_cutter_ordinal_suffix {
    {
        bib_strbuf_t lexer = bib_strbuf("th", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th ", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, " ", @"the input string should still contain the trailing space");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th.", 0);
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &lexer),
                       @"should not read ordinal suffix with period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(lexer.str, "th.", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th C24", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &lexer),
                      @"should read ordinal suffix without cutter");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, " C24", @"the input string should contain the next cutter");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th1", 0);
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &lexer),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(lexer.str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_caption_ordinal_suffix {
    {
        bib_strbuf_t lexer = bib_strbuf("th", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix at end");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th.", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer),
                      @"should read ordinal suffix before period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, ".", @"the input string should still contain the trailing period");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th.C64", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer),
                      @"should read ordinal suffix before period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, ".C64", @"the input string should still contain the trailing period");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th .C64", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer), @"shouldn read suffix without period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(lexer.str, " .C64", @"the input string should still contain the trailing period");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th1", 0);
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_caption_ordinal_suffix(suffix, &lexer),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(lexer.str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_specification_ordinal_suffix {
    {
        bib_strbuf_t lexer = bib_strbuf("th.", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th.", @"buffer should contain the whole suffix with the period");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th.ed.", 0);
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                      @"should read compound ordinal suffix");
        BibAssertEqualStrings(suffix, "th.ed.", @"buffer should contain the whole suffix with periods");
        BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th", 0);
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                       @"should not read suffix without period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(lexer.str, "th", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th.ed", 0);
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                       @"should not read compound suffix without period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(lexer.str, "th.ed", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("th1", 0);
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(lexer.str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_point {
    {
        bib_strbuf_t lexer = bib_strbuf(".", 0);
        XCTAssertTrue(bib_read_point(&lexer), @"should consume single period");
        BibAssertEqualStrings(lexer.str, "", @"input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("..", 0);
        XCTAssertTrue(bib_read_point(&lexer), @"should consume only one period");
        BibAssertEqualStrings(lexer.str, ".", @"input string should contain the remaining period");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("a.", 0);
        XCTAssertFalse(bib_read_point(&lexer), @"should only consume the initial period");
        BibAssertEqualStrings(lexer.str, "a.", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_read_point(&lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_dash {
    {
        bib_strbuf_t lexer = bib_strbuf("-", 0);
        XCTAssertTrue(bib_read_dash(&lexer), @"should consume single dash");
        BibAssertEqualStrings(lexer.str, "", @"input string should be empty");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("--", 0);
        XCTAssertTrue(bib_read_dash(&lexer), @"should consume only one dash");
        BibAssertEqualStrings(lexer.str, "-", @"input string should contain the remaining dash");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("a-", 0);
        XCTAssertFalse(bib_read_dash(&lexer), @"should only consume the initial dash");
        BibAssertEqualStrings(lexer.str, "a-", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_strbuf_t lexer = bib_strbuf("", 0);
        XCTAssertFalse(bib_read_dash(&lexer), @"cannot lex the empty string");
        BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
    }
}

@end
