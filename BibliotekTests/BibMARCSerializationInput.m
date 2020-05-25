//
//  BibMARCSerializationInput.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 4/26/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>
#import <yaz/yaz-iconv.h>

@interface BibMARCSerializationInput : XCTestCase

@end

@implementation BibMARCSerializationInput

- (NSInputStream *)inputStreamForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"marc8"];
    NSInputStream *const inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    return inputStream;
}

- (NSData *)dataForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"marc8"];
    return [NSData dataWithContentsOfFile:path];
}

#pragma mark -

- (void)testReadClassificationRecordFromData {
    NSData *const data = [self dataForRecordNamed:@"ClassificationRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCSerialization recordsFromData:data error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(records);
    BibRecord *const record = records.firstObject;
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

- (void)testReadClassificationRecordFromInputStream {
    NSInputStream *const inputStream = [self inputStreamForRecordNamed:@"ClassificationRecord"];
    NSError *error = nil;
    BibRecord *const record = [BibMARCSerialization recordFromStream:inputStream error:&error];
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

- (void)testReadBibliographicRecordFromData {
    NSData *const data = [self dataForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCSerialization recordsFromData:data error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(records);
    BibRecord *const record = records.firstObject;
    XCTAssertNotNil(record);
    BibFieldTag *const titleStatementFieldTag = [[BibFieldTag alloc] initWithString:@"245"];
    BibContentField *const field = [[record contentFieldsWithTag:titleStatementFieldTag] firstObject];
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"a"] content], @"In the land of invented languages :");
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"b"] content], @"Esperanto rock stars, Klingon poets, "
                                                                        @"Loglan lovers, and the mad dreamers "
                                                                        @"who tried to build a perfect language /");
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"c"] content], @"Arika Okrent.");
}

- (void)testReadBibliographicRecordFromInputStream {
    NSInputStream *const inputStream = [self inputStreamForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    BibRecord *const record = [BibMARCSerialization recordFromStream:inputStream error:&error];
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

#pragma mark -

- (void)testConversionFromMARC8Encoding1 {
    NSInputStream *const inputStream = [self inputStreamForRecordNamed:@"MARC8Record1"];
    NSError *error = nil;
    BibRecord *const record = [BibMARCSerialization recordFromStream:inputStream error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
    BibFieldTag *const classificationFieldNumberTag = [[BibFieldTag alloc] initWithString:@"153"];
    BibContentField *const field = [[record contentFieldsWithTag:classificationFieldNumberTag] firstObject];
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"j"] content], @"K\x6F\xCC\x88nig, Josef, 1893-1974");
}

- (void)testConversionFromMARC8Encoding2 {
    NSInputStream *const inputStream = [self inputStreamForRecordNamed:@"MARC8Record2"];
    NSError *error = nil;
    BibRecord *const record = [BibMARCSerialization recordFromStream:inputStream error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
    BibFieldTag *const classificationFieldNumberTag = [[BibFieldTag alloc] initWithString:@"153"];
    BibContentField *const field = [[record contentFieldsWithTag:classificationFieldNumberTag] firstObject];
    XCTAssertEqualObjects([[field firstSubfieldWithCode:@"a"] content], @"E585.I75");
}



@end
