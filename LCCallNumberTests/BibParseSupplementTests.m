//
//  BibParseSupplementTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseSupplementTests : XCTestCase
@end

@implementation BibParseSupplementTests

- (void)test_01_dont_save_periods {
    bib_supplement_t supl = {};
    bib_strbuf_t parser = bib_strbuf("Suppl. 10", 0);
    XCTAssertTrue(bib_parse_supplement(&supl, &parser));
    BibAssertEqualStrings(supl.prefix, "Suppl", @"don't save periods");
    BibAssertEqualStrings(supl.number, "10");
    XCTAssertTrue(supl.isabbr, @"keep track of the period");
    XCTAssertFalse(supl.hasetc);
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_02_require_space_before_numeral {
    bib_supplement_t supl = {};
    bib_strbuf_t parser = bib_strbuf("Suppl.10", 0);
    XCTAssertFalse(bib_parse_supplement(&supl, &parser), @"require space before numeral");
    XCTAssertTrue(bib_supplement_is_empty(&supl));
    BibAssertEqualStrings(supl.prefix, "");
    BibAssertEqualStrings(supl.number, "");
    BibAssertEqualStrings(parser.str, "Suppl.10");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_03_optional_period_after_prefix {
    bib_supplement_t supl = {};
    bib_strbuf_t parser = bib_strbuf("Index 10", 0);
    XCTAssertTrue(bib_parse_supplement(&supl, &parser), @"optional period after prefix");
    XCTAssertFalse(bib_supplement_is_empty(&supl));
    BibAssertEqualStrings(supl.prefix, "Index");
    BibAssertEqualStrings(supl.number, "10");
    XCTAssertFalse(supl.isabbr, @"keep track of the lack of a period");
    XCTAssertFalse(supl.hasetc);
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_04_require_either_space_or_period_before_number {
    bib_supplement_t supl = {};
    bib_strbuf_t parser = bib_strbuf("Suppl10", 0);
    XCTAssertFalse(bib_parse_supplement(&supl, &parser), @"require period after prefix");
    XCTAssertTrue(bib_supplement_is_empty(&supl));
    BibAssertEqualStrings(supl.prefix, "");
    BibAssertEqualStrings(supl.number, "");
    BibAssertEqualStrings(parser.str, "Suppl10");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_05_keep_track_of_etcetera {
    bib_supplement_t supl = {};
    bib_strbuf_t parser = bib_strbuf("Suppl. 10, etc.", 0);
    XCTAssertTrue(bib_parse_supplement(&supl, &parser), @"keep track of the etcetera");
    BibAssertEqualStrings(supl.prefix, "Suppl", @"don't save periods");
    BibAssertEqualStrings(supl.number, "10");
    XCTAssertTrue(supl.isabbr, @"keep track of the period");
    XCTAssertTrue(supl.hasetc, @"keep track of the etcetera");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_06_require_capital_initial_letter {
    bib_supplement_t supl = {};
    bib_strbuf_t parser = bib_strbuf("suppl. 10", 0);
    XCTAssertFalse(bib_parse_supplement(&supl, &parser), @"require a capital initial letter");
    XCTAssertTrue(bib_supplement_is_empty(&supl));
    BibAssertEqualStrings(supl.prefix, "");
    BibAssertEqualStrings(supl.number, "");
    BibAssertEqualStrings(parser.str, "suppl. 10");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

@end
