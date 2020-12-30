//
//  BibLCCallNumberTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

#define BibAssertEqualStrings(expression1, expression2, ...) \
    _XCTPrimitiveAssertEqualObjects(self, @(expression1), @#expression1, @(expression2), @#expression2, __VA_ARGS__)

@interface BibLCCallNumberTests : XCTestCase

@end

@implementation BibLCCallNumberTests

- (void)testLCCallNumberWithString {
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"QA76.76.C65A37 1986");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"DR1879.5.M37M37 1988");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th.K46 1908"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"KF4558 15th.K46 1908");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"JZ33.D4 1999 E37");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988/89"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"DR1879.5.M37M37 1988/89");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"QL737.C2C37 1984a"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"QL737.C2C37 1984a");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"AB32.64.S6L552 vol. 1 1976ab"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"AB32.64.S6L552 vol. 1 1976ab");
    }
    {
        BibLCCallNumber *const calln = [[BibLCCallNumber alloc] initWithString:@"DR1879.5 1988.C786 15th.ed. Suppl. 3"];
        XCTAssertNotNil(calln);
        XCTAssertEqualObjects(calln.stringValue, @"DR1879.5 1988.C786 15th.ed. Suppl. 3");
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

/// These test cases are taken from the OCLC's documentation on the MARC bibliographic field
/// 050 Library of Congress Call Number \a https://www.oclc.org/bibformats/en/0xx/050.html
- (void)testLCCalNumberStringWithFormatOptions {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37M37 1998"];
    XCTAssertNotNil(a);
    XCTAssertEqualObjects([a stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"DR1879.5.M37M37 1998");
    XCTAssertEqualObjects([a stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"DR 1879.5 .M37 M37 1998");
    XCTAssertEqualObjects([a stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"DR\n1879.5\n.M37\nM37\n1998");

    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"M211.M94 K.252 1989 c"];
    XCTAssertNotNil(b);
    XCTAssertEqualObjects([b stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"M211.M94 K.252 1989 c");
    XCTAssertEqualObjects([b stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"M 211 .M94 K.252 1989 c");
    XCTAssertEqualObjects([b stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"M\n211\n.M94\nK.252\n1989\nc");

    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"JZ33.D4 1999 E37"];
    XCTAssertNotNil(c);
    XCTAssertEqualObjects([c stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"JZ33.D4 1999 E37");
    XCTAssertEqualObjects([c stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"JZ 33 .D4 1999 E37");
    XCTAssertEqualObjects([c stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"JZ\n33\n.D4\n1999\nE37");
    XCTAssertEqualObjects([c stringWithFormatOptions:(BibLCCallNumberFormatOptionsExpandCutterMarks
                                                      | BibLCCallNumberFormatOptionsMarkCutterAfterDate)],
                          @"JZ33 .D4 1999 .E37");

    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"PS3523.O46 1968"];
    XCTAssertNotNil(d);
    XCTAssertEqualObjects([d stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"PS3523.O46 1968");
    XCTAssertEqualObjects([d stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"PS 3523 .O46 1968");
    XCTAssertEqualObjects([d stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"PS\n3523\n.O46\n1968");

    BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"HF5414.13.R73 1978"];
    XCTAssertNotNil(e);
    XCTAssertEqualObjects([e stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"HF5414.13.R73 1978");
    XCTAssertEqualObjects([e stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"HF 5414.13 .R73 1978");
    XCTAssertEqualObjects([e stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"HF\n5414.13\n.R73\n1978");

    BibLCCallNumber *const f = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th.K46 1908"];
    XCTAssertNotNil(f);
    XCTAssertEqualObjects([f stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"KF4558 15th.K46 1908");
    XCTAssertEqualObjects([f stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"KF 4558 15th .K46 1908");
    XCTAssertEqualObjects([f stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"KF\n4558\n15th\n.K46\n1908");

    BibLCCallNumber *const g = [[BibLCCallNumber alloc] initWithString:@"Q11.P6 n.s. v. 56 pt. 9"];
    XCTAssertNotNil(g);
    XCTAssertEqualObjects([g stringWithFormatOptions:BibLCCallNumberFormatOptionsDefault], @"Q11.P6 n.s. v. 56 pt. 9");
    XCTAssertEqualObjects([g stringWithFormatOptions:BibLCCallNumberFormatOptionsPocket], @"Q 11 .P6 n.s. v. 56 pt. 9");
    XCTAssertEqualObjects([g stringWithFormatOptions:BibLCCallNumberFormatOptionsSpine], @"Q\n11\n.P6\nn.s.\nv. 56\npt. 9");
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

- (void)testLCCallNumberClassificationComparison {
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q172.J64 2017"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.9.T48 I544 2013"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.73.J39 D83 2014"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];

        XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedDescending, [b compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedAscending, [c compareWithCallNumber:d]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.M37 M37 1988"];
        XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998"];
        XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 N46 2011"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2005"];
        XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];

        XCTAssertEqual(BibClassificationOrderedSame, [a compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedSame, [b compareWithCallNumber:a]);
        XCTAssertEqual(BibClassificationOrderedSame, [c compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedSame, [d compareWithCallNumber:c]);

        XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:c]);

        XCTAssertEqual(BibClassificationOrderedDescending, [c compareWithCallNumber:a]);
        XCTAssertEqual(BibClassificationOrderedDescending, [d compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedDescending, [c compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedDescending, [d compareWithCallNumber:a]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q76"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.C65"];
        BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];

        XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [c compareWithCallNumber:e]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:e]);

        XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedDescending, [c compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedDescending, [c compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedAscending, [d compareWithCallNumber:c]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR18"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"DR1879.5 1988"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"DR1879.5"];

        XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [d compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:d]);

        XCTAssertEqual(BibClassificationOrderedAscending, [b compareWithCallNumber:a]);
        XCTAssertEqual(BibClassificationOrderedAscending, [b compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedAscending, [b compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedDescending, [c compareWithCallNumber:d]);
    }
    {
        BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46"];
        BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46"];
        BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46 1908"];
        BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46 1908"];
        BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th"];

        XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [e compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedSpecifying, [e compareWithCallNumber:d]);

        XCTAssertEqual(BibClassificationOrderedDescending, [b compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedAscending, [c compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedAscending, [c compareWithCallNumber:d]);
        XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
        XCTAssertEqual(BibClassificationOrderedDescending, [b compareWithCallNumber:a]);
        XCTAssertEqual(BibClassificationOrderedDescending, [d compareWithCallNumber:c]);
        XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:e]);
        XCTAssertEqual(BibClassificationOrderedDescending, [e compareWithCallNumber:a]);
    }
}

@end
