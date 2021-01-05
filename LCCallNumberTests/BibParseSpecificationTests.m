//
//  BibParseSpecificationTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseSpecificationTests : XCTestCase

@end

@implementation BibParseSpecificationTests

- (void)test_01_parse_date {
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

- (void)test_02_parse_date_span {
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

- (void)test_03_parse_ordinal {
    bib_lc_specification_t spc = {};
    bib_strbuf_t parser = bib_strbuf("15th.ed.", 0);
    XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
    XCTAssertEqual(spc.kind, bib_lc_specification_kind_ordinal);
    BibAssertEqualStrings(spc.ordinal.number, "15");
    BibAssertEqualStrings(spc.ordinal.suffix, "th.ed.");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_04_parse_ordinal_not_date {
    bib_lc_specification_t spc = {};
    bib_strbuf_t parser = bib_strbuf("2015th.", 0);
    XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
    XCTAssertEqual(spc.kind, bib_lc_specification_kind_ordinal, @"parse an ordinal, not a date");
    BibAssertEqualStrings(spc.ordinal.number, "2015");
    BibAssertEqualStrings(spc.ordinal.suffix, "th.");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_05_parse_volume {
    bib_lc_specification_t spc = {};
    bib_strbuf_t parser = bib_strbuf("vol. 15", 0);
    XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
    XCTAssertEqual(spc.kind, bib_lc_specification_kind_volume);
    BibAssertEqualStrings(spc.volume.prefix, "vol");
    BibAssertEqualStrings(spc.volume.number, "15");
    XCTAssertFalse(spc.volume.hasetc);
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_06_parse_supplement {
    bib_lc_specification_t spc = {};
    bib_strbuf_t parser = bib_strbuf("Suppl. 15", 0);
    XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
    XCTAssertEqual(spc.kind, bib_lc_specification_kind_supplement);
    BibAssertEqualStrings(spc.supplement.prefix, "Suppl");
    BibAssertEqualStrings(spc.supplement.number, "15");
    XCTAssertFalse(spc.supplement.hasetc);
    XCTAssertTrue(spc.supplement.isabbr);
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_08_parse_word {
    bib_lc_specification_t spc = {};
    bib_strbuf_t parser = bib_strbuf("n.s.", 0);
    XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
    XCTAssertEqual(spc.kind, bib_lc_specification_kind_word);
    BibAssertEqualStrings(spc.word, "n.s.");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_09_parse_word {
    bib_lc_specification_t spc = {};
    bib_strbuf_t parser = bib_strbuf("K.252", 0);
    XCTAssertTrue(bib_parse_lc_specification(&spc, &parser));
    XCTAssertEqual(spc.kind, bib_lc_specification_kind_word);
    BibAssertEqualStrings(spc.word, "K.252");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}


@end
