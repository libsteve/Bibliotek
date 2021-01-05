//
//  BibLexClassLettersTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "biblex.h"
#import "bibtype.h"

@interface BibLexClassLettersTests : XCTestCase
@end

@implementation BibLexClassLettersTests

- (void)test_01_allow_one_capital_letter {
    bib_alpah03_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("A", 0);
    XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass can contain one capital letter");
    BibAssertEqualStrings(buffer, "A", @"buffer should contain the read character");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_02_allow_two_capital_letters {
    bib_alpah03_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("AB", 0);
    XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass can contain two capital letters");
    BibAssertEqualStrings(buffer, "AB", @"buffer should contain the read characters");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_03_allow_three_capital_letters {
    bib_alpah03_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("ABC", 0);
    XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass can contain three capital letters");
    BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the read characters");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_04_read_only_three_letters {
    bib_alpah03_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("ABCD", 0);
    XCTAssertTrue(bib_lex_subclass(buffer, &lexer), @"subclass contains at most three characters");
    BibAssertEqualStrings(buffer, "ABC", @"buffer should contain the first three characters");
    BibAssertEqualStrings(lexer.str, "D", @"the input string should contain the fourth character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_05_require_one_letter {
    bib_alpah03_b buffer = {};
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_lex_subclass(buffer, &lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(buffer, "", @"the output buffer should be empty");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

@end
