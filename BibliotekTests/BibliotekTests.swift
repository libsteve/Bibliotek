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

    // NOTE: The information for the following tests is real data pertaining to "In the Land of Invented Languages"—a great book—and is provided by the Library of Congress's VOYAGER database.

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
        let field = MarcRecord.Field(json: ["050" : ["ind1" : " ",
                                                     "ind2" : "0",
                                                     "subfields" : [["a" : "PM8008"],
                                                                    ["b" : ".O37 2009"]]]])!
        XCTAssertEqual(field.debugDescription, "050  0 $aPM8008$b.O37 2009")
        let classification = Classification(field: field)
        XCTAssertNotNil(classification)
        XCTAssertEqual(classification!.system, .lcc)
        XCTAssertEqual(classification!.classification, "PM8008")
        XCTAssertEqual(classification!.item, ".O37 2009")
        XCTAssertTrue(classification!.isOfficial)
    }

    func testDdcClassification() {
        let field = MarcRecord.Field(json: ["082" : ["ind1" : " ",
                                                     "ind2" : "0",
                                                     "subfields" : [["a" : "499/.99"],
                                                                    ["2" : "22"]]]])!
        XCTAssertEqual(field.debugDescription, "082  0 $222$a499/.99")
        let classification = Classification(field: field)
        XCTAssertNotNil(classification)
        XCTAssertEqual(classification!.system, .ddc)
        XCTAssertEqual(classification!.classification, "499/.99")
        XCTAssertEqual(classification!.item, "22")
        XCTAssertTrue(classification!.isOfficial)
    }

    func testTitle() {
        let rawTitle = "In the land of invented languages :"
        let rawSubtitle = "Esperanto rock stars, Klingon poets, Loglan lovers, and the mad dreamers who tried to build a perfect language /"
        let rawAuthor = "Arika Okrent."
        let field = MarcRecord.Field(json: ["245" : ["ind1" : "1",
                                                     "ind2" : "0",
                                                     "subfields" : [["a" : rawTitle],
                                                                    ["b" : rawSubtitle],
                                                                    ["c" : rawAuthor]]]])!
        XCTAssertEqual(field.debugDescription, "245 10 $aIn the land of invented languages :$bEsperanto rock stars, Klingon poets, Loglan lovers, and the mad dreamers who tried to build a perfect language /$cArika Okrent.")
        let record = MarcRecord(fields: [field])
        XCTAssertEqual(record.title, "In the land of invented languages")
        XCTAssertEqual(record.subtitles, ["Esperanto rock stars, Klingon poets, Loglan lovers, and the mad dreamers who tried to build a perfect language"])
        XCTAssertEqual(record.contributors, ["Arika Okrent"])
    }

    func testTitleFetched() {
        do {
            let c = try Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")
            let r = FetchRequest(keywords: ["9780385527880"], scope: .isbn)
            let record = (try c.fetchRecords(request: r)).first!
            XCTAssertEqual(record.title, "In the land of invented languages")
            XCTAssertEqual(record.subtitles, ["Esperanto rock stars, Klingon poets, Loglan lovers, and the mad dreamers who tried to build a perfect language"])
            XCTAssertEqual(record.contributors, ["Arika Okrent"])
        } catch {
            XCTFail("Connection could not be made. \(error)")
        }
    }

    func testAuthors() {
        let author = "Okrent, Arika."
        let field = MarcRecord.Field(json: ["100" : ["ind1" : "1",
                                                     "ind2" : " ",
                                                     "subfields" : ["a" : author]]])!
        XCTAssertEqual(field.debugDescription, "100 1  $a\(author)")
        let record = MarcRecord(fields: [field])
        XCTAssertEqual(record.authors, [author])
    }

    func testEdition() {
        let edition = "1st ed."
        let field = MarcRecord.Field(json: ["250" : ["ind1" : " ",
                                                     "ind2" : " ",
                                                     "subfields" : ["a" : edition]]])!
        XCTAssertEqual(field.debugDescription, "250    $a1st ed.")
        let record = MarcRecord(fields: [field])
        XCTAssertEqual(record.editions, [edition])
    }

    func testSubjects() {
        let subjects = ["Blissymbolics.",
                        "Esperanto.",
                        "Klingon (Artificial language).",
                        "Languages, Artificial.",
                        "Loglan (Artificial language).",
                        "Lojban (Artificial language)."]
        let fields = subjects.map {
            MarcRecord.Field(json: ["650" : ["ind1" : " ",
                                             "ind2" : "0",
                                             "subfields" : ["a" : $0]]])!
        }
        zip(subjects, fields).forEach { subject, field in
            XCTAssertEqual(field.debugDescription, "650  0 $a\(subject)")
        }
        let record = MarcRecord(fields: fields)
        XCTAssertEqual(record.subjects, subjects)
    }

    func testSummaries() {
        let summary = """
        Okrent tells the fascinating and highly entertaining history of man's enduring quest to build a better language. Peopled with charming eccentrics and exasperating megalomaniacs, the land of invented languages is a place where you can recite the Lord's Prayer in John Wilkins's Philosophical Language, say your wedding vows in Loglan, and read "Alice's Adventures in Wonderland" in Lojban--not to mention Babm, Blissymbolics, and the nearly nine hundred other invented languages featured in this language-lover's book.
        """
        let field = MarcRecord.Field(json: ["520" : ["ind1" : " ",
                                                     "ind2" : " ",
                                                     "subfields" : ["a" : summary]]])!
        XCTAssertEqual(field.debugDescription, "520    $a\(summary)")
        let record = MarcRecord(fields: [field])
        XCTAssertEqual(record.summaries, [summary])
    }
}
