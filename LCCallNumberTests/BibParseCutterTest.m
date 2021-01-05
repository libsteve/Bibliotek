//
//  BibParseCutterTest.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseCutterTest : XCTestCase
@end

@implementation BibParseCutterTest

- (void)test_segment_01_valid_with_date {
    bib_cuttseg_t cut;
    memset(&cut, 0, sizeof(cut));
    bib_strbuf_t parser = bib_strbuf("A123 2020", 0);
    XCTAssertTrue(bib_parse_cuttseg(&cut, &parser), @"parse valid cutter number with date");

    XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
    BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
    BibAssertEqualStrings(cut.cutter.mark, "");
    XCTAssertEqual(cut.dateord.kind, bib_dateord_kind_date, @"parse date value");
    BibAssertEqualStrings(cut.dateord.date.year, "2020", @"parse year");
    XCTAssertFalse(bib_date_has_span(&(cut.dateord.date)));
    XCTAssertEqual(cut.dateord.date.separator, '\0');
    BibAssertEqualStrings(cut.dateord.date.span, "");
    BibAssertEqualStrings(cut.dateord.date.mark, "");

    BibAssertEqualStrings(parser.str, "", @"input string should be empty");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1, @"input string contains null terminator");
}

- (void)test_segment_02_valid_without_date {
    bib_cuttseg_t cut;
    memset(&cut, 0, sizeof(cut));
    bib_strbuf_t parser = bib_strbuf("A123", 0);
    XCTAssertTrue(bib_parse_cuttseg(&cut, &parser), @"parse valid cutter number without date");

    XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
    BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
    BibAssertEqualStrings(cut.cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cut.dateord)), @"don't parse date value");

    BibAssertEqualStrings(parser.str, "", @"input string should be empty");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1, @"input string contains null terminator");
}

- (void)test_segment_03_dont_parse_trailing_cutter_as_date {
    bib_cuttseg_t cut;
    memset(&cut, 0, sizeof(cut));
    bib_strbuf_t parser = bib_strbuf("A123 B123", 0);
    XCTAssertTrue(bib_parse_cuttseg(&cut, &parser), @"parse valid cutter number without date");

    XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
    BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
    BibAssertEqualStrings(cut.cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cut.dateord)), @"don't parse date value");

    BibAssertEqualStrings(parser.str, " B123", @"input string should contain a space and the second cutter number");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1, @"input string contains null terminator");
}

- (void)test_segment_04_valid_without_trailing_space {
    bib_cuttseg_t cut = {};
    bib_strbuf_t parser = bib_strbuf("A123B123", 0);
    XCTAssertTrue(bib_parse_cuttseg(&cut, &parser), @"parse valid cutter numner without work mark");

    XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
    BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
    BibAssertEqualStrings(cut.cutter.mark, "", @"don't parse a work mark");
    XCTAssertTrue(bib_dateord_is_empty(&(cut.dateord)));
    BibAssertEqualStrings(parser.str, "B123", @"input string should contain the second cutter number");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1, @"input string contains null terminator");
}

- (void)test_segment_05_valid_without_work_mark {
    bib_cuttseg_t cut = {};
    bib_strbuf_t parser = bib_strbuf("A123B", 0);
    XCTAssertTrue(bib_parse_cuttseg(&cut, &parser), @"parse valid cutter numner without work mark");

    XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
    BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
    BibAssertEqualStrings(cut.cutter.mark, "", @"don't parse a work mark");
    XCTAssertTrue(bib_dateord_is_empty(&(cut.dateord)));
    BibAssertEqualStrings(parser.str, "B", @"input string should contain the second cutter number");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1, @"input string contains null terminator");

    bib_cuttseg_t c2 = {};
    bib_strbuf_t p2 = parser;
    XCTAssertTrue(bib_parse_cuttseg(&c2, &p2), @"parse valid cutter number");
    XCTAssertEqual(c2.cutter.letter, 'B', @"parse cutter letter");
    BibAssertEqualStrings(c2.cutter.number, "", @"empty cutter number");
    BibAssertEqualStrings(c2.cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(c2.dateord)));
    BibAssertEqualStrings(p2.str, "", @"input string should be empty");
    XCTAssertEqual(p2.len, strlen(p2.str) + 1, @"input string contains null terminator");
}

#pragma mark -

- (void)test_list_01_valid_with_date {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf(".A123 2020 B123", 0);
    XCTAssertTrue(bib_parse_cuttseg_list(cutters, &parser), @"parse valid cutter section");

    BibAssertEqualStrings(cutters[0].cutter.string, "A123");
    BibAssertEqualStrings(cutters[0].cutter.mark, "");
    BibAssertEqualStrings(cutters[0].dateord.date.year, "2020");
    XCTAssertFalse(bib_date_has_span(&(cutters[0].dateord.date)));

    BibAssertEqualStrings(cutters[1].cutter.string, "B123");
    BibAssertEqualStrings(cutters[1].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));

    XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[2])));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_list_02_require_initial_period {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf("A123 2020 B123", 0);
    XCTAssertFalse(bib_parse_cuttseg_list(cutters, &parser), @"cutter section must begin with a period");
    XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[0])));
    XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[1])));
    XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[2])));
    BibAssertEqualStrings(parser.str, "A123 2020 B123");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_list_03_valid_double_cutter_with_spaces {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf(".E59 A21", 0);
    XCTAssertTrue(bib_parse_cuttseg_list(cutters, &parser), @"parse valid cutter section");
    BibAssertEqualStrings(cutters[0].cutter.string, "E59");
    BibAssertEqualStrings(cutters[0].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[0].dateord)));
    BibAssertEqualStrings(cutters[1].cutter.string, "A21");
    BibAssertEqualStrings(cutters[1].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));
    BibAssertEqualStrings(cutters[2].cutter.string, "");
    BibAssertEqualStrings(cutters[2].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[2].dateord)));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_list_04_valid_double_cutter_without_spaces {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf(".E59A21", 0);
    XCTAssertTrue(bib_parse_cuttseg_list(cutters, &parser), @"parse valid cutter section");
    BibAssertEqualStrings(cutters[0].cutter.string, "E59");
    BibAssertEqualStrings(cutters[0].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[0].dateord)));
    BibAssertEqualStrings(cutters[1].cutter.string, "A21");
    BibAssertEqualStrings(cutters[1].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));
    BibAssertEqualStrings(cutters[2].cutter.string, "");
    BibAssertEqualStrings(cutters[2].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[2].dateord)));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_list_05_LENIENT_allow_periods_for_successive_cutters {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf(".E59.A21", 0);
    XCTAssertTrue(bib_parse_cuttseg_list(cutters, &parser), @"parse valid cutter section");
    BibAssertEqualStrings(cutters[0].cutter.string, "E59");
    BibAssertEqualStrings(cutters[0].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[0].dateord)));
    BibAssertEqualStrings(cutters[1].cutter.string, "A21");
    BibAssertEqualStrings(cutters[1].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));
    BibAssertEqualStrings(cutters[2].cutter.string, "");
    BibAssertEqualStrings(cutters[2].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[2].dateord)));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_list_06_LENIENT_allow_periods_for_successive_cutters {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf(".E59 .A21", 0);
    XCTAssertTrue(bib_parse_cuttseg_list(cutters, &parser), @"parse valid cutter section");
    BibAssertEqualStrings(cutters[0].cutter.string, "E59");
    BibAssertEqualStrings(cutters[0].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[0].dateord)));
    BibAssertEqualStrings(cutters[1].cutter.string, "A21");
    BibAssertEqualStrings(cutters[1].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));
    BibAssertEqualStrings(cutters[2].cutter.string, "");
    BibAssertEqualStrings(cutters[2].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[2].dateord)));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

/// We're defining a "naked" cutter as a single letter without numerals
- (void)test_list_07_LENIENT_allow_trailing_naked_cutter {
    bib_cuttseg_t cutters[3] = {};
    bib_strbuf_t parser = bib_strbuf(".E59.A21.Z", 0);
    XCTAssertTrue(bib_parse_cuttseg_list(cutters, &parser), @"parse valid cutter section");
    BibAssertEqualStrings(cutters[0].cutter.string, "E59");
    BibAssertEqualStrings(cutters[0].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[0].dateord)));
    BibAssertEqualStrings(cutters[1].cutter.string, "A21");
    BibAssertEqualStrings(cutters[1].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));
    BibAssertEqualStrings(cutters[2].cutter.string, "Z");
    BibAssertEqualStrings(cutters[2].cutter.mark, "");
    XCTAssertTrue(bib_dateord_is_empty(&(cutters[2].dateord)));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

@end
