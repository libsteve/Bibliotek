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
        char const *str = "1234";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_integer(buffer, &l), @"should read string starting with digits");
        BibAssertEqualStrings(buffer, "1234", @"buffer should contain all the numbers");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        char const *str = "123456789";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_integer(buffer, &l), @"should read the first four difits");
        BibAssertEqualStrings(buffer, "123456", @"buffer should only the first six  digits");
        BibAssertEqualStrings(l.str, "789", @"the input string should still contain the remaining digits");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        char const *str = "12";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_integer(buffer, &l), @"should read less than four digits");
        BibAssertEqualStrings(buffer, "12", @"buffer should only the first four  digits");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        char const *str = "A1";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_integer(buffer, &l), @"should not read string with non-digit prefix as integer");
        BibAssertEqualStrings(buffer, "", @"buffer should remain empty");
        BibAssertEqualStrings(l.str, "A1", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit06_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_integer(buffer, &l), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_digit16 {
    {
        bib_digit16_b buffer = {};
        char const *str = "1234567812345678";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_digit16(buffer, &l), @"should read string starting with digits");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "abc1234567812345";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_digit16(buffer, &l), @"numbers must begin with at least one digit");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(l.str, "abc1234567812345", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_digit16(buffer, &l), @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345abcdefg";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_digit16(buffer, &l), @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(l.str, "abcdefg", @"the non-numeral characters should not be consumed");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_digit16(buffer, &l), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_decimal {
    {
        bib_digit16_b buffer = {};
        char const *str = ".1234567812345678";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_decimal(buffer, &l), @"should read string starting with decimal and numbers");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain the numbers without the period");
        BibAssertEqualStrings(l.str, "", @"there should be no characters left in the input string");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "1234567812345678";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_decimal(buffer, &l), @"decimals must begin with a period");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(l.str, "1234567812345678", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = ".abcdefg";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_decimal(buffer, &l), @"decimals have at least one digit after the period");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(l.str, ".abcdefg", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = ".12345";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_decimal(buffer, &l), @"a decimal can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(l.str, "", @"there should be no characters left in the input string");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = ".12345abcdefg";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_decimal(buffer, &l), @"a decimal can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(l.str, "abcdefg", @"the non-numeral characters after the decomal should remain");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_decimal(buffer, &l), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_subclass {
    {
        bib_alpah03_b buffer = {};
        char const *str = "A";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_subclass(buffer, &l), @"subclass can contain one capital letter");
        BibAssertEqualStrings(buffer, "A", @"buffer should contain the read character");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "AB";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_subclass(buffer, &l), @"subclass can contain two capital letters");
        BibAssertEqualStrings(buffer, "AB", @"buffer should contain the read characters");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "ABC";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_subclass(buffer, &l), @"subclass can contain three capital letters");
        BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the read characters");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "ABCD";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_lex_subclass(buffer, &l), @"subclass contains at most three characters");
        BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the first three characters");
        BibAssertEqualStrings(l.str, "D", @"the input string should contain the fourth character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_subclass(buffer, &l), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_digit_n {
    {
        bib_digit16_b buffer = {};
        char const *str = "1234567812345678";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &l), 16,
                       @"return the count of all numeral characters read");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "abc1234567812345";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &l), 0,
                       @"numbers must begin with at least one digit");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(l.str, "abc1234567812345", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &l), 5,
                       @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345abcdefg";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &l), 5,
                       @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(l.str, "abcdefg", @"the non-numeral characters should not be consumed");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &l), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_space {
    {
        char const *str = " ";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_space(&l), @"should consume space character");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "\n";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_space(&l), @"should consume newline character");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "\t";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_space(&l), @"should consume tab character");
        BibAssertEqualStrings(l.str, "", @"the remaining input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = " \n\t";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_space(&l), @"should consume all adjacent spaces");
        BibAssertEqualStrings(l.str, "", @"the remaining input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "  n ";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_space(&l), @"should consume only adjacnet spaces");
        BibAssertEqualStrings(l.str, "n ", @"the remaining input string should contain the first non-space character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "a  ";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_read_space(&l), @"should only consume initial space characters");
        BibAssertEqualStrings(l.str, "a  ", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_read_space(&l), @"cannot lex the empty string");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_cutter_ordinal_suffix {
    {
        char const *str = "th";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &l), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th ";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &l), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, " ", @"the input string should still contain the trailing space");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &l),
                       @"should not read ordinal suffix with period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(l.str, "th.", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th C24";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &l),
                      @"should read ordinal suffix without cutter");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, " C24", @"the input string should contain the next cutter");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th1";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &l),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(l.str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_caption_ordinal_suffix {
    {
        char const *str = "th";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &l), @"should read ordinal suffix at end");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &l),
                      @"should read ordinal suffix before period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, ".", @"the input string should still contain the trailing period");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.C64";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &l),
                      @"should read ordinal suffix before period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, ".C64", @"the input string should still contain the trailing period");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th .C64";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &l), @"shouldn read suffix without period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(l.str, " .C64", @"the input string should still contain the trailing period");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th1";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_caption_ordinal_suffix(suffix, &l),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(l.str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_specification_ordinal_suffix {
    {
        char const *str = "th.";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &l), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th.", @"buffer should contain the whole suffix with the period");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.ed.";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &l),
                      @"should read compound ordinal suffix");
        BibAssertEqualStrings(suffix, "th.ed.", @"buffer should contain the whole suffix with periods");
        BibAssertEqualStrings(l.str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &l),
                       @"should not read suffix without period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(l.str, "th", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.ed";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &l),
                       @"should not read compound suffix without period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(l.str, "th.ed", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th1";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &l),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(l.str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_point {
    {
        char const *str = ".";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_point(&l), @"should consume single period");
        BibAssertEqualStrings(l.str, "", @"input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "..";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_point(&l), @"should consume only one period");
        BibAssertEqualStrings(l.str, ".", @"input string should contain the remaining period");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "a.";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_read_point(&l), @"should only consume the initial period");
        BibAssertEqualStrings(l.str, "a.", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_read_point(&l), @"cannot lex the empty string");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_dash {
    {
        char const *str = "-";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_dash(&l), @"should consume single dash");
        BibAssertEqualStrings(l.str, "", @"input string should be empty");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "--";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertTrue(bib_read_dash(&l), @"should consume only one dash");
        BibAssertEqualStrings(l.str, "-", @"input string should contain the remaining dash");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "a-";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_read_dash(&l), @"should only consume the initial dash");
        BibAssertEqualStrings(l.str, "a-", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "";
        size_t len = strlen(str) + 1;
        bib_strbuf_t l = { .str = str, .len = len };
        XCTAssertFalse(bib_read_dash(&l), @"cannot lex the empty string");
        BibAssertEqualStrings(l.str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(l.len, strlen(l.str) + 1, @"len should equal the input string's remaining length");
    }
}

@end
