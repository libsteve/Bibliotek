//
//  BibMARC21ReaderTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 7/19/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Bibliotek/Bibliotek.h>

@interface BibMARC21ReaderTests : XCTestCase

@end

@implementation BibMARC21ReaderTests

- (void)testReadRecord {
    NSBundle *const bundle = [NSBundle bundleForClass:[self class]];
    NSString *const path = [bundle pathForResource:@"record01" ofType:@"marc8"];
    BibMARC21Reader *const reader = [BibMARC21Reader readerWithFileAtPath:path];
    NSError *error = nil;
    BibRecord *const record = [reader readRecord:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
}

@end
