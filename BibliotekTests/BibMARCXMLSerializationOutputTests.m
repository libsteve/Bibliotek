//
//  BibMARCXMLSerializationOutputTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 5/8/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibMARCXMLSerializationOutputTests : XCTestCase

@end

@implementation BibMARCXMLSerializationOutputTests

- (NSData *)dataForRecordNamed:(NSString *)recordName {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:recordName ofType:@"xml"];
    return [NSData dataWithContentsOfFile:path];
}

- (BibRecord *)classificationRecord
{
    NSData *const data = [self dataForRecordNamed:@"ClassificationRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCXMLSerialization recordsFromData:data error:&error];
    XCTAssertNotNil(records.firstObject);
    XCTAssertNil(error);
    return records.firstObject;
}

- (BibRecord *)bibliographicRecord
{
    NSData *const data = [self dataForRecordNamed:@"BibliographicRecord"];
    NSError *error = nil;
    NSArray<BibRecord *> *const records = [BibMARCXMLSerialization recordsFromData:data error:&error];
    XCTAssertNotNil(records.firstObject);
    XCTAssertNil(error);
    return records.firstObject;
}

#pragma mark -

- (void)testWriteClassificationRecordToData {
    BibRecord *const readRecord = [self classificationRecord];

    NSError *error = nil;
    NSData *const data = [BibMARCXMLSerialization dataWithRecord:readRecord error:&error];
    XCTAssertGreaterThan(data.length, 0);
    XCTAssertNotNil(data);
    XCTAssertNil(error);

    BibRecord *const rereadRecord = [[BibMARCXMLSerialization recordsFromData:data error:&error] firstObject];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

- (void)testWriteBibliographicRecordToData {
    BibRecord *const readRecord = [self bibliographicRecord];

    NSError *error = nil;
    NSData *const data = [BibMARCXMLSerialization dataWithRecord:readRecord error:&error];
    XCTAssertGreaterThan(data.length, 0);
    XCTAssertNotNil(data);
    XCTAssertNil(error);

    BibRecord *const rereadRecord = [[BibMARCXMLSerialization recordsFromData:data error:&error] firstObject];
    XCTAssertNotNil(rereadRecord);
    XCTAssertNil(error);

    XCTAssertEqualObjects(readRecord, rereadRecord);
}

@end
