//
//  BibLexOrdinalSuffixTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "biblex.h"
#import "bibtype.h"

@interface BibLexOrdinalSuffixTests : XCTestCase
@end

@implementation BibLexOrdinalSuffixTests

- (void)test_cutter_ordinal_suffix_01_valid_at_end {
    bib_strbuf_t lexer = bib_strbuf("th", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_cutter_ordinal_suffix_02_dont_consume_trailing_space {
    bib_strbuf_t lexer = bib_strbuf("th ", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, " ", @"the input string should still contain the trailing space");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_cutter_ordinal_suffix_03_fail_with_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th.", 0);
    bib_word_b suffix = {};
    XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &lexer),
                   @"should not read ordinal suffix with period");
    BibAssertEqualStrings(suffix, "", @"buffer should be empty");
    BibAssertEqualStrings(lexer.str, "th.", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_cutter_ordinal_suffix_04_valid {
    bib_strbuf_t lexer = bib_strbuf("th C24", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_cutter_ordinal_suffix(suffix, &lexer),
                  @"should read ordinal suffix without cutter");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, " C24", @"the input string should contain the next cutter");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_cutter_ordinal_suffix_05_fail_with_digits {
    bib_strbuf_t lexer = bib_strbuf("th1", 0);
    bib_word_b suffix = {};
    XCTAssertFalse(bib_lex_cutter_ordinal_suffix(suffix, &lexer),
                   @"should not read ordinal suffix with digits");
    BibAssertEqualStrings(suffix, "", @"buffer should be empty");
    BibAssertEqualStrings(lexer.str, "th1", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

#pragma mark -

- (void)test_caption_ordinal_suffix_01_valid_at_end {
    bib_strbuf_t lexer = bib_strbuf("th", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix at end");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_caption_ordinal_suffix_02_dont_consume_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th.", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer),
                  @"should read ordinal suffix before period");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, ".", @"the input string should still contain the trailing period");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_caption_ordinal_suffix_03_read_before_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th.C64", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer),
                  @"should read ordinal suffix before period");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, ".C64", @"the input string should still contain the trailing period");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_caption_ordinal_suffix_04_require_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th .C64", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_caption_ordinal_suffix(suffix, &lexer), @"shouldn read suffix without period");
    BibAssertEqualStrings(suffix, "th", @"buffer should contain the whole suffix");
    BibAssertEqualStrings(lexer.str, " .C64", @"the input string should still contain the trailing period");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_caption_ordinal_suffix_05_fail_with_digits {
    bib_strbuf_t lexer = bib_strbuf("th1", 0);
    bib_word_b suffix = {};
    XCTAssertFalse(bib_lex_caption_ordinal_suffix(suffix, &lexer),
                   @"should not read ordinal suffix with digits");
    BibAssertEqualStrings(suffix, "", @"buffer should be empty");
    BibAssertEqualStrings(lexer.str, "th1", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

#pragma mark -

- (void)test_specification_ordinal_suffix_01_consume_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th.", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &lexer), @"should read ordinal suffix");
    BibAssertEqualStrings(suffix, "th.", @"buffer should contain the whole suffix with the period");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_specification_ordinal_suffix_02_consume_multiple_suffixes_together {
    bib_strbuf_t lexer = bib_strbuf("th.ed.", 0);
    bib_word_b suffix = {};
    XCTAssertTrue(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                  @"should read compound ordinal suffix");
    BibAssertEqualStrings(suffix, "th.ed.", @"buffer should contain the whole suffix with periods");
    BibAssertEqualStrings(lexer.str, "", @"the input string should be empty, containing only the null character");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_specification_ordinal_suffix_03_require_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th", 0);
    bib_word_b suffix = {};
    XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                   @"should not read suffix without period");
    BibAssertEqualStrings(suffix, "", @"buffer should be empty");
    BibAssertEqualStrings(lexer.str, "th", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_specification_ordinal_suffix_04_require_trailing_period {
    bib_strbuf_t lexer = bib_strbuf("th.ed", 0);
    bib_word_b suffix = {};
    XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                   @"should not read compound suffix without period");
    BibAssertEqualStrings(suffix, "", @"buffer should be empty");
    BibAssertEqualStrings(lexer.str, "th.ed", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

- (void)test_specification_ordinal_suffix_05_fail_with_digits {
    bib_strbuf_t lexer = bib_strbuf("th1", 0);
    bib_word_b suffix = {};
    XCTAssertFalse(bib_lex_specification_ordinal_suffix(suffix, &lexer),
                   @"should not read ordinal suffix with digits");
    BibAssertEqualStrings(suffix, "", @"buffer should be empty");
    BibAssertEqualStrings(lexer.str, "th1", @"failure should leave the input string unchanged");
    XCTAssertEqual(lexer.len, strlen(lexer.str) + 1, @"len should equal the input string's remaining length");
}

@end
