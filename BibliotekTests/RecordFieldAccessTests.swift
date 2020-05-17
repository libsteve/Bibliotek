//
//  RecordFieldAccessTests.swift
//  BibliotekTests
//
//  Created by Steve Brunwasser on 5/10/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import XCTest
import Foundation
@testable import Bibliotek

class RecordFieldAccessTests: XCTestCase {
    var record: Record!

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: RecordFieldAccessTests.self)
        let url = bundle.url(forResource: "BibliographicRecord", withExtension: "marc8")!
        self.record = try! MARCSerialization.records(from: try! Data(contentsOf: url)).first
    }

    func testControlFieldAccessControlNumber() {
        let indexPaths = self.record.indexPaths(for: FieldPath(tag: "001"))
        XCTAssertEqual(indexPaths.count, 1, "Expected one control number field")
        XCTAssertEqual(indexPaths.first!.count, 1, "Index paths for fields should have only one index")

        let fields = indexPaths.compactMap(self.record.controlField(at:))
        XCTAssertEqual(fields.count, indexPaths.count, "Expected a control field for all index paths")
        XCTAssertEqual(fields.first!.value, "15434749")

        let fieldContents = indexPaths.map(self.record.content(at:))
        XCTAssertEqual(fieldContents.count, indexPaths.count, "Expected content for all index paths")
        XCTAssertEqual(fieldContents.first, "15434749")
    }

    func testContentFieldAccessISBN() {
        let indexPaths = self.record.indexPaths(for: FieldPath(tag: "020"))
        XCTAssertEqual(indexPaths.count, 2, "Expected an ISBN 10 field and an ISBN 13 field")
        XCTAssertEqual(indexPaths.first!.count, 1, "Index paths for fields should have only one index")
        XCTAssertEqual(indexPaths.last!.count, 1, "Index paths for fields should have only one index")

        let fields = indexPaths.compactMap(self.record.contentField(at:))
        XCTAssertEqual(fields.count, indexPaths.count, "Expected a content field for all index paths")
        XCTAssertEqual(fields.first!.subfields.map(\.content).joined(), "9780385527880")
        XCTAssertEqual(fields.last!.subfields.map(\.content).joined(), "0385527888")

        let fieldContents = indexPaths.map(self.record.content(at:))
        XCTAssertEqual(fieldContents.count, indexPaths.count, "Expected content for all index paths")
        XCTAssertEqual(fieldContents.first!, "9780385527880")
        XCTAssertEqual(fieldContents.last!, "0385527888")
    }

    func testSubfieldAccessTitleStatementTitle() {
        let indexPaths = self.record.indexPaths(for: FieldPath(tag: "245", code: "a"))
        XCTAssertEqual(indexPaths.count, 1, "Expected one title subfiled in the title statement field")
        XCTAssertEqual(indexPaths.first!.count, 2, "Index paths for subfields should have two indexes")

        let subfields = indexPaths.compactMap(self.record.subfield(at:))
        XCTAssertEqual(subfields.count, indexPaths.count, "Expected a subfield for all index paths")
        XCTAssertEqual(subfields.first!.content, "In the land of invented languages :")

        let subfieldContents = indexPaths.map(self.record.content(at:))
        XCTAssertEqual(subfieldContents.count, indexPaths.count, "Expected content for all index paths")
        XCTAssertEqual(subfieldContents.first!, "In the land of invented languages :")
    }
}
