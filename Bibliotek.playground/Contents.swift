import Foundation
import Bibliotek

//: Connect to the Library of Congress's VOYAGER database.

let connection = try! Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")

//: Create a request to find books with some ISBN number.

let request = FetchRequest(keywords: ["9780385527880"], scope: .isbn)

//: Submit the request to a connection to receive results.

let records = try! connection.fetchRecords(request: request)

//: With a record, you can access information about the title, author, subject, and more.

let record = records.first!
record.title
record.subtitles
record.subjects
record.authors
record.classifications
