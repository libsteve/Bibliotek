//
//  BibClassComparisonTests.m
//  LCCallNumberTests
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibClassComparisonTests: XCTestCase
@end

@implementation BibClassComparisonTests

- (void)test_01_transitive_comparison {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q172.J64 2017"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.9.T48 I544 2013"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.73.J39 D83 2014"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65 A37 1986"];

    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
    XCTAssertEqual(BibClassificationOrderedDescending, [b compareWithCallNumber:c]);
    XCTAssertEqual(BibClassificationOrderedAscending, [c compareWithCallNumber:d]);
}

#pragma mark -

- (void)test_02_class_decimal_added {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.M37 M37 1988"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_02_class_decimal_removed {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.M37 M37 1988"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_02_class_decimal_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.51.M37 M37 1988"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_02_class_decimal_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"DR1879.51.M37 M37 1988"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"DR1879.5.M37 M37 1988"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

#pragma mark -

- (void)test_03_first_cutter_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 2012"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_03_first_cutter_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 2012"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_03_first_cutter_date_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 1998"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_03_first_cutter_date_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 2012"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.F67 1998"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

#pragma mark -

- (void)test_04_second_cutter_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 N46 2011"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_04_second_cutter_date_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2005"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_04_second_cutter_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 N46 2011"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_04_second_cutter_date_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2011"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PN6737.M66 V2 2005"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

#pragma mark -

- (void)test_05_01_reflective_equality {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    XCTAssertEqual(BibClassificationOrderedSame, [a compareWithCallNumber:b]);
    XCTAssertEqual(BibClassificationOrderedSame, [b compareWithCallNumber:a]);
}

- (void)test_05_02_reflective_equality {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
    XCTAssertEqual(BibClassificationOrderedSame, [a compareWithCallNumber:b]);
    XCTAssertEqual(BibClassificationOrderedSame, [b compareWithCallNumber:a]);
}

- (void)test_05_03_specifying {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:b]);
}

- (void)test_05_04_generalizing {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [b compareWithCallNumber:a]);
}

#pragma mark -

- (void)test_06_01_adding_decimal_specifies {
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:c]);
}

- (void)test_06_02_adding_cutter_specifies {
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.C65"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:d]);
}

- (void)test_06_03_adding_cutter_after_decimal_specifies {
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
    BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [c compareWithCallNumber:e]);
}

- (void)test_06_04_adding_decimal_and_cutter_specifies {
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const e = [[BibLCCallNumber alloc] initWithString:@"QA76.76.C65"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [b compareWithCallNumber:e]);
}

- (void)test_06_05_same_number_after_specified_letters_is_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"Q76"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_06_06_removing_decimal_generalizes {
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"QA76"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [c compareWithCallNumber:b]);
}

- (void)test_06_07_decimal_without_cutter_ordered_before_cutter_after_no_decimal {
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.C65"];
    XCTAssertEqual(BibClassificationOrderedDescending, [c compareWithCallNumber:d]);
}

- (void)test_06_08_cutter_after_no_decimal_ordered_before_decimal_without_cutter {
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"QA76.76"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"QA76.C65"];
    XCTAssertEqual(BibClassificationOrderedAscending, [d compareWithCallNumber:c]);
}

#pragma mark -

- (void)test_07 {
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
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [c compareWithCallNumber:d]);
}

#pragma mark -

- (void)test_08_transitivity {
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

- (void)test_08_subject_ordinal_before_cutter_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_08_subject_ordinal_before_cutter_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th .K46"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_08_subject_ordinal_specifying {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:b]);
}

- (void)test_08_subject_ordinal_generalizing {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 15th"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [b compareWithCallNumber:a]);
}

- (void)test_08_cutter_date_specifying {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46 1908"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:b]);
}

- (void)test_08_cutter_date_generalizing {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"KF4558 .K46 1908"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [b compareWithCallNumber:a]);
}

#pragma mark -

- (void)test_09_1_supplement_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_09_1_supplement_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_09_2_supplement_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_09_2_supplement_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 2"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_09_3_supplement_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_09_3_supplement_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl. 3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"PE1574.L37 1998 Suppl."];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

#pragma mark -

- (void)test_10 {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8.P3"];
    BibLCCallNumber *const c = [[BibLCCallNumber alloc] initWithString:@"BX873 1864-1865"];
    BibLCCallNumber *const d = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [a compareWithCallNumber:d]);
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [b compareWithCallNumber:d]);
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [a compareWithCallNumber:c]);
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [b compareWithCallNumber:c]);
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [d compareWithCallNumber:c]);
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
    XCTAssertEqual(BibClassificationOrderedDescending, [b compareWithCallNumber:a]);
    XCTAssertEqual(BibClassificationOrderedSpecifying, [d compareWithCallNumber:a]);
    XCTAssertEqual(BibClassificationOrderedSpecifying, [d compareWithCallNumber:b]);
    XCTAssertEqual(BibClassificationOrderedSpecifying, [c compareWithCallNumber:a]);
    XCTAssertEqual(BibClassificationOrderedSpecifying, [c compareWithCallNumber:b]);
    XCTAssertEqual(BibClassificationOrderedSpecifying, [c compareWithCallNumber:d]);
}

- (void)test_10_year_month_day_ascending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8.P3"];
    XCTAssertEqual(BibClassificationOrderedAscending, [a compareWithCallNumber:b]);
}

- (void)test_10_year_month_day_descending {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Dec. 8.P3"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    XCTAssertEqual(BibClassificationOrderedDescending, [a compareWithCallNumber:b]);
}

- (void)test_10_date_span_specifying {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864-1865"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:b]);
}

- (void)test_10_year_specifying {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:b]);
}

- (void)test_10_date_span_generalizing {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864-1865"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [b compareWithCallNumber:a]);
}

- (void)test_10_year_generalizing {
    BibLCCallNumber *const a = [[BibLCCallNumber alloc] initWithString:@"BX873 1864"];
    BibLCCallNumber *const b = [[BibLCCallNumber alloc] initWithString:@"BX873 1864, Jul. 8.P3"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:b]);
}

#pragma mark -

- (void)test_11_AC_class_letter_specifying {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ac = [[BibLCCallNumber alloc] initWithString:@"AC"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:ac]);
}

- (void)test_11_AC_class_letter_generalizing {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ac = [[BibLCCallNumber alloc] initWithString:@"AC"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ac compareWithCallNumber:a]);
}

- (void)test_11_AE_class_letter_specifying {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ae = [[BibLCCallNumber alloc] initWithString:@"AE"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:ae]);
}

- (void)test_11_AE_class_letter_generalizing {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ae = [[BibLCCallNumber alloc] initWithString:@"AE"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ae compareWithCallNumber:a]);
}

- (void)test_11_AG_class_letter_specifying {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ag = [[BibLCCallNumber alloc] initWithString:@"AG"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:ag]);
}

- (void)test_11_AG_class_letter_generalizing {
    BibLCCallNumber *const a  = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ag = [[BibLCCallNumber alloc] initWithString:@"AG"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ag compareWithCallNumber:a]);
}

- (void)test_11_AC_class_number_specifying {
    BibLCCallNumber *const ac  = [[BibLCCallNumber alloc] initWithString:@"AC"];
    BibLCCallNumber *const ac1 = [[BibLCCallNumber alloc] initWithString:@"AC165.5.G45"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [ac compareWithCallNumber:ac1]);
}

- (void)test_11_AC_class_number_generalizing {
    BibLCCallNumber *const ac  = [[BibLCCallNumber alloc] initWithString:@"AC"];
    BibLCCallNumber *const ac1 = [[BibLCCallNumber alloc] initWithString:@"AC165.5.G45"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ac1 compareWithCallNumber:ac]);
}

- (void)test_11_AE_class_number_specifying {
    BibLCCallNumber *const ae  = [[BibLCCallNumber alloc] initWithString:@"AE"];
    BibLCCallNumber *const ae3 = [[BibLCCallNumber alloc] initWithString:@"AE35.79"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [ae compareWithCallNumber:ae3]);
}

- (void)test_11_AE_class_number_generalizing {
    BibLCCallNumber *const ae  = [[BibLCCallNumber alloc] initWithString:@"AE"];
    BibLCCallNumber *const ae3 = [[BibLCCallNumber alloc] initWithString:@"AE35.79"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ae3 compareWithCallNumber:ae]);
}

- (void)test_11_AG_class_number_specifying {
    BibLCCallNumber *const ag  = [[BibLCCallNumber alloc] initWithString:@"AG"];
    BibLCCallNumber *const ag3 = [[BibLCCallNumber alloc] initWithString:@"AG35.783"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [ag compareWithCallNumber:ag3]);
}

- (void)test_11_AG_class_number_generalizing {
    BibLCCallNumber *const ag  = [[BibLCCallNumber alloc] initWithString:@"AG"];
    BibLCCallNumber *const ag3 = [[BibLCCallNumber alloc] initWithString:@"AG35.783"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ag3 compareWithCallNumber:ag]);
}

- (void)test_11_AC_class_transitive_specifying {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ac1 = [[BibLCCallNumber alloc] initWithString:@"AC165.5.G45"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:ac1]);
}

- (void)test_11_AC_class_transitive_generalizing {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ac1 = [[BibLCCallNumber alloc] initWithString:@"AC165.5.G45"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ac1 compareWithCallNumber:a]);
}

- (void)test_11_AE_class_transitive_specifying {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ae3 = [[BibLCCallNumber alloc] initWithString:@"AE35.79"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:ae3]);
}

- (void)test_11_AE_class_transitive_generalizing {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ae3 = [[BibLCCallNumber alloc] initWithString:@"AE35.79"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ae3 compareWithCallNumber:a]);
}

- (void)test_11_AG_class_transitive_specifying {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ag3 = [[BibLCCallNumber alloc] initWithString:@"AG35.783"];
    XCTAssertEqual(BibClassificationOrderedSpecifying, [a compareWithCallNumber:ag3]);
}

- (void)test_11_AG_class_transitive_generalizing {
    BibLCCallNumber *const a   = [[BibLCCallNumber alloc] initWithString:@"A"];
    BibLCCallNumber *const ag3 = [[BibLCCallNumber alloc] initWithString:@"AG35.783"];
    XCTAssertEqual(BibClassificationOrderedGeneralizing, [ag3 compareWithCallNumber:a]);
}

@end

