//
//  BibMARCInputStreamTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibMARCInputStreamTests : XCTestCase

@end

@implementation BibMARCInputStreamTests

- (BibMARCInputStream *)inputStreamForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"marc8"];
    return [[BibMARCInputStream inputStreamWithFileAtPath:path] open];
}

#pragma mark -

- (void)testReadClassificationRecord {
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"ClassificationRecord"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
    BibFieldTag *const titleStatementFieldTag = [[BibFieldTag alloc] initWithString:@"153"];
    BibRecordField *const field = [record fieldWithTag:titleStatementFieldTag];
    NSUInteger const indexOfSubfieldA = [field indexOfSubfieldWithCode:@"a"];
    XCTAssertNotEqual(indexOfSubfieldA, NSNotFound);
    XCTAssertEqualObjects([[field subfieldAtIndex:indexOfSubfieldA] content], @"KJV5461.3");
    NSUInteger const indexOfSubfieldH = [field indexOfSubfieldWithCode:@"h"];
    XCTAssertNotEqual(indexOfSubfieldH, NSNotFound);
    XCTAssertEqualObjects([[field subfieldAtIndex:indexOfSubfieldH] content], @"Law of France");
    XCTAssertEqualObjects([[field subfieldAtIndex:indexOfSubfieldH + 1] content],
                          @"Cultural affairs. L'action culturelle des pouvoirs publics");
    XCTAssertEqualObjects([[field subfieldAtIndex:indexOfSubfieldH + 2] content], @"Education");
    XCTAssertEqualObjects([[field subfieldWithCode:@"j"] content], @"Private schools");
}

- (void)testReadBibliographicRecord {
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
    BibFieldTag *const titleStatementFieldTag = [[BibFieldTag alloc] initWithString:@"245"];
    BibRecordField *const field = [record fieldWithTag:titleStatementFieldTag];
    XCTAssertEqualObjects([[field subfieldWithCode:@"a"] content], @"In the land of invented languages :");
    XCTAssertEqualObjects([[field subfieldWithCode:@"b"] content], @"Esperanto rock stars, Klingon poets, "
                                                                   @"Loglan lovers, and the mad dreamers "
                                                                   @"who tried to build a perfect language /");
    XCTAssertEqualObjects([[field subfieldWithCode:@"c"] content], @"Arika Okrent.");

}

@end
