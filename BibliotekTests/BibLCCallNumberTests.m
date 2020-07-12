//
//  BibLCCallNumberTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>
#import "BibLCCallNumber+Internal.h"

#define BibAssertEqualStrings(expression1, expression2, ...) \
    _XCTPrimitiveAssertEqualObjects(self, @(expression1), @#expression1, @(expression2), @#expression2, __VA_ARGS__)

@interface BibLCCallNumberTests : XCTestCase

@end

@implementation BibLCCallNumberTests

- (void)test_read_alphabetic_segment {
    char buffer[4];
    memset(buffer, 0, 4);
    char const *const string = "QA76.76.E95";
    char const *input = string;
    u_long length = strlen(string);

    XCTAssertTrue(bib_read_lc_calln_alphabetic_segment(buffer, &input, &length));
    BibAssertEqualStrings(buffer, "QA");
    BibAssertEqualStrings(input, "76.76.E95");
}

- (void)test_read_whole_number {
    char buffer[5];
    memset(buffer, 0, 5);
    char const *const string = "76.76.E95";
    char const *input = string;
    u_long length = strlen(string);

    XCTAssertTrue(bib_read_lc_calln_whole_number(buffer, &input, &length));
    BibAssertEqualStrings(buffer, "76");
    BibAssertEqualStrings(input, ".76.E95");
}

- (void)test_read_decimal_number {
    char buffer[4];
    memset(buffer, 0, 4);
    char const *const string = ".76.E59";
    char const *input = string;
    u_long length = strlen(string);

    XCTAssertTrue(bib_read_lc_calln_decimal_number(buffer, &input, &length));
    BibAssertEqualStrings(buffer, "76");
    BibAssertEqualStrings(input, ".E59");
}

- (void)test_read_date_or_other_number {
    {
        char buffer[5];
        memset(buffer, 0, 5);
        char const *const string = "2012 I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_read_lc_calln_date_or_other_number(buffer, &input, &length));
        BibAssertEqualStrings(buffer, "2012");
        BibAssertEqualStrings(input, " I13");
    }
    {
        char buffer[5];
        memset(buffer, 0, 5);
        char const *const string = "15th I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_read_lc_calln_date_or_other_number(buffer, &input, &length));
        BibAssertEqualStrings(buffer, "15th");
        BibAssertEqualStrings(input, " I13");
    }
}

- (void)test_read_cutter_number {
    char buffer[5];
    memset(buffer, 0, 5);
    char const *const string = "E59 A21";
    char const *input = string;
    u_long length = strlen(string);

    XCTAssertTrue(bib_read_lc_calln_cutter_number(buffer, &input, &length));
    BibAssertEqualStrings(buffer, "E59");
    BibAssertEqualStrings(input, " A21");
}

#pragma mark -

- (void)test_calln_read_alphabetic_segment {
    bib_lc_calln_t calln;
    memset(&calln, 0, sizeof(calln));
    char const *const string = "QA76.76.E95";
    char const *input = string;
    u_long length = strlen(string);

    XCTAssertTrue(bib_lc_calln_read_alphabetic_segment(&calln, &input, &length));
    BibAssertEqualStrings(calln.alphabetic_segment, "QA");
    BibAssertEqualStrings(input, "76.76.E95");
}

- (void)test_calln_read_whole_number {
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = "76.76.E95";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_whole_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.whole_number, "76");
        BibAssertEqualStrings(input, ".76.E95");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " 76.76.E95";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_whole_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.whole_number, "76");
        BibAssertEqualStrings(input, ".76.E95");
    }
}

- (void)test_calln_read_decimal_number {
    bib_lc_calln_t calln;
    memset(&calln, 0, sizeof(calln));
    char const *const string = ".76.E95";
    char const *input = string;
    u_long length = strlen(string);

    XCTAssertTrue(bib_lc_calln_read_decimal_number(&calln, &input, &length));
    BibAssertEqualStrings(calln.decimal_number, "76");
    BibAssertEqualStrings(input, ".E95");
}

- (void)test_calln_read_date_or_other_number {
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " 2012 I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_date_or_other_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.date_or_other_number, "2012");
        BibAssertEqualStrings(input, "I13");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " 15th I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_date_or_other_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.date_or_other_number, "15th");
        BibAssertEqualStrings(input, "I13");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = "15th I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertFalse(bib_lc_calln_read_date_or_other_number(&calln, &input, &length), @"A leading space is required");
        BibAssertEqualStrings(calln.date_or_other_number, "");
        BibAssertEqualStrings(input, "15th I13");
    }
}

- (void)test_calln_read_first_cutter_number {
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = ".E95 A21";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_first_cutter_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.first_cutter_number, "E95");
        BibAssertEqualStrings(input, " A21");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " .E95 A21";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_first_cutter_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.first_cutter_number, "E95");
        BibAssertEqualStrings(input, " A21");
    }
}

- (void)test_calln_read_number_after_cutter {
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " 2012 I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_number_after_cutter(&calln, &input, &length));
        BibAssertEqualStrings(calln.date_or_other_number_after_first_cutter, "2012");
        BibAssertEqualStrings(input, " I13");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " 15th I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_number_after_cutter(&calln, &input, &length));
        BibAssertEqualStrings(calln.date_or_other_number_after_first_cutter, "15th");
        BibAssertEqualStrings(input, " I13");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = "15th I13";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertFalse(bib_lc_calln_read_number_after_cutter(&calln, &input, &length), @"A leading space is required");
        BibAssertEqualStrings(calln.date_or_other_number_after_first_cutter, "");
        BibAssertEqualStrings(input, "15th I13");
    }
}

- (void)test_calln_read_second_cutter_number {
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = " A21";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertTrue(bib_lc_calln_read_second_cutter_number(&calln, &input, &length));
        BibAssertEqualStrings(calln.second_cutter_number, "A21");
        BibAssertEqualStrings(input, "");
    }
    {
        bib_lc_calln_t calln;
        memset(&calln, 0, sizeof(calln));
        char const *const string = "A21";
        char const *input = string;
        u_long length = strlen(string);

        XCTAssertFalse(bib_lc_calln_read_second_cutter_number(&calln, &input, &length), @"A leading space is required");
        BibAssertEqualStrings(calln.second_cutter_number, "");
        BibAssertEqualStrings(input, "A21");
    }
}

#pragma mark -

- (void)testLCCallNumberWithString {
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"QA76.76.C65 A37 1986");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"DR1879.5.M37 M37 1988");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46 1908"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"KF4558 15th .K46 1908");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"JZ33.D4 1999 E37");
    }
}

- (void)testLCCallNumberComparison {
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q172.J64 2017"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.9.T48 I544 2013"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.73.J39 D83 2014"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];

        XCTAssertEqual(NSOrderedAscending, [a compare:b]);
        XCTAssertEqual(NSOrderedDescending, [b compare:c]);
        XCTAssertEqual(NSOrderedAscending, [c compare:d]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46 1908"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
        NSArray *const unsortedArray = @[ a, b, c, d ];
        NSArray *const sortedArray = [unsortedArray sortedArrayUsingSelector:@selector(compare:)];
        NSArray *const expectation = @[ b, d, c, a ];
        XCTAssertEqualObjects(expectation, sortedArray);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.M37 M37 1988"];
        XCTAssertEqual(NSOrderedDescending, [a compare:b]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998"];
        XCTAssertEqual(NSOrderedAscending, [a compare:b]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 N46 2011"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2005"];
        XCTAssertEqual(NSOrderedAscending, [a compare:b]);
    }
}

- (void)testLCCallNumberInclusion {
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q76"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.C65"];
        BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];

        XCTAssertTrue([b includesCallNumber:c]);
        XCTAssertTrue([b includesCallNumber:d]);
        XCTAssertTrue([c includesCallNumber:e]);
        XCTAssertTrue([b includesCallNumber:e]);
        XCTAssertFalse([a includesCallNumber:b]);
        XCTAssertFalse([c includesCallNumber:b]);
        XCTAssertFalse([c includesCallNumber:d]);
        XCTAssertFalse([d includesCallNumber:c]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR18"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"DR1879.5 1988"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"DR1879.5"];

        XCTAssertTrue([a includesCallNumber:c]);
        XCTAssertTrue([d includesCallNumber:c]);
        XCTAssertTrue([a includesCallNumber:d]);
        XCTAssertFalse([b includesCallNumber:a]);
        XCTAssertFalse([b includesCallNumber:c]);
        XCTAssertFalse([b includesCallNumber:d]);
        XCTAssertFalse([c includesCallNumber:d]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46 1908"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46 1908"];
        BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th"];

        XCTAssertTrue([a includesCallNumber:c]);
        XCTAssertTrue([b includesCallNumber:d]);
        XCTAssertTrue([e includesCallNumber:b]);
        XCTAssertTrue([e includesCallNumber:d]);
        XCTAssertFalse([b includesCallNumber:c]);
        XCTAssertFalse([c includesCallNumber:b]);
        XCTAssertFalse([c includesCallNumber:d]);
        XCTAssertFalse([a includesCallNumber:b]);
        XCTAssertFalse([b includesCallNumber:a]);
        XCTAssertFalse([d includesCallNumber:c]);
        XCTAssertFalse([a includesCallNumber:e]);
        XCTAssertFalse([e includesCallNumber:a]);
    }
}

@end
