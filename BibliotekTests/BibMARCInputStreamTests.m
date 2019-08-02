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

- (void)testReadRecord01 {
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"record01"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
}

- (void)testReadRecord02 {
    BibMARCInputStream *const inputStream = [self inputStreamForRecordNamed:@"record02"];
    NSError *error = nil;
    BibRecord *const record = [inputStream readRecord:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
}

@end
