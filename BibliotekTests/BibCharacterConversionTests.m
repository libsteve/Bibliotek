//
//  BibCharacterConversionTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 5/24/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>
#import "BibCharacterConversion.h"

@interface BibCharacterConversionTests : XCTestCase

@end

@implementation BibCharacterConversionTests

- (void)testConversionFromMARC8_Kohali {
    char const *const marc8_string = "Koha\xF2\x6C\xE5\x69";
    bib_char_converter_t const converter = bib_char_converter_open(bib_char_encoding_utf8, bib_char_encoding_marc8);
    NSString *const utf8_string = bib_char_convert_marc8(converter, marc8_string);
    XCTAssertNotNil(utf8_string);
    XCTAssertEqualObjects(utf8_string, @"Koha\x6C\xCC\xA3i\xCC\x84");
}

- (void)testConversionFromUTF8_Kohali {
    NSString *const utf8_string = @"Koha\x6C\xCC\xA3i\xCC\x84";
    bib_char_converter_t const converter = bib_char_converter_open(bib_char_encoding_marc8, bib_char_encoding_utf8);
    char *const marc8_string = bib_char_convert_utf8(converter, utf8_string);
    XCTAssertTrue(marc8_string != NULL);
    XCTAssertEqual(0, strcmp(marc8_string, "Koha\362l\345i"));
    free(marc8_string);
}

- (void)testConversionFromMARC8_Konig {
    char const *const marc8_string = "K\xE8\x6Fnig, Josef, 1893-1974";
    bib_char_converter_t const converter = bib_char_converter_open(bib_char_encoding_utf8, bib_char_encoding_marc8);
    NSString *const utf8_string = bib_char_convert_marc8(converter, marc8_string);
    XCTAssertNotNil(utf8_string);
    XCTAssertEqualObjects(utf8_string, @"K\x6F\xCC\x88nig, Josef, 1893-1974");
}

- (void)testConversionFromUTF8_Konig {
    NSString *const utf8_string = @"K\x6F\xCC\x88nig, Josef, 1893-1974";
    bib_char_converter_t const converter = bib_char_converter_open(bib_char_encoding_marc8, bib_char_encoding_utf8);
    char *const marc8_string = bib_char_convert_utf8(converter, utf8_string);
    XCTAssertTrue(marc8_string != NULL);
    XCTAssertEqual(0, strcmp(marc8_string, "K\xE8\x6Fnig, Josef, 1893-1974"));
    free(marc8_string);
}

- (void)testConversionFromMARC8_E585_I75 {
    char const *const marc8_string = "E585.I75";
    bib_char_converter_t const converter = bib_char_converter_open(bib_char_encoding_utf8, bib_char_encoding_marc8);
    NSString *const utf8_string = bib_char_convert_marc8(converter, marc8_string);
    XCTAssertNotNil(utf8_string);
    XCTAssertEqualObjects(utf8_string, @"E585.I75");
}

- (void)testConversionFromUTF8_E585_I75 {
    NSString *const utf8_string = @"E585.I75";
    bib_char_converter_t const converter = bib_char_converter_open(bib_char_encoding_marc8, bib_char_encoding_utf8);
    char *const marc8_string = bib_char_convert_utf8(converter, utf8_string);
    XCTAssertTrue(marc8_string != NULL);
    XCTAssertEqual(0, strcmp(marc8_string, "E585.I75"));
    free(marc8_string);
}

@end
