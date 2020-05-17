import Foundation
import Bibliotek

//: Connect to the Library of Congress's VOYAGER database.

let lc = Connection.Endpoint(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")
let sfpl = Connection.Endpoint(host: "sflib1.sfpl.org", port: 210, database: "INNOPAC")

let connection = try! Connection(endpoint: lc)

//: Create a request to find books with some ISBN number.

let request = FetchRequest(keywords: ["9780385527880"], scope: .isbn)

//: Submit the request to a connection to receive results.
let records: RecordList = try! connection.fetchRecords(request: request)

//: With a record, you can access information about the title, author, subject, and more.

let record = records.first!

extension FieldPath {
    static let isbn13 = FieldPath(tag: "020", code: "a")
    static let locCallNumber = FieldPath(tag: "050")
    static let dccNumber = FieldPath(tag: "082", code: "a")
    static let titleStatement = FieldPath(tag: "245")
}

record.content(with: .isbn13)
record.content(with: .locCallNumber)
record.content(with: .dccNumber)
record.content(with: .titleStatement)
