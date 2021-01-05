//
//  BibLexSpaceTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "biblex.h"
#import "bibtype.h"

@interface BibLexSpaceTests : XCTestCase
@end

@implementation BibLexSpaceTests

- (void)test_01_consume_space {
    bib_strbuf_t lexer = bib_strbuf(" ", 0);
    XCTAssertTrue(bib_read_space(&lexer), @"should consume space character");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_02_consume_newline {
    bib_strbuf_t lexer = bib_strbuf("\n", 0);
    XCTAssertTrue(bib_read_space(&lexer), @"should consume newline character");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_03_consume_tab {
    bib_strbuf_t lexer = bib_strbuf("\t", 0);
    XCTAssertTrue(bib_read_space(&lexer), @"should consume tab character");
    BibAssertEqualStrings(lexer.str, "", @"the remaining input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_04_consume_newline_and_tab {
    bib_strbuf_t lexer = bib_strbuf(" \n\t", 0);
    XCTAssertTrue(bib_read_space(&lexer), @"should consume all adjacent spaces");
    BibAssertEqualStrings(lexer.str, "", @"the remaining input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_05_consume_only_adjacent_spaces {
    bib_strbuf_t lexer = bib_strbuf("  n ", 0);
    XCTAssertTrue(bib_read_space(&lexer), @"should consume only adjacnet spaces");
    BibAssertEqualStrings(lexer.str, "n ", @"the remaining input string should contain the first non-space character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_06_consume_only_initial_spaces {
    bib_strbuf_t lexer = bib_strbuf("a  ", 0);
    XCTAssertFalse(bib_read_space(&lexer), @"should only consume initial space characters");
    BibAssertEqualStrings(lexer.str, "a  ", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_07_fail_on_empty_string {
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_read_space(&lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

@end
