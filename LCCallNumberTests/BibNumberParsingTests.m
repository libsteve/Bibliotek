//
//  BibNumberParsingTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibNumberParsingTests : XCTestCase
@end

@implementation BibNumberParsingTests

- (void)test_01 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"QA76.76.C65A37 1986");
}

- (void)test_02 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"DR1879.5.M37M37 1988");
}

- (void)test_03 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th.K46 1908"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"KF4558 15th.K46 1908");
}

- (void)test_04 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"JZ33.D4 1999 E37");
}

- (void)test_05 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988/89"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"DR1879.5.M37M37 1988/89");
}

- (void)test_06 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QL737.C2C37 1984a"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"QL737.C2C37 1984a");
}

- (void)test_07 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"AB32.64.S6L552 vol. 1 1976ab"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"AB32.64.S6L552 vol. 1 1976ab");
}

- (void)test_08 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5 1988.C786 15th.ed. Suppl. 3"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"DR1879.5 1988.C786 15th.ed. Suppl. 3");
}

- (void)test_09 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX9875.5A"];
    XCTAssertNotNil(calln);
    XCTAssertEqualObjects(calln.stringValue, @"BX9875.5.A");
}

#pragma mark -

- (void)test_complex_number_01 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX873 1463 Apr. 26 .C38"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_02 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8 .M3"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_03 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8.P3"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_04 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"G1264.P5G46 B36 1985"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_05 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"G1264.P5G46 B35 1889 fol."];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_06 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"G1264.P5G46 B7 1885 (G&M)"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_07 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX873 1897 Aug.4.P7"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_08 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX873 1993 Aug.6 .M67 1994"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_09 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"BX873 1864 Dec. 8 .E5 no. 9"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_10 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QA76.76.E95 V74 1991b LANDOVR"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_11 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 [2005 02233]"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_12 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QA9 .P57 1954a"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_13 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QAC90 .B5 FT MEADE SpecMat"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_14 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QB1 .A1736 t. 10, etc."];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_complex_number_15 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"JX1989.5 1944 IXb"];
    XCTAssertNotNil(calln.stringValue);
}

#pragma mark -

- (void)test_basic_number_01 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"A"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_basic_number_02 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"AB"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_basic_number_03 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"ABC"];
    XCTAssertNotNil(calln.stringValue);
}

- (void)test_basic_number_04 {
    XCTSkip(@"We'll get back to this another time.");
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"ABCD"];
    XCTAssertNil(calln.stringValue);
}

- (void)test_basic_number_05 {
    BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"ABCDE"];
    XCTAssertNil(calln.stringValue);
}

@end
