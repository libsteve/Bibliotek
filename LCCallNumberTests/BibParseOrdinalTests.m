//
//  BibParseOrdinalTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseOrdinalTests : XCTestCase

@end

@implementation BibParseOrdinalTests

- (void)test_cutter_ordinal_01_dont_consume_trailing_space {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th C21", 0);
    XCTAssertTrue(bib_parse_cutter_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, " C21", @"don't consume the space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_cutter_ordinal_02_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th C21", 0);
    XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th C21", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_cutter_ordinal_03_dont_allow_trailing_periods {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th. C21", 0);
    XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow trailing periods");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15th. C21", @"don't consume the period");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_cutter_ordinal_04_dont_allow_trailing_periods {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.C21", 0);
    XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow trailing periods");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15th.C21", @"don't consume the period");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_cutter_ordinal_05_valid {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th", 0);
    XCTAssertTrue(bib_parse_cutter_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_cutter_ordinal_06_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th", 0);
    XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_cutter_ordinal_07_require_word_break_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15thC21", 0);
    XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"word break required");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15thC21");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

#pragma mark -

- (void)test_caption_ordinal_01_dont_consume_trailing_period {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.C21", 0);
    XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, ".C21", @"don't consume the period");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_02_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th.C21", 0);
    XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th.C21", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_03_dont_consume_trailing_period {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th. C21", 0);
    XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, ". C21", @"don't consume the period");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_04_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th. C21", 0);
    XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th. C21", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_05_dont_require_period_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th C21", 0);
    XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, " C21", @"don't consume the space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_06_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th C21", 0);
    XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th C21", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_07_dont_consume_space_or_period_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th .C21", 0);
    XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, " .C21", @"don't consume the space and period");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_08_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th .C21", 0);
    XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th .C21", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_09_valid {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th", 0);
    XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_10_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th", 0);
    XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_caption_ordinal_11_require_period_or_space_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15thC21", 0);
    XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"word break required");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15thC21");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

#pragma mark -

- (void)test_specification_ordinal_01_consume_period_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.", 0);
    XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th.", @"consume periods");
    BibAssertEqualStrings(parser.str, "", @"consume periods");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_02_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th.", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th.", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_03_allow_multiple_suffixes {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.ed.", 0);
    XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th.ed.", @"consume periods");
    BibAssertEqualStrings(parser.str, "", @"consume periods");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_04_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th.ed.", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th.ed.", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_05_dont_consume_space_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.ed. 2020s", 0);
    XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th.ed.");
    BibAssertEqualStrings(parser.str, " 2020s", @"consume periods, don't consume the space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_06_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th.ed. 2020s", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th.ed. 2020s", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_07_consume_period_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th. 2020s", 0);
    XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th.", @"consume periods");
    BibAssertEqualStrings(parser.str, " 2020s", @"consume periods, don't consume the space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_08_dont_allow_space_before_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15 th. 2020s", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15 th. 2020s", @"don't allow space before the suffix");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_09_require_period_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th 2020s", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"require trailing periods");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15th 2020s");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_10_require_period_after_suffix {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"require trailing periods");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15th");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_11_require_period_after_multiple_suffixes {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.ed", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"require trailing periods");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15th.ed");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_12_require_space_after_multiple_suffixes {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th.ed.2020s", 0);
    XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"word break required");
    XCTAssertTrue(bib_ordinal_is_empty(&ord));
    BibAssertEqualStrings(ord.number, "");
    BibAssertEqualStrings(ord.suffix, "");
    BibAssertEqualStrings(parser.str, "15th.ed.2020s");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_specification_ordinal_13_stop_reading_suffix_after_first_space {
    bib_ordinal_t ord = {};
    bib_strbuf_t parser = bib_strbuf("15th. ed.", 0);
    XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser), @"don't read anything after the first space");
    BibAssertEqualStrings(ord.number, "15");
    BibAssertEqualStrings(ord.suffix, "th.", @"consume period, exclude everything after a space");
    BibAssertEqualStrings(parser.str, " ed.", @"consume period, don't consume the space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

@end
