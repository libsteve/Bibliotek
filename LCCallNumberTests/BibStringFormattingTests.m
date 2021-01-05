//
//  BibStringFormattingTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibStringFormattingTests : XCTestCase
@property (nonatomic, readonly, strong) BibLCCallNumber *a;
@property (nonatomic, readonly, strong) BibLCCallNumber *b;
@property (nonatomic, readonly, strong) BibLCCallNumber *c;
@property (nonatomic, readonly, strong) BibLCCallNumber *d;
@property (nonatomic, readonly, strong) BibLCCallNumber *e;
@property (nonatomic, readonly, strong) BibLCCallNumber *f;
@property (nonatomic, readonly, strong) BibLCCallNumber *g;
@end

/// These test cases are taken from the OCLC's documentation on the MARC bibliographic field
/// 050 Library of Congress Call Number \a https://www.oclc.org/bibformats/en/0xx/050.html
@implementation BibStringFormattingTests

- (void)setUp {
    [super setUp];
    _a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37M37 1998"];
    _b = [[BibLCCallNumber alloc] initWithString:@"M211.M94 K.252 1989 c"];
    _c = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
    _d = [[BibLCCallNumber alloc] initWithString:@"PS3523.O46 1968"];
    _e = [[BibLCCallNumber alloc] initWithString:@"HF5414.13.R73 1978"];
    _f = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th.K46 1908"];
    _g = [[BibLCCallNumber alloc] initWithString:@"Q11.P6 n.s. v. 56 pt. 9"];
}

- (void)test_a_default {
    XCTAssertEqualObjects([_a stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"DR1879.5.M37M37 1998");
}

- (void)test_a_pocket {
    XCTAssertEqualObjects([_a stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"DR 1879.5 .M37 M37 1998");
}

- (void)test_a_spine {
    XCTAssertEqualObjects([_a stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"DR\n1879.5\n.M37\nM37\n1998");
}

- (void)test_b_default {
    XCTAssertEqualObjects([_b stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"M211.M94 K.252 1989 c");
}

- (void)test_b_pocket {
    XCTAssertEqualObjects([_b stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"M 211 .M94 K.252 1989 c");
}

- (void)test_b_spine {
    XCTAssertEqualObjects([_b stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"M\n211\n.M94\nK.252\n1989\nc");
}

- (void)test_c_default {
    XCTAssertEqualObjects([_c stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"JZ33.D4 1999 E37");
}

- (void)test_c_pocket {
    XCTAssertEqualObjects([_c stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"JZ 33 .D4 1999 E37");
}

- (void)test_c_spine {
    XCTAssertEqualObjects([_c stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"JZ\n33\n.D4\n1999\nE37");
}

- (void)test_c_custom {
    XCTAssertEqualObjects([_c stringWithFormatOptions:(BibLCCallNumberFormatOptionsExpandCutterMarks
                                                      | BibLCCallNumberFormatOptionsMarkCutterAfterDate)],
                          @"JZ33 .D4 1999 .E37");
}

- (void)test_d_default {
    XCTAssertEqualObjects([_d stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"PS3523.O46 1968");
}

- (void)test_d_pocket {
    XCTAssertEqualObjects([_d stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"PS 3523 .O46 1968");
}

- (void)test_d_spine {
    XCTAssertEqualObjects([_d stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"PS\n3523\n.O46\n1968");
}

- (void)test_e_default {
    XCTAssertEqualObjects([_e stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"HF5414.13.R73 1978");
}

- (void)test_e_pocket {
    XCTAssertEqualObjects([_e stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"HF 5414.13 .R73 1978");
}

- (void)test_e_spine {
    XCTAssertEqualObjects([_e stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"HF\n5414.13\n.R73\n1978");
}

- (void)test_f_default {
    XCTAssertEqualObjects([_f stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"KF4558 15th.K46 1908");
}

- (void)test_f_pocket {
    XCTAssertEqualObjects([_f stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"KF 4558 15th .K46 1908");
}

- (void)test_f_spine {
    XCTAssertEqualObjects([_f stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"KF\n4558\n15th\n.K46\n1908");
}

- (void)test_g_default {
    XCTAssertEqualObjects([_g stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"Q11.P6 n.s. v. 56 pt. 9");
}

- (void)test_g_pocket {
    XCTAssertEqualObjects([_g stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"Q 11 .P6 n.s. v. 56 pt. 9");
}

- (void)test_g_spine {
    XCTAssertEqualObjects([_g stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"Q\n11\n.P6\nn.s.\nv. 56\npt. 9");
}

@end
