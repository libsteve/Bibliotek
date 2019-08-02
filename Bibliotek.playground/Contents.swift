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

extension FieldTag {
    static let isbn13: FieldTag = "020"
    static let locCallNumber: FieldTag = "050"
    static let ddcNumber: FieldTag = "082"
    static let titleStatement: FieldTag = "245"
}

extension Array where Element == ContentField {
    func first(with tag: FieldTag) -> ContentField? {
        return self.first(where: { $0.tag == tag })
    }
}

extension ContentField {
    var contentDescription: String {
        return self.subfields.map { $0.content }.joined(separator: " ")
    }
}

record.contentFields.first(with: .isbn13)!.contentDescription
record.contentFields.first(with: .locCallNumber)!.contentDescription
record.contentFields.first(with: .ddcNumber)!.contentDescription
record.contentFields.first(with: .titleStatement)!.contentDescription
