//
//  BibParseVolumeTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibTestUtils.h"
#import "bibparse.h"
#import "bibtype.h"

@interface BibParseVolumeTests : XCTestCase
@end

@implementation BibParseVolumeTests

- (void)test_01_dont_save_periods {
    bib_volume_t vol = {};
    bib_strbuf_t parser = bib_strbuf("vol. 10", 0);
    XCTAssertTrue(bib_parse_volume(&vol, &parser));
    BibAssertEqualStrings(vol.prefix, "vol", @"don't save periods");
    BibAssertEqualStrings(vol.number, "10");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_02_optional_space_before_numeral {
    bib_volume_t vol = {};
    bib_strbuf_t parser = bib_strbuf("vol.10", 0);
    XCTAssertTrue(bib_parse_volume(&vol, &parser), @"optional space before numeral");
    XCTAssertFalse(bib_volume_is_empty(&vol));
    BibAssertEqualStrings(vol.prefix, "vol");
    BibAssertEqualStrings(vol.number, "10");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_03_keep_track_of_etcetera {
    bib_volume_t vol = {};
    bib_strbuf_t parser = bib_strbuf("vol. 10, etc.", 0);
    XCTAssertTrue(bib_parse_volume(&vol, &parser), @"keep track of the etcetera");
    XCTAssertFalse(bib_volume_is_empty(&vol));
    BibAssertEqualStrings(vol.prefix, "vol");
    BibAssertEqualStrings(vol.number, "10");
    XCTAssertTrue(vol.hasetc, @"keep track of the etcetera");
    BibAssertEqualStrings(parser.str, "");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_04_require_period_after_prefix {
    bib_volume_t vol = {};
    bib_strbuf_t parser = bib_strbuf("vol 10", 0);
    XCTAssertFalse(bib_parse_volume(&vol, &parser), @"require period after prefix");
    XCTAssertTrue(bib_volume_is_empty(&vol));
    BibAssertEqualStrings(vol.prefix, "");
    BibAssertEqualStrings(vol.number, "");
    BibAssertEqualStrings(parser.str, "vol 10");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_05_require_period_after_prefix {
    bib_volume_t vol = {};
    bib_strbuf_t parser = bib_strbuf("vol10", 0);
    XCTAssertFalse(bib_parse_volume(&vol, &parser), @"require period after prefix");
    XCTAssertTrue(bib_volume_is_empty(&vol));
    BibAssertEqualStrings(vol.prefix, "");
    BibAssertEqualStrings(vol.number, "");
    BibAssertEqualStrings(parser.str, "vol10");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

- (void)test_06_require_lowercase_letters {
    bib_volume_t vol = {};
    bib_strbuf_t parser = bib_strbuf("Vol. 10", 0);
    XCTAssertFalse(bib_parse_volume(&vol, &parser), @"require lowercase letters");
    XCTAssertTrue(bib_volume_is_empty(&vol));
    BibAssertEqualStrings(vol.prefix, "");
    BibAssertEqualStrings(vol.number, "");
    BibAssertEqualStrings(parser.str, "Vol. 10");
    XCTAssertEqual(parser.len, strlen(parser.str) + 1);
}

@end
