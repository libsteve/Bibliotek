import Foundation
import Bibliotek

//: Connect to the Library of Congress's VOYAGER database.

let connection = try! Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")

//: Create a request to find books with some ISBN number.

let request = FetchRequest(keywords: ["9780385527880"], scope: .isbn)

//: Submit the request to a connection to receive results.
let records: RecordList = {
    do {
        return try connection.fetchRecords(request: request)
    } catch {
        error
        return RecordList()
    }
}()

//: With a record, you can access information about the title, author, subject, and more.

let record = records.first as! BibliographicRecord
record.callNumbers
record.titleStatement
record.author
record.editions
record.contents
record.summaries
record.subjectHeadings
