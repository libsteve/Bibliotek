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
        char const *str = "QA";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        XCTAssertTrue(bib_dateord_is_empty(&cap.dateord));
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "KF4558 15th";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "KF");
        BibAssertEqualStrings(cap.integer, "4558");
        BibAssertEqualStrings(cap.decimal, "");
        XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_ordinal);
        BibAssertEqualStrings(cap.dateord.ordinal.number, "15");
        BibAssertEqualStrings(cap.dateord.ordinal.suffix, "th");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "DR1879.5 1988";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "DR");
        BibAssertEqualStrings(cap.integer, "1879");
        BibAssertEqualStrings(cap.decimal, "5");
        XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_date);
        BibAssertEqualStrings(cap.dateord.date.year, "1988");
        XCTAssertFalse(bib_date_has_span(&(cap.dateord.date)));
        XCTAssertEqual(cap.dateord.date.separator, '\0');
        BibAssertEqualStrings(cap.dateord.date.span, "");
        BibAssertEqualStrings(cap.dateord.date.mark, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA76.76 1988 15th";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject(&cap, &str, &len), @"allow partial match");
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "76");
        BibAssertEqualStrings(cap.dateord.date.year, "1988");
        XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_date);
        XCTAssertNotEqual(cap.dateord.kind, bib_dateord_kind_ordinal);
        BibAssertEqualStrings(str, " 15th", @"shouldn't parse an ordinal after parsing a year");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA 76 .76 1988";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject(&cap, &str, &len), @"allow partial match");
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "", @"don't parse decimals with leading space");
        XCTAssertTrue(bib_dateord_is_empty(&cap.dateord));
        BibAssertEqualStrings(str, " .76 1988", @"leave decimal with leading space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "KF4558 1988p";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject(&cap, &str, &len), @"allow partial match");
        BibAssertEqualStrings(cap.letters, "KF");
        BibAssertEqualStrings(cap.integer, "4558");
        BibAssertEqualStrings(cap.decimal, "");
        XCTAssertEqual(cap.dateord.kind, bib_dateord_kind_date);
        BibAssertEqualStrings(cap.dateord.date.year, "1988");
        XCTAssertEqual(cap.dateord.date.separator, '\0');
        BibAssertEqualStrings(cap.dateord.date.span, "");
        BibAssertEqualStrings(cap.dateord.date.mark, "p");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_lc_subject_base {
    {
        char const *str = "QA";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA76.76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "76");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "DR1879.5";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "DR");
        BibAssertEqualStrings(cap.integer, "1879");
        BibAssertEqualStrings(cap.decimal, "5");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA ";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, " ", @"don't consume trailing space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA 76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA 76.76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len));
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "76");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = " ";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertFalse(bib_parse_lc_subject_base(&cap, &str, &len), @"don't consume leading space");
        BibAssertEqualStrings(cap.letters, "");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, " ");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = " QA76.76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertFalse(bib_parse_lc_subject_base(&cap, &str, &len), @"don't consume leading space");
        BibAssertEqualStrings(cap.letters, "");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, " QA76.76");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "76.76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertFalse(bib_parse_lc_subject_base(&cap, &str, &len), @"require class letters");
        BibAssertEqualStrings(cap.letters, "");
        BibAssertEqualStrings(cap.integer, "");
        BibAssertEqualStrings(cap.decimal, "");
        BibAssertEqualStrings(str, "76.76");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "QA 76 .76";
        size_t len = strlen(str) + 1;
        bib_lc_calln_t cap = {};
        XCTAssertTrue(bib_parse_lc_subject_base(&cap, &str, &len), @"allow partial match");
        BibAssertEqualStrings(cap.letters, "QA");
        BibAssertEqualStrings(cap.integer, "76");
        BibAssertEqualStrings(cap.decimal, "", @"don't parse decimal with leading spacee");
        BibAssertEqualStrings(str, " .76", @"leave decimal with leading space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_lc_cutter_ordinal {
    {
        char const *str = "15th C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_cutter_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, " C21", @"don't consume the space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th C21", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th. C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &str, &len), @"don't allow trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15th. C21", @"don't consume the period");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th.C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &str, &len), @"don't allow trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15th.C21", @"don't consume the period");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_cutter_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15thC21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_cutter_ordinal(&ord, &str, &len), @"word break required");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15thC21");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_lc_caption_ordinal {
    {
        char const *str = "15th.C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, ".C21", @"don't consume the period");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th.C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th.C21", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th. C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, ". C21", @"don't consume the period");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th. C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th. C21", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, " C21", @"don't consume the space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th C21", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th .C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, " .C21", @"don't consume the space and period");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th .C21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th .C21", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_caption_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15thC21";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_caption_ordinal(&ord, &str, &len), @"word break required");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15thC21");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_specification_ordinal {
    {
        char const *str = "15th.";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.", @"consume periods");
        BibAssertEqualStrings(str, "", @"consume periods");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th.";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th.", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th.ed.";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.ed.", @"consume periods");
        BibAssertEqualStrings(str, "", @"consume periods");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th.ed.";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th.ed.", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th.ed. 2020s";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.ed.");
        BibAssertEqualStrings(str, " 2020s", @"consume periods, don't consume the space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th.ed. 2020s";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th.ed. 2020s", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th. 2020s";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &str, &len));
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.", @"consume periods");
        BibAssertEqualStrings(str, " 2020s", @"consume periods, don't consume the space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15 th. 2020s";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"don't allow space before the suffix");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15 th. 2020s", @"don't allow space before the suffix");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th 2020s";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"require trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15th 2020s");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"require trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15th");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th.ed";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"require trailing periods");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15th.ed");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th.ed.2020s";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertFalse(bib_parse_specification_ordinal(&ord, &str, &len), @"word break required");
        XCTAssertTrue(bib_ordinal_is_empty(&ord));
        BibAssertEqualStrings(ord.number, "");
        BibAssertEqualStrings(ord.suffix, "");
        BibAssertEqualStrings(str, "15th.ed.2020s");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th. ed.";
        size_t len = strlen(str) + 1;
        bib_ordinal_t ord = {};
        XCTAssertTrue(bib_parse_specification_ordinal(&ord, &str, &len), @"don't read anything after the first space");
        BibAssertEqualStrings(ord.number, "15");
        BibAssertEqualStrings(ord.suffix, "th.", @"consume period, exclude everything after a space");
        BibAssertEqualStrings(str, " ed.", @"consume period, don't consume the space");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_date {
    {
        char const *str = "1989";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertFalse(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '\0');
        BibAssertEqualStrings(date.span, "");
        BibAssertEqualStrings(date.mark, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989/90";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertTrue(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '/');
        BibAssertEqualStrings(date.span, "90");
        BibAssertEqualStrings(date.mark, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989-99";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertTrue(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '-');
        BibAssertEqualStrings(date.span, "99");
        BibAssertEqualStrings(date.mark, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989-1999";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertTrue(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '-');
        BibAssertEqualStrings(date.span, "1999");
        BibAssertEqualStrings(date.mark, "");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989s";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertFalse(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '\0');
        BibAssertEqualStrings(date.span, "");
        BibAssertEqualStrings(date.mark, "s");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989/90s";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertTrue(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '/');
        BibAssertEqualStrings(date.span, "90");
        BibAssertEqualStrings(date.mark, "s");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989-1999s";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertTrue(bib_date_has_span(&date));
        XCTAssertEqual(date.separator, '-');
        BibAssertEqualStrings(date.span, "1999");
        BibAssertEqualStrings(date.mark, "s");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "89/99";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertFalse(bib_parse_date(&date, &str, &len), "year must be 4 digits long");
        XCTAssertTrue(bib_date_is_empty(&date));
        XCTAssertFalse(bib_date_has_span(&date));
        BibAssertEqualStrings(date.year, "");
        XCTAssertEqual(date.separator, '\0');
        BibAssertEqualStrings(date.span, "");
        BibAssertEqualStrings(date.mark, "");
        BibAssertEqualStrings(str, "89/99");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989/999";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertTrue(bib_date_has_span(&date));
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertEqual(date.separator, '/');
        BibAssertEqualStrings(date.span, "99", @"span must be 2 or 4 digits long");
        BibAssertEqualStrings(date.mark, "");
        BibAssertEqualStrings(str, "9");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "1989s-1999s";
        size_t len = strlen(str) + 1;
        bib_date_t date = {};
        XCTAssertTrue(bib_parse_date(&date, &str, &len));
        XCTAssertFalse(bib_date_is_empty(&date));
        XCTAssertFalse(bib_date_has_span(&date), @"date ranges cannot have marks on the initial year");
        BibAssertEqualStrings(date.year, "1989");
        XCTAssertEqual(date.separator, '\0');
        BibAssertEqualStrings(date.span, "");
        BibAssertEqualStrings(date.mark, "", @"shouldn't read mark");
        BibAssertEqualStrings(str, "s-1999s");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_lc_cuttseg_list {
    {
        char const *str = ".A123 2020 B123";
        size_t len = strlen(str) + 1;
        bib_cuttseg_t cutters[3] = {};
        XCTAssertTrue(bib_parse_cuttseg_list(cutters, &str, &len), @"parse valid cutter section");

        BibAssertEqualStrings(cutters[0].cutter.string, "A123");
        BibAssertEqualStrings(cutters[0].cutter.mark, "");
        BibAssertEqualStrings(cutters[0].dateord.date.year, "2020");
        XCTAssertFalse(bib_date_has_span(&(cutters[0].dateord.date)));

        BibAssertEqualStrings(cutters[1].cutter.string, "B123");
        BibAssertEqualStrings(cutters[1].cutter.mark, "");
        XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));

        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[2])));
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "A123 2020 B123";
        size_t len = strlen(str) + 1;
        bib_cuttseg_t cutters[3] = {};
        XCTAssertFalse(bib_parse_cuttseg_list(cutters, &str, &len), @"cutter section must begin with a period");
        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[0])));
        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[1])));
        XCTAssertTrue(bib_cuttseg_is_empty(&(cutters[2])));
        BibAssertEqualStrings(str, "A123 2020 B123");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = ".E59 A21";
        size_t len = strlen(str) + 1;
        bib_cuttseg_t cutters[3] = {};
        XCTAssertTrue(bib_parse_cuttseg_list(cutters, &str, &len), @"parse valid cutter section");
        BibAssertEqualStrings(cutters[0].cutter.string, "E59");
        BibAssertEqualStrings(cutters[0].cutter.mark, "");
        XCTAssertTrue(bib_dateord_is_empty(&(cutters[0].dateord)));
        BibAssertEqualStrings(cutters[1].cutter.string, "A21");
        BibAssertEqualStrings(cutters[1].cutter.mark, "");
        XCTAssertTrue(bib_dateord_is_empty(&(cutters[1].dateord)));
        BibAssertEqualStrings(cutters[2].cutter.string, "");
        BibAssertEqualStrings(cutters[2].cutter.mark, "");
        XCTAssertTrue(bib_dateord_is_empty(&(cutters[2].dateord)));
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_lc_cuttseg {
    {
        char const *str = "A123 2020";
        size_t len = strlen(str) + 1;
        bib_cuttseg_t cut;
        memset(&cut, 0, sizeof(cut));
        XCTAssertTrue(bib_parse_cuttseg(&cut, &str, &len), @"parse valid cutter number with date");

        XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
        BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
        BibAssertEqualStrings(cut.cutter.mark, "");
        XCTAssertEqual(cut.dateord.kind, bib_dateord_kind_date, @"parse date value");
        BibAssertEqualStrings(cut.dateord.date.year, "2020", @"parse year");
        XCTAssertFalse(bib_date_has_span(&(cut.dateord.date)));
        XCTAssertEqual(cut.dateord.date.separator, '\0');
        BibAssertEqualStrings(cut.dateord.date.span, "");
        BibAssertEqualStrings(cut.dateord.date.mark, "");

        BibAssertEqualStrings(str, "", @"input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"input string contains null terminator");
    }
    {
        char const *str = "A123";
        size_t len = strlen(str) + 1;
        bib_cuttseg_t cut;
        memset(&cut, 0, sizeof(cut));
        XCTAssertTrue(bib_parse_cuttseg(&cut, &str, &len), @"parse valid cutter number without date");

        XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
        BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
        BibAssertEqualStrings(cut.cutter.mark, "");
        XCTAssertTrue(bib_dateord_is_empty(&(cut.dateord)), @"don't parse date value");

        BibAssertEqualStrings(str, "", @"input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"input string contains null terminator");
    }
    {
        char const *str = "A123 B123";
        size_t len = strlen(str) + 1;
        bib_cuttseg_t cut;
        memset(&cut, 0, sizeof(cut));
        XCTAssertTrue(bib_parse_cuttseg(&cut, &str, &len), @"parse valid cutter number without date");

        XCTAssertEqual(cut.cutter.letter, 'A', @"parse cutter initial");
        BibAssertEqualStrings(cut.cutter.number, "123", @"parse cutter number");
        BibAssertEqualStrings(cut.cutter.mark, "");
        XCTAssertTrue(bib_dateord_is_empty(&(cut.dateord)), @"don't parse date value");

        BibAssertEqualStrings(str, " B123", @"input string should contain a space and the second cutter number");
        XCTAssertEqual(len, strlen(str) + 1, @"input string contains null terminator");
    }
}

- (void)test_parse_volume {
    {
        char const *str = "vol. 10";
        size_t len = strlen(str) + 1;
        bib_volume_t vol = {};
        XCTAssertTrue(bib_parse_volume(&vol, &str, &len));
        BibAssertEqualStrings(vol.prefix, "vol", @"don't save periods");
        BibAssertEqualStrings(vol.number, "10");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "vol.10";
        size_t len = strlen(str) + 1;
        bib_volume_t vol = {};
        XCTAssertTrue(bib_parse_volume(&vol, &str, &len), @"optional space before numeral");
        BibAssertEqualStrings(vol.prefix, "vol", @"don't save periods");
        BibAssertEqualStrings(vol.number, "10");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "vol 10";
        size_t len = strlen(str) + 1;
        bib_volume_t vol = {};
        XCTAssertFalse(bib_parse_volume(&vol, &str, &len), @"require period after prefix");
        XCTAssertTrue(bib_volume_is_empty(&vol));
        BibAssertEqualStrings(vol.prefix, "");
        BibAssertEqualStrings(vol.number, "");
        BibAssertEqualStrings(str, "vol 10");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "vol10";
        size_t len = strlen(str) + 1;
        bib_volume_t vol = {};
        XCTAssertFalse(bib_parse_volume(&vol, &str, &len), @"require period after prefix");
        XCTAssertTrue(bib_volume_is_empty(&vol));
        BibAssertEqualStrings(vol.prefix, "");
        BibAssertEqualStrings(vol.number, "");
        BibAssertEqualStrings(str, "vol10");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

- (void)test_parse_lc_specification {
    {
        char const *str = "1999s";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_date);
        BibAssertEqualStrings(spc.date.year, "1999");
        BibAssertEqualStrings(spc.date.mark, "s");
        BibAssertEqualStrings(spc.date.span, "");
        XCTAssertEqual(spc.date.separator, '\0');
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "2010/11s";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_date);
        BibAssertEqualStrings(spc.date.year, "2010");
        BibAssertEqualStrings(spc.date.span, "11");
        BibAssertEqualStrings(spc.date.mark, "s");
        XCTAssertEqual(spc.date.separator, '/');
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "15th.ed.";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_ordinal);
        BibAssertEqualStrings(spc.ordinal.number, "15");
        BibAssertEqualStrings(spc.ordinal.suffix, "th.ed.");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "2015th.";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_ordinal, @"parse an ordinal, not a date");
        BibAssertEqualStrings(spc.ordinal.number, "2015");
        BibAssertEqualStrings(spc.ordinal.suffix, "th.");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "Suppl. 15";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_volume);
        BibAssertEqualStrings(spc.volume.prefix, "Suppl");
        BibAssertEqualStrings(spc.volume.number, "15");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "vol.15";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_volume);
        BibAssertEqualStrings(spc.volume.prefix, "vol");
        BibAssertEqualStrings(spc.volume.number, "15");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
    {
        char const *str = "n.s.";
        size_t len = strlen(str) + 1;
        bib_lc_specification_t spc = {};
        XCTAssertTrue(bib_parse_lc_specification(&spc, &str, &len));
        XCTAssertEqual(spc.kind, bib_lc_specification_kind_word);
        BibAssertEqualStrings(spc.word, "n.s.");
        BibAssertEqualStrings(str, "");
        XCTAssertEqual(len, strlen(str) + 1);
    }
}

@end
