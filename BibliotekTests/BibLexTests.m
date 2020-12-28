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
        bib_digit04_b buffer = {};
        char const *str = "1234";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_integer(buffer, &str, &len), @"should read string starting with digits");
        BibAssertEqualStrings(buffer, "1234", @"buffer should contain all the numbers");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit04_b buffer = {};
        char const *str = "1234567";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_integer(buffer, &str, &len), @"should read the first four difits");
        BibAssertEqualStrings(buffer, "1234", @"buffer should only the first four  digits");
        BibAssertEqualStrings(str, "567", @"the input string should still contain the remaining digits");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit04_b buffer = {};
        char const *str = "12";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_integer(buffer, &str, &len), @"should read less than four digits");
        BibAssertEqualStrings(buffer, "12", @"buffer should only the first four  digits");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit04_b buffer = {};
        char const *str = "A1";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_integer(buffer, &str, &len), @"should not read string with non-digit prefix as integer");
        BibAssertEqualStrings(buffer, "", @"buffer should remain empty");
        BibAssertEqualStrings(str, "A1", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit04_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_integer(buffer, &str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_digit16 {
    {
        bib_digit16_b buffer = {};
        char const *str = "1234567812345678";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_digit16(buffer, &str, &len), @"should read string starting with digits");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "abc1234567812345";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_digit16(buffer, &str, &len), @"numbers must begin with at least one digit");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(str, "abc1234567812345", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_digit16(buffer, &str, &len), @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345abcdefg";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_digit16(buffer, &str, &len), @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(str, "abcdefg", @"the non-numeral characters should not be consumed");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_digit16(buffer, &str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_decimal {
    {
        bib_digit16_b buffer = {};
        char const *str = ".1234567812345678";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_decimal(buffer, &str, &len), @"should read string starting with decimal and numbers");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain the numbers without the period");
        BibAssertEqualStrings(str, "", @"there should be no characters left in the input string");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "1234567812345678";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_decimal(buffer, &str, &len), @"decimals must begin with a period");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(str, "1234567812345678", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = ".abcdefg";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_decimal(buffer, &str, &len), @"decimals have at least one digit after the period");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(str, ".abcdefg", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = ".12345";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_decimal(buffer, &str, &len), @"a decimal can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(str, "", @"there should be no characters left in the input string");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = ".12345abcdefg";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_decimal(buffer, &str, &len), @"a decimal can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(str, "abcdefg", @"the non-numeral characters after the decomal should remain");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_decimal(buffer, &str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_subclass {
    {
        bib_alpah03_b buffer = {};
        char const *str = "A";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_subclass(buffer, &str, &len), @"subclass can contain one capital letter");
        BibAssertEqualStrings(buffer, "A", @"buffer should contain the read character");
        BibAssertEqualStrings(str, "", @"the input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "AB";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_subclass(buffer, &str, &len), @"subclass can contain two capital letters");
        BibAssertEqualStrings(buffer, "AB", @"buffer should contain the read characters");
        BibAssertEqualStrings(str, "", @"the input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "ABC";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_subclass(buffer, &str, &len), @"subclass can contain three capital letters");
        BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the read characters");
        BibAssertEqualStrings(str, "", @"the input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "ABCD";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_lex_subclass(buffer, &str, &len), @"subclass contains at most three characters");
        BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the first three characters");
        BibAssertEqualStrings(str, "D", @"the input string should contain the fourth character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_alpah03_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_subclass(buffer, &str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_digit_n {
    {
        bib_digit16_b buffer = {};
        char const *str = "1234567812345678";
        size_t len = strlen(str) + 1;
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &str, &len), 16,
                       @"return the count of all numeral characters read");
        BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "abc1234567812345";
        size_t len = strlen(str) + 1;
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &str, &len), 0,
                       @"numbers must begin with at least one digit");
        BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
        BibAssertEqualStrings(str, "abc1234567812345", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345";
        size_t len = strlen(str) + 1;
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &str, &len), 5,
                       @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "12345abcdefg";
        size_t len = strlen(str) + 1;
        XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &str, &len), 5,
                       @"a number can have less than 16 digits");
        BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
        BibAssertEqualStrings(str, "abcdefg", @"the non-numeral characters should not be consumed");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        bib_digit16_b buffer = {};
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_space {
    {
        char const *str = " ";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_space(&str, &len), @"should consume space character");
        BibAssertEqualStrings(str, "", @"the input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "\n";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_space(&str, &len), @"should consume newline character");
        BibAssertEqualStrings(str, "", @"the input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "\t";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_space(&str, &len), @"should consume tab character");
        BibAssertEqualStrings(str, "", @"the remaining input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = " \n\t";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_space(&str, &len), @"should consume all adjacent spaces");
        BibAssertEqualStrings(str, "", @"the remaining input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "  n ";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_space(&str, &len), @"should consume only adjacnet spaces");
        BibAssertEqualStrings(str, "n ", @"the remaining input string should contain the first non-space character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "a  ";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_read_space(&str, &len), @"should only consume initial space characters");
        BibAssertEqualStrings(str, "a  ", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_read_space(&str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_cutter_ordinal_suffix {
    {
        char const *str = "th";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &str, &len), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th ";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &str, &len), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, " ", @"the input string should still contain the trailing space");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &str, &len),
                       @"should not read ordinal suffix with period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(str, "th.", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th C24";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &str, &len),
                      @"should read ordinal suffix without cutter");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, " C24", @"the input string should contain the next cutter");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th1";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &str, &len),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_caption_ordinal_suffix {
    {
        char const *str = "th";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &str, &len), @"should read ordinal suffix at end");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &str, &len),
                      @"should read ordinal suffix before period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, ".", @"the input string should still contain the trailing period");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.C64";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &str, &len),
                      @"should read ordinal suffix before period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, ".C64", @"the input string should still contain the trailing period");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th .C64";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &str, &len), @"shouldn read suffix without period");
        BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
        BibAssertEqualStrings(str, " .C64", @"the input string should still contain the trailing period");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th1";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_caption_ordinal_suffix(suffix, &str, &len),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_lex_specification_ordinal_suffix {
    {
        char const *str = "th.";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &str, &len), @"should read ordinal suffix");
        BibAssertEqualStrings(suffix, "th.", @"buffer should contain the whole suffix with the period");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.ed.";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &str, &len),
                      @"should read compound ordinal suffix");
        BibAssertEqualStrings(suffix, "th.ed.", @"buffer should contain the whole suffix with periods");
        BibAssertEqualStrings(str, "", @"the input string should be empty, containing only the null character");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &str, &len),
                       @"should not read suffix without period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(str, "th", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th.ed";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &str, &len),
                       @"should not read compound suffix without period");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(str, "th.ed", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "th1";
        size_t len = strlen(str) + 1;
        bib_word_b suffix = {};
        XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &str, &len),
                       @"should not read ordinal suffix with digits");
        BibAssertEqualStrings(suffix, "", @"buffer should be empty");
        BibAssertEqualStrings(str, "th1", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_point {
    {
        char const *str = ".";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_point(&str, &len), @"should consume single period");
        BibAssertEqualStrings(str, "", @"input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "..";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_point(&str, &len), @"should consume only one period");
        BibAssertEqualStrings(str, ".", @"input string should contain the remaining period");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "a.";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_read_point(&str, &len), @"should only consume the initial period");
        BibAssertEqualStrings(str, "a.", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_read_point(&str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

- (void)test_read_dash {
    {
        char const *str = "-";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_dash(&str, &len), @"should consume single dash");
        BibAssertEqualStrings(str, "", @"input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "--";
        size_t len = strlen(str) + 1;
        XCTAssertTrue(bib_read_dash(&str, &len), @"should consume only one dash");
        BibAssertEqualStrings(str, "-", @"input string should contain the remaining dash");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "a-";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_read_dash(&str, &len), @"should only consume the initial dash");
        BibAssertEqualStrings(str, "a-", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
    {
        char const *str = "";
        size_t len = strlen(str) + 1;
        XCTAssertFalse(bib_read_dash(&str, &len), @"cannot lex the empty string");
        BibAssertEqualStrings(str, "", @"failure should leave the input string unchanged");
        XCTAssertEqual(len, strlen(str) + 1, @"len should equal the input string's remaining length");
    }
}

@end
