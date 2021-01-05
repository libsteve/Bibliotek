//
//  BibClassInclusionTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibClassInclusionTests : XCTestCase
@end

@implementation BibClassInclusionTests

- (void)test_01 {
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

- (void)test_02 {
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

- (void)test_03 {
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

- (void)test_04 {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    XCTAssertFalse([a includesCallNumber:b]);
    XCTAssertFalse([b includesCallNumber:c]);
    XCTAssertFalse([a includesCallNumber:c]);
    XCTAssertFalse([b includesCallNumber:a]);
    XCTAssertFalse([c includesCallNumber:b]);
    XCTAssertFalse([c includesCallNumber:a]);
}

- (void)test_05 {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8.P3"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"BX873 1864-1865"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    XCTAssertTrue([d includesCallNumber:a]);
    XCTAssertTrue([d includesCallNumber:b]);
    XCTAssertTrue([c includesCallNumber:a]);
    XCTAssertTrue([c includesCallNumber:b]);
    XCTAssertTrue([c includesCallNumber:d]);
    XCTAssertFalse([a includesCallNumber:d]);
    XCTAssertFalse([b includesCallNumber:d]);
    XCTAssertFalse([a includesCallNumber:c]);
    XCTAssertFalse([b includesCallNumber:c]);
    XCTAssertFalse([d includesCallNumber:c]);
}

- (void)test_06_AC_class_letter_specifying {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ac = [[BibLCCallNumber alloc] initWithString:@"AC"];
    XCTAssertTrue([a includesCallNumber:ac]);
}

- (void)test_06_AE_class_letter_specifying {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ae = [[BibLCCallNumber alloc] initWithString:@"AE"];
    XCTAssertTrue([a includesCallNumber:ae]);
}

- (void)test_06_AG_class_letter_specifying {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ag = [[BibLCCallNumber alloc] initWithString:@"AG"];
    XCTAssertTrue([a includesCallNumber:ag]);
}

- (void)test_06_AC_class_number_specifying {
    BibLCCallNumber *const ac  = [[BibLCCallNumber alloc] initWithString:@"AC"];
    BibLCCallNumber *const ac1 = [[BibLCCallNumber alloc] initWithString:@"AC165.5.G45"];
    XCTAssertTrue([ac includesCallNumber:ac1]);
}

- (void)test_06_AE_class_number_specifying {
    BibLCCallNumber *const ae  = [[BibLCCallNumber alloc] initWithString:@"AE"];
    BibLCCallNumber *const ae3 = [[BibLCCallNumber alloc] initWithString:@"AE35.79"];
    XCTAssertTrue([ae includesCallNumber:ae3]);
}

- (void)test_06_AG_class_number_specifying {
    BibLCCallNumber *const ag  = [[BibLCCallNumber alloc] initWithString:@"AG"];
    BibLCCallNumber *const ag3 = [[BibLCCallNumber alloc] initWithString:@"AG35.783"];
    XCTAssertTrue([ag includesCallNumber:ag3]);
}

- (void)test_06_AC_class_transitive_specifying {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ac1 = [[BibLCCallNumber alloc] initWithString:@"AC165.5.G45"];
    XCTAssertTrue([a includesCallNumber:ac1]);
}

- (void)test_06_AE_class_transitive_specifying {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ae3 = [[BibLCCallNumber alloc] initWithString:@"AE35.79"];
    XCTAssertTrue([a includesCallNumber:ae3]);
}

- (void)test_06_AG_class_transitive_specifying {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ag3 = [[BibLCCallNumber alloc] initWithString:@"AG35.783"];
    XCTAssertTrue([a includesCallNumber:ag3]);
}

@end
