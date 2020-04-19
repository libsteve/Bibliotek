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
    BibContentField *const field = [[record contentFieldsWithTag:titleStatementFieldTag] firstObject];
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"a"] content], @"KJV5461.3");
    NSUInteger const firstIndex = [[field subfields] indexOfObject:[field firstSubfieldWithCode:@"h"]];
    XCTAssertEqualObjects([[[field subfields] objectAtIndex:firstIndex] content], @"Law of France");
    XCTAssertEqualObjects([[[field subfields] objectAtIndex:firstIndex + 1] content],
                          @"Cultural affairs. L'action culturelle des pouvoirs publics");
    XCTAssertEqualObjects([[[field subfields] objectAtIndex:firstIndex + 2] content], @"Education");
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"j"] content], @"Private schools");
}

- (void)testReadBibliographicRecord {
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
    BibFieldTag *const titleStatementFieldTag = [[BibFieldTag alloc] initWithString:@"245"];
    BibContentField *const field = [[record contentFieldsWithTag:titleStatementFieldTag] firstObject];
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"a"] content], @"In the land of invented languages :");
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"b"] content], @"Esperanto rock stars, Klingon poets, "
                                                                        @"Loglan lovers, and the mad dreamers "
                                                                        @"who tried to build a perfect language /");
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"c"] content], @"Arika Okrent.");

}

@end
