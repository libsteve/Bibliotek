//
//  BibMARCOutputStreamTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 4/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibMARCOutputStreamTests : XCTestCase

@end

@implementation BibMARCOutputStreamTests

- (BibMARCInputStream *)inputStreamForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"marc8"];
    return [[BibMARCInputStream inputStreamWithFileAtPath:path] open];
}

- (BibRecord *)classificationRecord
{
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"ClassificationRecord"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNotNil(record);
    XCTAssertNil(error);
    return record;
}

- (BibRecord *)bibliographicRecord
{
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNotNil(record);
    XCTAssertNil(error);
    return record;
}

#pragma mark -

- (void)testWriteClassificationRecord {
    BibRecord *const readRecord = [self classificationRecord];

    NSError *error = nil;
    BibMARCOutputStream *const outputStream = [[BibMARCOutputStream outputStreamToMemory] open];
    XCTAssertTrue([outputStream writeRecord:readRecord error:&error]);
    [outputStream close];
    XCTAssertGreaterThan(outputStream.data.length, 0);
    XCTAssertNotNil(outputStream.data);
    XCTAssertNil(error);

    BibMARCInputStream *const inputStream = [[BibMARCInputStream inputStreamWithData:outputStream.data] open];
    BibRecord *const rereadRecord = [inputStream readRecord:&error];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

- (void)testWriteBibliographicRecord {
    BibRecord *const readRecord = [self bibliographicRecord];

    NSError *error = nil;
    BibMARCOutputStream *const outputStream = [[BibMARCOutputStream outputStreamToMemory] open];
    XCTAssertTrue([outputStream writeRecord:readRecord error:&error]);
    [outputStream close];
    XCTAssertGreaterThan(outputStream.data.length, 0);
    XCTAssertNotNil(outputStream.data);
    XCTAssertNil(error);

    BibMARCInputStream *const inputStream = [[BibMARCInputStream inputStreamWithData:outputStream.data] open];
    BibRecord *const rereadRecord = [inputStream readRecord:&error];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

@end
