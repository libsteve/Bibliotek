//
//  BibInputStreamTests.m
//  BibliotekTests
//
//  Created by Steve Brunwasser on 7/25/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibInputStream.h"

@interface BibInputStreamTests : XCTestCase

@end

@implementation BibInputStreamTests

- (void)testPeekBytesMaxLength {
    uint8_t bytes[] = "000";
    NSUInteger const bytesLength = sizeof(bytes) - 1;
    uint8_t buffer[10] = { 0 };
    NSUInteger const bufferLength = sizeof(buffer);
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:bytes length:bytesLength freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSInteger const result = [inputStream peekBytes:buffer maxLength:bufferLength];
        XCTAssertNotEqual(result, NSNotFound);
        XCTAssertNotEqual(result, bufferLength);
        XCTAssertEqual(result, bytesLength);
        XCTAssertTrue(memcmp(bytes, buffer, bytesLength) == 0);
        XCTAssertNotEqual([inputStream streamStatus], NSStreamStatusAtEnd);
    }
    {
        NSInteger const result = [inputStream readBytes:buffer maxLength:bufferLength];
        XCTAssertNotEqual(result, NSNotFound);
        XCTAssertNotEqual(result, bufferLength);
        XCTAssertEqual(result, bytesLength);
        XCTAssertTrue(memcmp(bytes, buffer, bytesLength) == 0);
        XCTAssertEqual([inputStream streamStatus], NSStreamStatusAtEnd);
    }
}

- (void)testReadBytesMaxLength {
    uint8_t bytes[] = "000";
    NSUInteger const bytesLength = sizeof(bytes) - 1;
    uint8_t buffer[10] = { 0 };
    NSUInteger const bufferLength = sizeof(buffer);
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:bytes length:bytesLength freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSInteger const result = [inputStream readBytes:buffer maxLength:bufferLength];
        XCTAssertNotEqual(result, NSNotFound);
        XCTAssertNotEqual(result, bufferLength);
        XCTAssertEqual(result, bytesLength);
        XCTAssertTrue(memcmp(bytes, buffer, bytesLength) == 0);
        XCTAssertEqual([inputStream streamStatus], NSStreamStatusAtEnd);
    }
}

- (void)testPeekBytesLengthError {
    uint8_t bytes[] = "000";
    NSUInteger const bytesLength = sizeof(bytes) - 1;
    uint8_t buffer[10] = { 0 };
    NSUInteger const bufferLength = sizeof(buffer);
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:bytes length:bytesLength freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSError *error = nil;
        BOOL const result = [inputStream peekBytes:buffer length:bufferLength error:&error];
        XCTAssertNotNil(error);
        XCTAssertFalse(result);
        XCTAssertEqualObjects([error domain], BibInputStreamErrorDomain);
        XCTAssertEqual([error code], BibInputStreamEndOfStreamError);

        XCTAssertNotEqual([inputStream streamStatus], NSStreamStatusError);
        XCTAssertNil([inputStream streamError]);
    }
    {
        NSError *error = nil;
        NSInteger const result = [inputStream readBytes:buffer length:bytesLength error:&error];
        XCTAssertNil(error);
        XCTAssertTrue(result);
        XCTAssertTrue(memcmp(bytes, buffer, bytesLength) == 0);

        XCTAssertEqual([inputStream streamStatus], NSStreamStatusAtEnd);
        XCTAssertNotEqual([inputStream streamStatus], NSStreamStatusError);
        XCTAssertNil([inputStream streamError]);
    }
}

- (void)testReadBytesLengthError {
    uint8_t bytes[] = "000";
    NSUInteger const bytesLength = sizeof(bytes) - 1;
    uint8_t buffer[10] = { 0 };
    NSUInteger const bufferLength = sizeof(buffer);
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:bytes length:bytesLength freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSError *error = nil;
        BOOL const value = [inputStream readBytes:buffer length:bufferLength error:&error];
        XCTAssertNotNil(error);
        XCTAssertFalse(value);
        XCTAssertEqualObjects([error domain], BibInputStreamErrorDomain);
        XCTAssertEqual([error code], BibInputStreamEndOfStreamError);

        XCTAssertEqual([inputStream streamStatus], NSStreamStatusError);
        XCTAssertNotNil([inputStream streamError]);
        XCTAssertEqual([inputStream streamError], error);
    }
}

- (void)testReadUnsignedInteger {
    uint8_t bytes[] = "0001234";
    NSUInteger const length = sizeof(bytes) - 1;
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:bytes length:length freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSError *error = nil;
        NSUInteger const value = [inputStream readUnsignedIntegerWithLength:length error:&error];
        XCTAssertNil(error);
        XCTAssertEqual(value, 1234);
        XCTAssertNotEqual(value, NSNotFound);
    }
}

- (void)testReadUnsignedIntegerDoesFail {
    uint8_t bytes[] = "A001234";
    NSUInteger const length = sizeof(bytes) - 1;
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:bytes length:length freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSError *error = nil;
        NSUInteger const value = [inputStream readUnsignedIntegerWithLength:length error:&error];
        XCTAssertNotNil(error);
        XCTAssertEqual(value, NSNotFound);
        XCTAssertNotEqual(value, 1234);
        XCTAssertNotEqual(value, 0xA001234);
        XCTAssertEqualObjects([error domain], BibInputStreamErrorDomain);
        XCTAssertEqual([error code], BibInputStreamMalformedDataError);
        XCTAssertEqual([inputStream streamStatus], NSStreamStatusError);
        XCTAssertNotNil([inputStream streamError]);
        XCTAssertEqualObjects([inputStream streamError], error);
    }
}

- (void)testReadStringWithBibUTF8Encoding {
    uint8_t utf8String[] = "This is a string of bytes \xF0\x9F\x98\x8A";
    NSUInteger const length = sizeof(utf8String) - 1;
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:utf8String length:length freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSError *error = nil;
        NSString *const value = [inputStream readStringWithLength:length bibEncoding:BibUTF8Encoding error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(value);
        XCTAssertEqualObjects(value, @"This is a string of bytes \xF0\x9F\x98\x8A");
    }
}

- (void)testReadStringWithBibMARC8Encoding {
    // https://www.loc.gov/marc/specifications/speccharucs.html
    uint8_t marc8String[] = "\xC1"; // Small script l
    NSUInteger const length = sizeof(marc8String) - 1;
    NSData *const data = [[NSData alloc] initWithBytesNoCopy:marc8String length:length freeWhenDone:NO];
    BibInputStream *const inputStream = [[[BibInputStream alloc] initWithData:data] open];
    {
        NSError *error = nil;
        NSString *const value = [inputStream readStringWithLength:length bibEncoding:BibMARC8Encoding error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(value);
        XCTAssertEqualObjects(value, [NSString stringWithUTF8String:"\xE2\x84\x93"]);
    }
}

@end
