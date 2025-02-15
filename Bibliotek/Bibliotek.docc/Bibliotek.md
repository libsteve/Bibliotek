# ``Bibliotek``

A Swift and Objective-C library for communicating with library databases using the Z39.50 protocol, powered by YAZ.

## Overview

```swift
import Bibliotek
```

Connect to the Library of Congress's VOYAGER database.

```swift
let connection = try! Connection(host: "z3950.loc.gov", port: 7090, database: "VOYAGER")
```

Create a request to find books with some ISBN number.

```swift
let request = FetchRequest(keywords: ["9780385527880"], scope: .isbn)
```

Submit the request to a connection to receive results.

```swift
let records = try! connection.fetchRecords(request: request)
```

With a record, you can access information about the title, author, subject, and more.

```swift
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
```

## Topics

### Records

- ``Record``
- ``BibRecord``
- ``BibMutableRecord``
- ``FieldTag``
- ``BibFieldTag``
- ``RecordField``
- ``BibRecordField``
- ``BibMutableRecordField``
- ``FieldIndicator``
- ``BibFieldIndicator``
- ``Subfield``
- ``BibSubfield``
- ``BibMutableSubfield``
- ``BibSubfieldCode``
- ``FieldPath``
- ``BibFieldPath``
- ``BibSubfieldEnumerator``

### Record Leader

- ``Leader``
- ``BibLeader``
- ``BibMutableLeader``
- ``BibRecordStatus``
- ``BibEncoding``
- ``BibBibliographicLevel``
- ``BibBibliographicControlType``
- ``BibRecordKind``
- ``BibRecordFormat``

### Library Connections

- ``BibConnection``
- ``BibConnectionEndpoint``
- ``BibMutableConnectionEndpoint``
- ``BibConnectionOptions``
- ``BibMutableConnectionOptions``
- ``BibAuthenticationMode``
- ``BibConnectionEvent``

### Record Requests

- ``BibFetchRequest``
- ``BibMutableFetchRequest``
- ``BibFetchRequestNotation``
- ``BibSortStrategy``
- ``BibFetchRequestScope``
- ``BibFetchRequestStructure``
- ``BibFetchRequestSearchStrategy``
- ``BibRecordList``

### Classifications

- ``LCCallNumber``
- ``BibLCCallNumber``
- ``BibClassificationComparisonResult``
- ``BibLCCallNumberFormatOptions``

### Serialization

- ``BibMARCSerialization``
- ``BibMARCXMLSerialization``
- ``BibRecordInputStream``
- ``BibMARCInputStream``
- ``BibMARCXMLInputStream``
- ``BibRecordOutputStream``
- ``BibMARCOutputStream``
- ``BibMARCXMLOutputStream``

### Errors

- ``ConnectionError``
- ``BibConnectionErrorCode``
- ``BibConnectionErrorDomain``

- ``SerializationError``
- ``BibSerializationErrorCode``
- ``BibSerializationErrorDomain``
- ``BibSerializationErrorCodeDescription(_:)``
