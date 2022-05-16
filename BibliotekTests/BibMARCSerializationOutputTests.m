//
//  BibMARCSerializationOutputTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 4/26/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibMARCSerializationOutputTests : XCTestCase

@end

@implementation BibMARCSerializationOutputTests

- (NSData *)dataForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"marc8"];
    return [NSData dataWithContentsOfFile:path];
}

- (BibRecord *)classificationRecord
{
    NSData *const data = [self dataForRecordNamed:@"ClassificationRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCSerialization recordsFromData:data error:&error];
    XCTAssertNotNil(records.firstObject);
    XCTAssertNil(error);
    return records.firstObject;
}

- (BibRecord *)bibliographicRecord
{
    NSData *const data = [self dataForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCSerialization recordsFromData:data error:&error];
    XCTAssertNotNil(records.firstObject);
    XCTAssertNil(error);
    return records.firstObject;
}

#pragma mark -

- (void)testWriteClassificationRecordToData {
    BibRecord *const readRecord = [self classificationRecord];

    NSError *error = nil;
    NSData *const data = [BibMARCSerialization dataWithRecord:readRecord error:&error];
    XCTAssertGreaterThan(data.length, 0);
    XCTAssertNotNil(data);
    XCTAssertNil(error);

    BibRecord *const rereadRecord = [[BibMARCSerialization recordsFromData:data error:&error] firstObject];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

- (void)testWriteClassificationRecordToOutputStream {
    BibRecord *const readRecord = [self classificationRecord];

    NSError *error = nil;
    NSOutputStream *const outputStream = [[NSOutputStream alloc] initToMemory];
    [outputStream open];
    XCTAssertTrue([BibMARCSerialization writeRecord:readRecord toStream:outputStream error:&error]);
    [outputStream close];
    NSData *const data = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertGreaterThan(data.length, 0);
    XCTAssertNotNil(data);
    XCTAssertNil(error);

    BibRecord *const rereadRecord = [[BibMARCSerialization recordsFromData:data error:&error] firstObject];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

- (void)testWriteBibliographicRecordToData {
    BibRecord *const readRecord = [self bibliographicRecord];

    NSError *error = nil;
    NSData *const data = [BibMARCSerialization dataWithRecord:readRecord error:&error];
    XCTAssertGreaterThan(data.length, 0);
    XCTAssertNotNil(data);
    XCTAssertNil(error);

    BibRecord *const rereadRecord = [[BibMARCSerialization recordsFromData:data error:&error] firstObject];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

- (void)testWriteBibliographicRecordToOutputStream {
    BibRecord *const readRecord = [self bibliographicRecord];

    NSError *error = nil;
    NSOutputStream *const outputStream = [[NSOutputStream alloc] initToMemory];
    [outputStream open];
    XCTAssertTrue([BibMARCSerialization writeRecord:readRecord toStream:outputStream error:&error]);
    [outputStream close];
    NSData *const data = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertGreaterThan(data.length, 0);
    XCTAssertNotNil(data);
    XCTAssertNil(error);

    BibRecord *const rereadRecord = [[BibMARCSerialization recordsFromData:data error:&error] firstObject];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

@end
