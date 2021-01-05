//
//  BibLexReadTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "biblex.h"
#import "bibtype.h"

@interface BibLexReadTests : XCTestCase
@end

@implementation BibLexReadTests

- (void)test_point_01 {
    bib_strbuf_t lexer = bib_strbuf(".", 0);
    XCTAssertTrue(bib_read_point(&lexer), @"should consume single period");
    BibAssertEqualStrings(lexer.str, "", @"input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_point_02 {
    bib_strbuf_t lexer = bib_strbuf("..", 0);
    XCTAssertTrue(bib_read_point(&lexer), @"should consume only one period");
    BibAssertEqualStrings(lexer.str, ".", @"input string should contain the remaining period");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_point_03 {
    bib_strbuf_t lexer = bib_strbuf("a.", 0);
    XCTAssertFalse(bib_read_point(&lexer), @"should only consume the initial period");
    BibAssertEqualStrings(lexer.str, "a.", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_point_04 {
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_read_point(&lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

#pragma mark -

- (void)test_dash_01 {
    bib_strbuf_t lexer = bib_strbuf("-", 0);
    XCTAssertTrue(bib_read_dash(&lexer), @"should consume single dash");
    BibAssertEqualStrings(lexer.str, "", @"input string should be empty");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_dash_02 {
    bib_strbuf_t lexer = bib_strbuf("--", 0);
    XCTAssertTrue(bib_read_dash(&lexer), @"should consume only one dash");
    BibAssertEqualStrings(lexer.str, "-", @"input string should contain the remaining dash");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_dash_03 {
    bib_strbuf_t lexer = bib_strbuf("a-", 0);
    XCTAssertFalse(bib_read_dash(&lexer), @"should only consume the initial dash");
    BibAssertEqualStrings(lexer.str, "a-", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_dash_04 {
    bib_strbuf_t lexer = bib_strbuf("", 0);
    XCTAssertFalse(bib_read_dash(&lexer), @"cannot lex the empty string");
    BibAssertEqualStrings(lexer.str, "", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

@end
