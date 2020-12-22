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

//- (void)test_parse_lc_caption {
//    {
//        char const *str = "QA";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(cap.date, "");
//        BibAssertEqualStrings(cap.ordinal.number, "");
//        BibAssertEqualStrings(cap.ordinal.suffix, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "KF4558 15th";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "KF");
//        BibAssertEqualStrings(cap.integer, "4558");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(cap.date, "");
//        BibAssertEqualStrings(cap.ordinal.number, "15");
//        BibAssertEqualStrings(cap.ordinal.suffix, "th");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "DR1879.5 1988";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "DR");
//        BibAssertEqualStrings(cap.integer, "1879");
//        BibAssertEqualStrings(cap.decimal, "5");
//        BibAssertEqualStrings(cap.date, "1988");
//        BibAssertEqualStrings(cap.ordinal.number, "");
//        BibAssertEqualStrings(cap.ordinal.suffix, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA76.76 1988 15p";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "76");
//        BibAssertEqualStrings(cap.date, "1988");
//        BibAssertEqualStrings(cap.ordinal.number, "15");
//        BibAssertEqualStrings(cap.ordinal.suffix, "p");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA 76.76 1988 15 p";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "76");
//        BibAssertEqualStrings(cap.date, "1988");
//        BibAssertEqualStrings(cap.ordinal.number, "15");
//        BibAssertEqualStrings(cap.ordinal.suffix, "p");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "KF4558 7088p";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "KF");
//        BibAssertEqualStrings(cap.integer, "4558");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(cap.date, "");
//        BibAssertEqualStrings(cap.ordinal.number, "7088");
//        BibAssertEqualStrings(cap.ordinal.suffix, "p");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//}
//
//- (void)test_parse_lc_caption_root {
//    {
//        char const *str = "QA";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA76.76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "76");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "DR1879.5";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "DR");
//        BibAssertEqualStrings(cap.integer, "1879");
//        BibAssertEqualStrings(cap.decimal, "5");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA ";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, " ", @"don't consume trailing space");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA 76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA 76.76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len));
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "76");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = " ";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertFalse(bib_parse_lc_caption_root(&cap, &str, &len), @"don't consume leading space");
//        BibAssertEqualStrings(cap.letters, "");
//        BibAssertEqualStrings(cap.integer, "");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, " ");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = " QA76.76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertFalse(bib_parse_lc_caption_root(&cap, &str, &len), @"don't consume leading space");
//        BibAssertEqualStrings(cap.letters, "");
//        BibAssertEqualStrings(cap.integer, "");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, " QA76.76");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "76.76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertFalse(bib_parse_lc_caption_root(&cap, &str, &len), @"require class letters");
//        BibAssertEqualStrings(cap.letters, "");
//        BibAssertEqualStrings(cap.integer, "");
//        BibAssertEqualStrings(cap.decimal, "");
//        BibAssertEqualStrings(str, "76.76");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "QA 76 .76";
//        size_t len = strlen(str) + 1;
//        bib_lc_caption_t cap;
//        memset(&cap, 0, sizeof(bib_lc_caption_t));
//        XCTAssertTrue(bib_parse_lc_caption_root(&cap, &str, &len), @"allow partial match");
//        BibAssertEqualStrings(cap.letters, "QA");
//        BibAssertEqualStrings(cap.integer, "76");
//        BibAssertEqualStrings(cap.decimal, "", @"don't parse decimal with leading spacee");
//        BibAssertEqualStrings(str, " .76", @"leave decimal with leading space");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//}
//
//- (void)test_parse_lc_caption_ordinal {
//    {
//        char const *str = "15th.";
//        size_t len = strlen(str) + 1;
//        bib_ordinal_t ord;
//        memset(&ord, 0, sizeof(bib_ordinal_t));
//        XCTAssertTrue(bib_parse_lc_caption_ordinal(&ord, &str, &len));
//        BibAssertEqualStrings(ord.number, "15");
//        BibAssertEqualStrings(ord.suffix, "th.");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "15 th.";
//        size_t len = strlen(str) + 1;
//        bib_ordinal_t ord;
//        memset(&ord, 0, sizeof(bib_ordinal_t));
//        XCTAssertTrue(bib_parse_lc_caption_ordinal(&ord, &str, &len));
//        BibAssertEqualStrings(ord.number, "15");
//        BibAssertEqualStrings(ord.suffix, "th.");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "15 th";
//        size_t len = strlen(str) + 1;
//        bib_ordinal_t ord;
//        memset(&ord, 0, sizeof(bib_ordinal_t));
//        XCTAssertTrue(bib_parse_lc_caption_ordinal(&ord, &str, &len));
//        BibAssertEqualStrings(ord.number, "15");
//        BibAssertEqualStrings(ord.suffix, "th");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "15th";
//        size_t len = strlen(str) + 1;
//        bib_ordinal_t ord;
//        memset(&ord, 0, sizeof(bib_ordinal_t));
//        XCTAssertTrue(bib_parse_lc_caption_ordinal(&ord, &str, &len));
//        BibAssertEqualStrings(ord.number, "15");
//        BibAssertEqualStrings(ord.suffix, "th");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//}
//
//- (void)test_parse_lc_caption_ordinal_suffix {
//    {
//        char const *str = "th.";
//        size_t len = strlen(str) + 1;
//        char buffer[bib_suffix_size + 2];
//        XCTAssertTrue(bib_parse_lc_caption_ordinal_suffix(buffer, &str, &len));
//        BibAssertEqualStrings(buffer, "th.");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "th. ";
//        size_t len = strlen(str) + 1;
//        char buffer[bib_suffix_size + 2];
//        XCTAssertTrue(bib_parse_lc_caption_ordinal_suffix(buffer, &str, &len));
//        BibAssertEqualStrings(buffer, "th.");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "th ";
//        size_t len = strlen(str) + 1;
//        char buffer[bib_suffix_size + 2];
//        XCTAssertTrue(bib_parse_lc_caption_ordinal_suffix(buffer, &str, &len));
//        BibAssertEqualStrings(buffer, "th", @"don't add a period that doesn't appear in the input");
//        BibAssertEqualStrings(str, " ", @"don't consume the trailing space without a period");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "th";
//        size_t len = strlen(str) + 1;
//        char buffer[bib_suffix_size + 2];
//        XCTAssertTrue(bib_parse_lc_caption_ordinal_suffix(buffer, &str, &len));
//        BibAssertEqualStrings(buffer, "th", @"don't add a period that doesn't appear in the input");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "TH";
//        size_t len = strlen(str) + 1;
//        char buffer[bib_suffix_size + 2];
//        XCTAssertFalse(bib_parse_lc_caption_ordinal_suffix(buffer, &str, &len), @"no capitals in ordinal suffixes");
//        BibAssertEqualStrings(buffer, "");
//        BibAssertEqualStrings(str, "TH");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//}

#pragma mark - lc cutter

//- (void)test_parse_lc_cutter {
//    {
//        char const *str = ".A123 2020 B123";
//        size_t len = strlen(str) + 1;
//        bib_cutter_t cutters[3];
//        memset(cutters, 0, sizeof(cutters));
//        XCTAssertTrue(bib_parse_lc_cutter(cutters, &str, &len), @"parse valid cutter section");
//        BibAssertEqualStrings(cutters[0].number, "A123");
//        BibAssertEqualStrings(cutters[0].date, "2020");
//        BibAssertEqualStrings(cutters[1].number, "B123");
//        BibAssertEqualStrings(cutters[1].date, "");
//        BibAssertEqualStrings(cutters[2].number, "");
//        BibAssertEqualStrings(cutters[2].date, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = "A123 2020 B123";
//        size_t len = strlen(str) + 1;
//        bib_cutter_t cutters[3];
//        memset(cutters, 0, sizeof(cutters));
//        XCTAssertFalse(bib_parse_lc_cutter(cutters, &str, &len), @"cutter section must begin with a period");
//        BibAssertEqualStrings(cutters[0].number, "");
//        BibAssertEqualStrings(cutters[0].date, "");
//        BibAssertEqualStrings(cutters[1].number, "");
//        BibAssertEqualStrings(cutters[1].date, "");
//        BibAssertEqualStrings(cutters[2].number, "");
//        BibAssertEqualStrings(cutters[2].date, "");
//        BibAssertEqualStrings(str, "A123 2020 B123");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//    {
//        char const *str = ".E59 A21";
//        size_t len = strlen(str) + 1;
//        bib_cutter_t cutters[3];
//        memset(cutters, 0, sizeof(cutters));
//        XCTAssertTrue(bib_parse_lc_cutter(cutters, &str, &len), @"parse valid cutter section");
//        BibAssertEqualStrings(cutters[0].number, "E59");
//        BibAssertEqualStrings(cutters[0].date, "");
//        BibAssertEqualStrings(cutters[1].number, "A21");
//        BibAssertEqualStrings(cutters[1].date, "");
//        BibAssertEqualStrings(cutters[2].number, "");
//        BibAssertEqualStrings(cutters[2].date, "");
//        BibAssertEqualStrings(str, "");
//        XCTAssertEqual(len, strlen(str) + 1);
//    }
//}

- (void)test_parse_lc_cutter {
    {
        char const *str = "A123 2020";
        size_t len = strlen(str) + 1;
        bib_lc_cutter_t cut;
        memset(&cut, 0, sizeof(cut));
        XCTAssertTrue(bib_parse_lc_cutter(&cut, &str, &len), @"parse valid cutter number with date");

        XCTAssertEqual(cut.cuttnum.letter, 'A', @"parse cutter initial");
        BibAssertEqualStrings(cut.cuttnum.number, "123", @"parse cutter number");
        BibAssertEqualStrings(cut.cuttnum.mark, "");
        XCTAssertEqual(cut.datenum.kind, bib_lc_number_date, @"parse date value");
        BibAssertEqualStrings(cut.datenum.value.date.year, "2020", @"parse year");
        BibAssertEqualStrings(cut.datenum.value.date.span, "");

        BibAssertEqualStrings(str, "", @"input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"input string contains null terminator");
    }
    {
        char const *str = "A123";
        size_t len = strlen(str) + 1;
        bib_lc_cutter_t cut;
        memset(&cut, 0, sizeof(cut));
        XCTAssertTrue(bib_parse_lc_cutter(&cut, &str, &len), @"parse valid cutter number without date");

        XCTAssertEqual(cut.cuttnum.letter, 'A', @"parse cutter initial");
        BibAssertEqualStrings(cut.cuttnum.number, "123", @"parse cutter number");
        BibAssertEqualStrings(cut.cuttnum.mark, "");
        XCTAssertTrue(bib_lc_number_is_empty(&(cut.datenum)), @"don't parse date value");

        BibAssertEqualStrings(str, "", @"input string should be empty");
        XCTAssertEqual(len, strlen(str) + 1, @"input string contains null terminator");
    }
    {
        char const *str = "A123 B123";
        size_t len = strlen(str) + 1;
        bib_lc_cutter_t cut;
        memset(&cut, 0, sizeof(cut));
        XCTAssertTrue(bib_parse_lc_cutter(&cut, &str, &len), @"parse valid cutter number without date");

        XCTAssertEqual(cut.cuttnum.letter, 'A', @"parse cutter initial");
        BibAssertEqualStrings(cut.cuttnum.number, "123", @"parse cutter number");
        BibAssertEqualStrings(cut.cuttnum.mark, "");
        XCTAssertTrue(bib_lc_number_is_empty(&(cut.datenum)), @"don't parse date value");

        BibAssertEqualStrings(str, " B123", @"input string should contain a space and the second cutter number");
        XCTAssertEqual(len, strlen(str) + 1, @"input string contains null terminator");
    }
}

@end
