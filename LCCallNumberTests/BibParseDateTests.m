//
//  BibParseDateTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseDateTests : XCTestCase

@end

@implementation BibParseDateTests

- (void)test_01_four_digit_year {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertFalse(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '\0');
    BibAssertEqualStrings(date.span, "");
    BibAssertEqualStrings(date.mark, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_02_four_digit_year_slash_two_digit_span {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989/90", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertTrue(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '/');
    BibAssertEqualStrings(date.span, "90");
    BibAssertEqualStrings(date.mark, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_03_four_digit_year_dash_two_digit_span {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989-99", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertTrue(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '-');
    BibAssertEqualStrings(date.span, "99");
    BibAssertEqualStrings(date.mark, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_04_four_digit_year_dash_four_digit_span {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989-1999", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertTrue(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '-');
    BibAssertEqualStrings(date.span, "1999");
    BibAssertEqualStrings(date.mark, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_05_four_digit_year_with_work_mark {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989s", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertFalse(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '\0');
    BibAssertEqualStrings(date.span, "");
    BibAssertEqualStrings(date.mark, "s");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_06_four_digit_year_slash_two_digit_span_with_work_mark {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989/90s", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertTrue(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '/');
    BibAssertEqualStrings(date.span, "90");
    BibAssertEqualStrings(date.mark, "s");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_07_four_digit_year_dash_two_digit_span_with_work_mark {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989-1999s", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertTrue(bib_date_has_span(&date));
    XCTAssertEqual(date.separator, '-');
    BibAssertEqualStrings(date.span, "1999");
    BibAssertEqualStrings(date.mark, "s");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_08_require_four_digit_year {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("89/99", 0);
    XCTAssertFalse(bib_parse_date(&date, &parser), "year must be 4 digits long");
    XCTAssertTrue(bib_date_is_empty(&date));
    XCTAssertFalse(bib_date_has_span(&date));
    BibAssertEqualStrings(date.year, "");
    XCTAssertEqual(date.separator, '\0');
    BibAssertEqualStrings(date.span, "");
    BibAssertEqualStrings(date.mark, "");
    BibAssertEqualStrings(parser.str, "89/99");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_09_require_two_or_four_digit_span {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989/999", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertTrue(bib_date_has_span(&date));
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertEqual(date.separator, '/');
    BibAssertEqualStrings(date.span, "99", @"span must be 2 or 4 digits long");
    BibAssertEqualStrings(date.mark, "");
    BibAssertEqualStrings(parser.str, "9");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_10_dont_allow_work_marks_on_beginning_of_span {
    bib_date_t date = {};
    bib_strbuf_t parser = bib_strbuf("1989s-1999s", 0);
    XCTAssertTrue(bib_parse_date(&date, &parser));
    XCTAssertFalse(bib_date_is_empty(&date));
    XCTAssertFalse(bib_date_has_span(&date), @"date ranges cannot have marks on the initial year");
    BibAssertEqualStrings(date.year, "1989");
    XCTAssertEqual(date.separator, '\0');
    BibAssertEqualStrings(date.span, "");
    BibAssertEqualStrings(date.mark, "", @"shouldn't read mark");
    BibAssertEqualStrings(parser.str, "s-1999s");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

@end
