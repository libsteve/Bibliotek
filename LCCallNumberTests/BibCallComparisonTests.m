//
//  BibCallComparisonTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibNumberComparisonTests : XCTestCase
@end

@implementation BibNumberComparisonTests

- (void)test_01_transitive_comparison {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q172.J64 2017"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.9.T48 I544 2013"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.73.J39 D83 2014"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];

    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
    XCTAssertEqual(NSOrderedDescending, [b compare:c]);
    XCTAssertEqual(NSOrderedAscending, [c compare:d]);
}

- (void)test_02_sorted_array {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46 1908"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
    NSArray *const unsortedArray = @[ a, b, c, d ];
    NSArray *const sortedArray = [unsortedArray sortedArrayUsingSelector:@selector(compare:)];
    NSArray *const expectation = @[ b, d, c, a ];
    XCTAssertEqualObjects(expectation, sortedArray);
}

- (void)test_03_class_decimal_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.51.M37 M37 1988"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_03_class_decimal_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.51.M37 M37 1988"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_04_first_cutter_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 2012"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_04_first_cutter_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 2012"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_04_first_cutter_date_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 1998"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_04_first_cutter_date_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 1998"];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_05_second_cutter_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 N46 2011"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_05_second_cutter_date_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2005"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_05_second_cutter_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 N46 2011"];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_05_second_cutter_date_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2005"];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_06_1_supplement_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_06_1_supplement_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_06_2_supplement_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_06_2_supplement_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_06_3_supplement_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
}

- (void)test_06_3_supplement_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    XCTAssertEqual(NSOrderedDescending, [a compare:b]);
}

- (void)test_07 {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8.P3"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"BX873 1864-1865"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    XCTAssertEqual(NSOrderedAscending, [a compare:b]);
    XCTAssertEqual(NSOrderedAscending, [d compare:a]);
    XCTAssertEqual(NSOrderedAscending, [d compare:b]);
    XCTAssertEqual(NSOrderedAscending, [c compare:d]);
    XCTAssertEqual(NSOrderedAscending, [c compare:a]);
    XCTAssertEqual(NSOrderedAscending, [c compare:b]);
    XCTAssertEqual(NSOrderedDescending, [b compare:a]);
    XCTAssertEqual(NSOrderedDescending, [a compare:d]);
    XCTAssertEqual(NSOrderedDescending, [b compare:d]);
    XCTAssertEqual(NSOrderedDescending, [d compare:c]);
    XCTAssertEqual(NSOrderedDescending, [a compare:c]);
    XCTAssertEqual(NSOrderedDescending, [b compare:c]);
}

@end
