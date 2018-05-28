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
    func testBanana() {
        do {
            let o = Options()
            o.databaseName = "VOYAGER"
            let c = try Connection(host: "z3950.loc.gov", port: 7090, options: o)
            let r = FetchRequest(query: "@attr 1=4 computer", notation: QueryNotation.pqf)
            let rs = c.fetchRecords(request: r)
            XCTAssert(rs.count > 0)
            rs.forEach { r in
                let d = r.jsonData
                XCTAssertNotNil(d)
                let s = String(data: d!, encoding: .utf8)!
                print(s)
            }
        } catch {
            XCTFail("Connection could not be made. \(error)")
        }
    }
}
