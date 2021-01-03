//
//  BibParseTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 10/1/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "bibparse.h"
#import "bibtype.h"

#define BibAssertEqualStrings(expression1, expression2, ...) \
    _XCTPrimitiveAssertEqualObjects(self, @(expression1), @#expression1, @(expression2), @#expression2, __VA_ARGS__)

@interface BibParseTests : XCTestCase

@end

@implementation BibParseTests

- (void)test_parse_lc_subject {
    {
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
    {
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
    {
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
    {
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
    {
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
    {
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
}

- (void)test_parse_lc_subject_base {
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("QA", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("QA76", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("QA76.76", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "76");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("DR1879.5", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "DR");
        BibAssertEqualStrings(cap.integer, "1879");
        BibAssertEqualStrings(cap.decimal, "5");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_strbuf_t parser = bib_strbuf("QA ", 0);
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, " ", @"don't consume trailing space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("QA 76", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("QA 76.76", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "76");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf(" ", 0);
        XCTAssertFalse(bib_parse_lc_subject_base(&cap, &parser), @"don't consume leading space");
        BibAssertEqualStrings(cap.letters, "");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, " ");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf(" QA76.76", 0);
        XCTAssertFalse(bib_parse_lc_subject_base(&cap, &parser), @"don't consume leading space");
        BibAssertEqualStrings(cap.letters, "");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, " QA76.76");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("76.76", 0);
        XCTAssertFalse(bib_parse_lc_subject_base(&cap, &parser), @"require class letters");
        BibAssertEqualStrings(cap.letters, "");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(parser.str, "76.76");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_calln_t cap = {};
        bib_strbuf_t parser = bib_strbuf("QA 76 .76", 0);
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &parser), @"allow partial match");
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "", @"don't parse decimal with leading spacee");
        BibAssertEqualStrings(parser.str, " .76", @"leave decimal with leading space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
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
}

- (void)test_parse_lc_cutter_ordinal {
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th C21", 0);
        XCTAssertTrue(bib_parse_cutter_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, " C21", @"don't consume the space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th C21", 0);
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th C21", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th. C21", 0);
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15th. C21", @"don't consume the period");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.C21", 0);
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15th.C21", @"don't consume the period");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th", 0);
        XCTAssertTrue(bib_parse_cutter_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th", 0);
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15thC21", 0);
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &parser), @"word break required");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15thC21");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
}

- (void)test_parse_lc_caption_ordinal {
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.C21", 0);
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, ".C21", @"don't consume the period");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th.C21", 0);
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th.C21", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th. C21", 0);
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, ". C21", @"don't consume the period");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th. C21", 0);
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th. C21", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th C21", 0);
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, " C21", @"don't consume the space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th C21", 0);
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th C21", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th .C21", 0);
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, " .C21", @"don't consume the space and period");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th .C21", 0);
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th .C21", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th", 0);
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th", 0);
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15thC21", 0);
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &parser), @"word break required");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15thC21");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
}

- (void)test_parse_specification_ordinal {
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.", 0);
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.", @"consume periods");
        BibAssertEqualStrings(parser.str, "", @"consume periods");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th.", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th.", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.ed.", 0);
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.ed.", @"consume periods");
        BibAssertEqualStrings(parser.str, "", @"consume periods");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th.ed.", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th.ed.", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.ed. 2020s", 0);
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.ed.");
        BibAssertEqualStrings(parser.str, " 2020s", @"consume periods, don't consume the space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th.ed. 2020s", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th.ed. 2020s", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th. 2020s", 0);
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.", @"consume periods");
        BibAssertEqualStrings(parser.str, " 2020s", @"consume periods, don't consume the space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15 th. 2020s", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15 th. 2020s", @"don't allow space before the suffix");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th 2020s", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"require trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15th 2020s");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"require trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15th");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.ed", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"require trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15th.ed");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th.ed.2020s", 0);
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &parser), @"word break required");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(parser.str, "15th.ed.2020s");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_ordinal_t ord = {};
        bib_strbuf_t parser = bib_strbuf("15th. ed.", 0);
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &parser), @"don't read anything after the first space");
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.", @"consume period, exclude everything after a space");
        BibAssertEqualStrings(parser.str, " ed.", @"consume period, don't consume the space");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
}

- (void)test_parse_date {
    {
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
    {
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
    {
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
    {
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
    {
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
    {
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
    {
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
    {
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
    {
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
    {
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
}

- (void)test_parse_lc_cuttseg_list {
    {
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
    {
        bib_cuttseg_t cutters[3] = {};
        bib_strbuf_t parser = bib_strbuf("A123 2020 B123", 0);
        XCTAssertFalse(bib_parse_cuttseg_list(cutters, &parser), @"cutter section must begin with a period");
        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[0])));
        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[1])));
        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[2])));
        BibAssertEqualStrings(parser.str, "A123 2020 B123");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
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
    {
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
    {
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
    {
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
    {
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
}

- (void)test_parse_lc_cuttseg {
    {
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
    {
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
    {
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
    {
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
    {
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
}

- (void)test_parse_volume {
    {
        bib_volume_t vol = {};
        bib_strbuf_t parser = bib_strbuf("vol. 10", 0);
        XCTAssertTrue(bib_parse_volume(&vol, &parser));
        BibAssertEqualStrings(vol.prefix, "vol", @"don't save periods");
        BibAssertEqualStrings(vol.number, "10");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_volume_t vol = {};
        bib_strbuf_t parser = bib_strbuf("vol.10", 0);
        XCTAssertFalse(bib_parse_volume(&vol, &parser), @"require space before numeral");
        XCTAssertTrue(bib_volume_is_empty(&vol));
        BibAssertEqualStrings(vol.prefix, "");
        BibAssertEqualStrings(vol.number, "");
        BibAssertEqualStrings(parser.str, "vol.10");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_volume_t vol = {};
        bib_strbuf_t parser = bib_strbuf("vol 10", 0);
        XCTAssertFalse(bib_parse_volume(&vol, &parser), @"require period after prefix");
        XCTAssertTrue(bib_volume_is_empty(&vol));
        BibAssertEqualStrings(vol.prefix, "");
        BibAssertEqualStrings(vol.number, "");
        BibAssertEqualStrings(parser.str, "vol 10");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_volume_t vol = {};
        bib_strbuf_t parser = bib_strbuf("vol10", 0);
        XCTAssertFalse(bib_parse_volume(&vol, &parser), @"require period after prefix");
        XCTAssertTrue(bib_volume_is_empty(&vol));
        BibAssertEqualStrings(vol.prefix, "");
        BibAssertEqualStrings(vol.number, "");
        BibAssertEqualStrings(parser.str, "vol10");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
}

- (void)test_parse_lc_specification {
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("1999s", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_date);
        BibAssertEqualStrings(spc.date.year, "1999");
        BibAssertEqualStrings(spc.date.mark, "s");
        BibAssertEqualStrings(spc.date.span, "");
        XCTAssertEqual(spc.date.separator, '\0');
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("2010/11s", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_date);
        BibAssertEqualStrings(spc.date.year, "2010");
        BibAssertEqualStrings(spc.date.span, "11");
        BibAssertEqualStrings(spc.date.mark, "s");
        XCTAssertEqual(spc.date.separator, '/');
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("15th.ed.", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_ordinal);
        BibAssertEqualStrings(spc.ordinal.number, "15");
        BibAssertEqualStrings(spc.ordinal.suffix, "th.ed.");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("2015th.", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_ordinal, @"parse an ordinal, not a date");
        BibAssertEqualStrings(spc.ordinal.number, "2015");
        BibAssertEqualStrings(spc.ordinal.suffix, "th.");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("Suppl. 15", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_volume);
        BibAssertEqualStrings(spc.volume.prefix, "Suppl");
        BibAssertEqualStrings(spc.volume.number, "15");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("n.s.", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_word);
        BibAssertEqualStrings(spc.word, "n.s.");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
    {
        bib_lc_specification_t spc = {};
        bib_strbuf_t parser = bib_strbuf("K.252", 0);
        XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_word);
        BibAssertEqualStrings(spc.word, "K.252");
        BibAssertEqualStrings(parser.str, "");
        XCTAssertEqual(parser.len, strlen(parser.str) + 1);
    }
}

@end
