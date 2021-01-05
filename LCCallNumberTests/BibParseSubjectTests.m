//
//  BibParseSubjectTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseSubjectTests : XCTestCase
@end

@implementation BibParseSubjectTests

- (void)test_01 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA", 0);
    XCTAssertTrue(bib_parse_lc_subject(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "");
    BibAssertEqualStrings(cap.decimal, "");
    XCTAssertTrue(bib_dateord_is_empty(&cap.dateord));
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_02 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("KF4558 15th", 0);
    XCTAssertTrue(bib_parse_lc_subject(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "KF");
    BibAssertEqualStrings(cap.integer, "4558");
    BibAssertEqualStrings(cap.decimal, "");
    XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_ordinal);
    BibAssertEqualStrings(cap.dateord.ordinal.number, "15");
    BibAssertEqualStrings(cap.dateord.ordinal.suffix, "th");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_03 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("DR1879.5 1988", 0);
    XCTAssertTrue(bib_parse_lc_subject(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "DR");
    BibAssertEqualStrings(cap.integer, "1879");
    BibAssertEqualStrings(cap.decimal, "5");
    XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_date);
    BibAssertEqualStrings(cap.dateord.date.year, "1988");
    XCTAssertFalse(bib_date_has_span(&(cap.dateord.date)));
    XCTAssertEqual(cap.dateord.date.separator, '\0');
    BibAssertEqualStrings(cap.dateord.date.span, "");
    BibAssertEqualStrings(cap.dateord.date.mark, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_04 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA76.76 1988 15th", 0);
    XCTAssertTrue(bib_parse_lc_subject(&cap, &parser), @"allow partial match");
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "76");
    BibAssertEqualStrings(cap.dateord.date.year, "1988");
    XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_date);
    XCTAssertNotEqual(cap.dateord.kind, bib_dateord_kind_ordinal);
    BibAssertEqualStrings(parser.str, " 15th", @"shouldn't parse an ordinal after parsing a year");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_05 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA 76 .76 1988", 0);
    XCTAssertTrue(bib_parse_lc_subject(&cap, &parser), @"allow partial match");
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "", @"don't parse decimals with leading space");
    XCTAssertTrue(bib_dateord_is_empty(&cap.dateord));
    BibAssertEqualStrings(parser.str, " .76 1988", @"leave decimal with leading space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_06 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("KF4558 1988p", 0);
    XCTAssertTrue(bib_parse_lc_subject(&cap, &parser), @"allow partial match");
    BibAssertEqualStrings(cap.letters, "KF");
    BibAssertEqualStrings(cap.integer, "4558");
    BibAssertEqualStrings(cap.decimal, "");
    XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_date);
    BibAssertEqualStrings(cap.dateord.date.year, "1988");
    XCTAssertEqual(cap.dateord.date.separator, '\0');
    BibAssertEqualStrings(cap.dateord.date.span, "");
    BibAssertEqualStrings(cap.dateord.date.mark, "p");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_07 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_08 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA76", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_09 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA76.76", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "76");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_10 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("DR1879.5", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "DR");
    BibAssertEqualStrings(cap.integer, "1879");
    BibAssertEqualStrings(cap.decimal, "5");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_11 {
    bib_strbuf_t parser = bib_strbuf("QA ", 0);
    bib_lc_calln_t cap = {};
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, " ", @"don't consume trailing space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_12 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA 76", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_13 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA 76.76", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "76");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_14 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf(" ", 0);
    XCTAssertFalse(bib_parse_lc_subject_base(&cap, &parser), @"don't consume leading space");
    BibAssertEqualStrings(cap.letters, "");
    BibAssertEqualStrings(cap.integer, "");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, " ");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_15 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf(" QA76.76", 0);
    XCTAssertFalse(bib_parse_lc_subject_base(&cap, &parser), @"don't consume leading space");
    BibAssertEqualStrings(cap.letters, "");
    BibAssertEqualStrings(cap.integer, "");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, " QA76.76");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_16 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("76.76", 0);
    XCTAssertFalse(bib_parse_lc_subject_base(&cap, &parser), @"require class letters");
    BibAssertEqualStrings(cap.letters, "");
    BibAssertEqualStrings(cap.integer, "");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, "76.76");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_17 {
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = bib_strbuf("QA 76 .76", 0);
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser), @"allow partial match");
    BibAssertEqualStrings(cap.letters, "QA");
    BibAssertEqualStrings(cap.integer, "76");
    BibAssertEqualStrings(cap.decimal, "", @"don't parse decimal with leading spacee");
    BibAssertEqualStrings(parser.str, " .76", @"leave decimal with leading space");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_18 {
    char const *str = "KB11655";
    bib_lc_calln_t cap = {};
    bib_strbuf_t parser = { .str = str, .len = strlen(str) + 1 };
    XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser), @"allow partial match");
    BibAssertEqualStrings(cap.letters, "KB");
    BibAssertEqualStrings(cap.integer, "11655");
    BibAssertEqualStrings(cap.decimal, "");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

@end
