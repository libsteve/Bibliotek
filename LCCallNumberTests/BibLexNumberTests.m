//
//  BibLexNumberTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "biblex.h"
#import "bibtype.h"

@interface BibLexNumberTests : XCTestCase
@end

@implementation BibLexNumberTests

- (void)test_ditit06_01 {
    bib_digit06_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("1234", 0);
    XCTAssertTrue(bib_lex_integer(buffer, &lexer), @"should read string starting with digits");
    BibAssertEqualStrings(buffer, "1234", @"buffer should contain all the numbers");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_ditit06_02 {
    bib_digit06_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("123456789", 0);
    XCTAssertTrue(bib_lex_integer(buffer, &lexer), @"should read the first four difits");
    BibAssertEqualStrings(buffer, "123456", @"buffer should only the first six  digits");
    BibAssertEqualStrings(lexer.str, "789", @"the input string should still contain the remaining digits");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_ditit06_03 {
    bib_digit06_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("12", 0);
    XCTAssertTrue(bib_lex_integer(buffer, &lexer), @"should read less than four digits");
    BibAssertEqualStrings(buffer, "12", @"buffer should only the first four  digits");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_ditit06_04 {
    bib_digit06_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("A1", 0);
    XCTAssertFalse(bib_lex_integer(buffer, &lexer), @"should not read string with non-digit prefix as integer");
    BibAssertEqualStrings(buffer, "", @"buffer should remain empty");
    BibAssertEqualStrings(lexer.str, "A1", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_ditit06_05 {
    bib_digit06_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_lex_integer(buffer, &lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

#pragma mark -

- (void)test_digit16_01 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("1234567812345678", 0);
    XCTAssertTrue(bib_lex_digit16(buffer, &lexer), @"should read string starting with digits");
    BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digit16_02 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("abc1234567812345", 0);
    XCTAssertFalse(bib_lex_digit16(buffer, &lexer), @"numbers must begin with at least one digit");
    BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
    BibAssertEqualStrings(lexer.str, "abc1234567812345", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digit16_03 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("12345", 0);
    XCTAssertTrue(bib_lex_digit16(buffer, &lexer), @"a number can have less than 16 digits");
    BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digit16_04 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("12345abcdefg", 0);
    XCTAssertTrue(bib_lex_digit16(buffer, &lexer), @"a number can have less than 16 digits");
    BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
    BibAssertEqualStrings(lexer.str, "abcdefg", @"the non-numeral characters should not be consumed");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digit16_05 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_lex_digit16(buffer, &lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

#pragma mark -

- (void)test_decimal_01 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf(".1234567812345678", 0);
    XCTAssertTrue(bib_lex_decimal(buffer, &lexer), @"should read string starting with decimal and numbers");
    BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain the numbers without the period");
    BibAssertEqualStrings(lexer.str, "", @"there should be no characters left in the input string");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_decimal_02 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("1234567812345678", 0);
    XCTAssertFalse(bib_lex_decimal(buffer, &lexer), @"decimals must begin with a period");
    BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
    BibAssertEqualStrings(lexer.str, "1234567812345678", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_decimal_03 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf(".abcdefg", 0);
    XCTAssertFalse(bib_lex_decimal(buffer, &lexer), @"decimals have at least one digit after the period");
    BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
    BibAssertEqualStrings(lexer.str, ".abcdefg", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_decimal_04 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf(".12345", 0);
    XCTAssertTrue(bib_lex_decimal(buffer, &lexer), @"a decimal can have less than 16 digits");
    BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
    BibAssertEqualStrings(lexer.str, "", @"there should be no characters left in the input string");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_decimal_05 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf(".12345abcdefg", 0);
    XCTAssertTrue(bib_lex_decimal(buffer, &lexer), @"a decimal can have less than 16 digits");
    BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
    BibAssertEqualStrings(lexer.str, "abcdefg", @"the non-numeral characters after the decomal should remain");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_decimal_06 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_lex_decimal(buffer, &lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

#pragma mark -

- (void)test_digitXX_01 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("1234567812345678", 0);
    XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 16,
                   @"return the count of all numeral characters read");
    BibAssertEqualStrings(buffer, "1234567812345678", @"buffer should contain all the numbers");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digitXX_02 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("abc1234567812345", 0);
    XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 0,
                   @"numbers must begin with at least one digit");
    BibAssertEqualStrings(buffer, "", @"failure should leave the output buffer unchanged");
    BibAssertEqualStrings(lexer.str, "abc1234567812345", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digitXX_03 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("12345", 0);
    XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 5,
                   @"a number can have less than 16 digits");
    BibAssertEqualStrings(buffer, "12345", @"the output buffer should contain the digits");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digitXX_04 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("12345abcdefg", 0);
    XCTAssertEqual(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), 5,
                   @"a number can have less than 16 digits");
    BibAssertEqualStrings(buffer, "12345", @"the output buffer should not contain non-numeral characters");
    BibAssertEqualStrings(lexer.str, "abcdefg", @"the non-numeral characters should not be consumed");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_digitXX05 {
    bib_digit16_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_lex_digit_n(buffer, sizeof(bib_digit16_b), &lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

@end
