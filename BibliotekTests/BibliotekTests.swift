//
//  BibliotekTests.swift
//  BibliotekTests
//
//  Created by Steve Brunwasser on 5/26/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import XCTest
import Foundation
@testable import Bibliotek

class BibliotekTests: XCTestCase {
    func testConnectSucceeds() {
        XCTAssertNoThrow(try Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER"))
    }

    func testConnectFails() {
        XCTAssertThrowsError(try Connection(host: "beep.blork.invalidtld"))
    }

    func testFetchWord() {
        do {
            let c = try Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")
            let r = MutableFetchRequest()
            r.keywords = ["computer"]
            r.structure = .word
            r.scope = .subject
            r.strategy = .strict
            let rs = try c.fetchRecords(request: r)
            XCTAssert(rs.count > 0)
        } catch {
            XCTFail("Connection could not be made. \(error)")
        }
    }

    func testFetchIsbn() {
        do {
            let c = try Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")
            let r = MutableFetchRequest()
            r.keywords = ["9780385527880"]
            r.structure = .word
            r.scope = .isbn
            r.strategy = .strict
            let rs = try c.fetchRecords(request: r)
            XCTAssertEqual(rs.count, 1)
            let record = rs.first
            XCTAssertNotNil(record)
            XCTAssertEqual(record!.isbn13!, r.keywords.first!)
        } catch {
            XCTFail("Connection could not be made. \(error)")
        }
    }

    func testLccClassification() {
        let field = Record.Field(json: ["050" : ["ind1" : " ",
                                                 "ind2" : "0",
                                                 "subfields" : [["a" : "1010101"],
                                                                ["b" : "ABABABA"]]]])!
        XCTAssertEqual(field.debugDescription, "050  0 $a1010101$bABABABA")
        let classification = Classification(field: field)
        XCTAssertNotNil(classification)
        XCTAssertEqual(classification!.system, .lcc)
        XCTAssertEqual(classification!.classification, "1010101")
        XCTAssertEqual(classification!.item, "ABABABA")
        XCTAssertTrue(classification!.isOfficial)
    }

    func testDdcClassification() {
        let field = Record.Field(json: ["082" : ["ind1" : " ",
                                                 "ind2" : "0",
                                                 "subfields" : [["a" : "1010101"],
                                                                ["b" : "ABABABA"]]]])!
        XCTAssertEqual(field.debugDescription, "082  0 $a1010101$bABABABA")
        let classification = Classification(field: field)
        XCTAssertNotNil(classification)
        XCTAssertEqual(classification!.system, .ddc)
        XCTAssertEqual(classification!.classification, "1010101")
        XCTAssertEqual(classification!.item, "ABABABA")
        XCTAssertTrue(classification!.isOfficial)
    }
}
