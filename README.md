Bibliotek
===

A Swift and Objective-C library for communicating with library databases using [the Z39.50 protocol][z3950], powered by [YAZ][yaz].

[z3950]: https://en.wikipedia.org/wiki/Z39.50
[yaz]: https://www.indexdata.com/resources/software/yaz/

Usage Example
---

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

Instructions
---

Clone the repository and all its submodules to your local machine.

        git clone https://github.com/stevebrun/Bibliotek.git

Xcode will download and build the YAZ source code as needed when building the `libyaz` target.
The `Bibliotek` target depends on `libyaz`, so this will happen automatically when building `Bibliotek`.

References
---

### Z39.50 Endpoints

- [zbrary Directory of Z39.50 and SRU Targets][zbrary]
- [Gateway to Library Catalogs][loc-gateways]
- [Library of Congress Z39.50 Server Configuration Guidelines][loc-z3950-server]

[zbrary]: http://www.z-brary.com
[loc-gateways]: https://www.loc.gov/z3950/
[loc-z3950-server]: https://www.loc.gov/z3950/lcserver.html#init

### Official Specifications from the Library of Congress

- [The bib-1 Attribute Set][bib1]
- [MARC 21 Format for Bibliographic Data][marc-21]
    - [020 ISBN][marc-isbn]
    - [050 Library of Congress Classification][marc-lcc]
    - [082 Dewey Decimal Classification][marc-ddc]
    - [245 Title Statement][marc-title]
    - [520 Summary][marc-summary]
    - [765 Synthesized Number Components][marc-number-components]
- [MARCXML Schema][marcxml]
    - [Single Record Example][marcxml-example]
- [Marc 21 Character Sets][marc-characterset]
- [International Standard Bibliographic Description][isbd]
- [Z39.50 Protocol Specification][z3950-specification]

[bib1]: http://www.loc.gov/z3950/agency/bib1.html
[marc-21]: https://www.loc.gov/marc/bibliographic/
[marc-isbn]: http://www.loc.gov/marc/bibliographic/bd020.html
[marc-lcc]: http://www.loc.gov/marc/bibliographic/bd050.html
[marc-ddc]: http://www.loc.gov/marc/bibliographic/bd082.html
[marc-title]: https://www.loc.gov/marc/bibliographic/bd245.html
[marc-summary]: http://www.loc.gov/marc/bibliographic/bd520.html
[marcxml]: http://www.loc.gov/standards/marcxml/
[marcxml-example]: http://www.loc.gov/standards/marcxml/Sandburg/sandburg.xml
[marc-characterset]: https://www.loc.gov/marc/specifications/specchargeneral.html
[marc-number-components]: http://www.loc.gov/marc/classification/cd765.html
[isbd]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
[z3950-specification]: https://www.loc.gov/z3950/agency/Z39-50-2003.pdf

### OCLC Documents

- [Segmentation Marks in Dewey Numbers][dewey-segmentation]
- [Bibliographic Formats and Standards][oclc-bib-std]
- [Z39.50 Configuration Guide for OCLC Z39.50 Cataloging][oclc-config]
- [Library of Congress Call Number Format][oclc-loc-format]

[dewey-segmentation]: https://www.oclc.org/content/dam/oclc/dewey/discussion/papers/segmentation_marks.pdf
[oclc-bib-std]: https://www.oclc.org/bibformats/en.html
[oclc-config]: https://www.oclc.org/support/services/z3950/documentation/config_guide.en.html
[oclc-loc-format]: https://www.oclc.org/bibformats/en/0xx/050.htm

### Cataloger's Reference Shelf

- [Cutter Numbers][cutter-number]
- [MARC Format Documentation and Code Lists][marc-format-code-lists]

[cutter-number]: https://www.itsmarc.com/crs/mergedProjects/cutter/cutter/definition_cutter_number_cutter.htm
[marc-format-code-lists]: https://www.itsmarc.com/crs/mergedProjects/geninfo/geninfo/marc_documentation.htm

### YAZ Documentation from IndexData

- [Z39.50 Object-Orientation Model (ZOOM)][yaz-zoom]
- [Queries with BIB-1 Attributes][yaz-bib-1]
- [PQF Query Format][yaz-pqf-format]
    - [PQF Query Examples][yaz-pqf-examples]
- [ZOOM Records][yaz-zoom-records]

- [YAZ ZOOM Timeout Option](http://lists.indexdata.dk/pipermail/yazlist/2002-November/000381.html)
- [YAZ ZOOM Timeout Option Semantics](http://lists.indexdata.dk/pipermail/net-z3950/2009-March/000886.html)

[yaz-zoom]: https://software.indexdata.com/yaz/doc/zoom.html#zoom-connection-z39.50
[yaz-pqf-format]: https://software.indexdata.com/yaz/doc/tools.html#PQF
[yaz-bib-1]: https://software.indexdata.com/zebra/doc/querymodel-rpn.html#querymodel-bib1
[yaz-pqf-examples]: https://software.indexdata.com/yaz/doc/tools.html#PQF-examples
[yaz-zoom-records]: https://software.indexdata.com/yaz/doc/zoom.records.html

### Other Specifications

- [MARC in JSON Description][marc-json]
- [JSON Schema for the MARC 21 Bibliographic Standard][marc-json-schema]
- [A proposal to serialize MARC in JSON][marc-json-proposal]

[marc-json]: https://github.com/marc4j/marc4j/wiki/MARC-in-JSON-Description
[marc-json-schema]: https://github.com/thisismattmiller/marc-json-schema
[marc-json-proposal]: https://rossfsinger.com/blog/2010/09/a-proposal-to-serialize-marc-in-json/

### Other Sources

- [Torroidal Code's isbn2.py][isbn2.py]
- [kurtraschke's parsecallno.py][parsecallno.py]
- [Wikidata page on Library of Congress Classification][wikidata]
- [025.431: The Dewey Blog][dewey-blog]
- [Documentation for the ZOOM Pearl extension][zoom-pearl]
- [Dewey Segmentation (the '/' in the dewey number)][dewey-segmentation]
- [The ``Hello World'' Zoo][hello-world-zoo]
- [A Comprehensive Approach to Algorithmic Machine Sorting of Library of Congress Call Numbers][lc-algorithmic-sorting]

[isbn2.py]: https://gist.github.com/toroidal-code/6415977
[parsecallno.py]: https://gist.github.com/kurtraschke/560162
[wikidata]: https://www.wikidata.org/wiki/Property:P1149
[dewey-blog]: http://ddc.typepad.com/025431/
[zoom-pearl]: https://metacpan.org/pod/release/MIRK/Net-Z3950-ZOOM-1.01/lib/ZOOM.pod
[dewey-segmentation]: https://ddc.typepad.com/025431/2005/06/one_segmentatio.html
[hello-world-zoo]: http://zoom.z3950.org/misc/zoo.html#11
[lc-algorithmic-sorting]: https://doi.org/10.6017/ital.v38i4.11585
