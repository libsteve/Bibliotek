//
//  BibMARCXMLSerializationInputTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 2/25/22.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>
#import <yaz/yaz-iconv.h>

@interface BibMARCXMLSerializationInputTests : XCTestCase

@end

@implementation BibMARCXMLSerializationInputTests

- (NSInputStream *)inputStreamForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"xml"];
    NSInputStream *const inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    return inputStream;
}

- (NSData *)dataForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"xml"];
    return [NSData dataWithContentsOfFile:path];
}

#pragma mark -

- (void)testReadBibliographicRecordFromData {
    NSData *const data = [self dataForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCXMLSerialization recordsFromData:data error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(records);
    BibRecord *const record = records.firstObject;
    XCTAssertNotNil(record);
    BibFieldTag *const titleStatementFieldTag = [[BibFieldTag alloc] initWithString:@"245"];
    BibRecordField *const field = [[record allFieldsWithTag:titleStatementFieldTag] firstObject];
    XCTAssertEqualObjects([[field subfieldWithCode:@"a"] content], @"In the land of invented languages :");
    XCTAssertEqualObjects([[field subfieldWithCode:@"b"] content], @"Esperanto rock stars, Klingon poets, "
                                                                   @"Loglan lovers, and the mad dreamers "
                                                                   @"who tried to build a perfect language /");
    XCTAssertEqualObjects([[field subfieldWithCode:@"c"] content], @"Arika Okrent.");
}

- (void)testReadBibliographicRecordFromInputStream {
    NSInputStream *const inputStream = [self inputStreamForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    BibRecord *const record = [BibMARCXMLSerialization recordFromStream:inputStream error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
    BibFieldTag *const titleStatementFieldTag = [[BibFieldTag alloc] initWithString:@"245"];
    BibRecordField *const field = [[record allFieldsWithTag:titleStatementFieldTag] firstObject];
    XCTAssertEqualObjects([[field subfieldWithCode:@"a"] content], @"In the land of invented languages :");
    XCTAssertEqualObjects([[field subfieldWithCode:@"b"] content], @"Esperanto rock stars, Klingon poets, "
                                                                   @"Loglan lovers, and the mad dreamers "
                                                                   @"who tried to build a perfect language /");
    XCTAssertEqualObjects([[field subfieldWithCode:@"c"] content], @"Arika Okrent.");
}

@end
