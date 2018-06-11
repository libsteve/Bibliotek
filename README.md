Bibliotek
===

A library for interacting with libraries using the Z39.50 protocol, powered by YAZ.

Instructions
---

1. Clone the repository and all its submodules to your local machine.

        git clone --recurse-submodules https://github.com/Altece/Bibliotek.git

2. Open the Xcode project, select the `Configure` scheme, and build. 
    This will install all the necessary tools with Homebrew and build YAZ into the project's build product's directory.
    
3. Switch to the `Bibliotek` scheme to build and modify the Bibliotek library.

References
---

### Z39.50 Endpoints

- [zbrary Directory of Z39.50 and SRU Targets][zbrary]

[zbrary]: http://www.z-brary.com

### Official Specifications from the Library of Congress

- [The bib-1 Attribute Set][bib1]
- [MARC 21 Format for Bibliographic Data][marc-21]
    - [020 ISBN][marc-isbn]
    - [050 Library of Congress Classification][marc-lcc]
    - [082 Dewey Decimal Classification][marc-ddc]
    - [520 Summary][marc-summary]
- [MARCXML Schema][marcxml]
    - [Single Record Example][marcxml-example]
- [Marc 21 Character Sets][marc-characterset]


[bib1]: http://www.loc.gov/z3950/agency/bib1.html
[marc-21]: https://www.loc.gov/marc/bibliographic/
[marc-isbn]: http://www.loc.gov/marc/bibliographic/bd020.html
[marc-lcc]: http://www.loc.gov/marc/bibliographic/bd050.html
[marc-ddc]: http://www.loc.gov/marc/bibliographic/bd082.html
[marc-summary]: http://www.loc.gov/marc/bibliographic/bd520.html
[narcxml]: http://www.loc.gov/standards/marcxml/
[marcxml-example]: http://www.loc.gov/standards/marcxml/Sandburg/sandburg.xml
[marc-characterset]: https://www.loc.gov/marc/specifications/specchargeneral.html

### YAZ Documentation from IndexData

- [Z39.50 Object-Orientation Model (ZOOM)][yaz-zoom]
- [Queries with BIB-1 Attributes][yaz-bib-1]
- [PQF Query Format][yaz-pqf-format]
    - [PQF Query Examples][yaz-pqf-examples]
- [ZOOM Records][yaz-zoom-records]

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

[isbn2.py]: https://gist.github.com/toroidal-code/6415977
