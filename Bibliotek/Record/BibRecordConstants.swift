//
//  BibRecordConstants.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.Kind: CustomStringConvertible, ExpressibleByStringLiteral, Equatable {
    public var isClassification: Bool { return __BibRecordKindIsClassification(self) }
    public var isBibliographic: Bool { return __BibRecordKindIsBibliographic(self) }

    public var description: String { return __BibRecordKindDescription(self) }

    public init(stringLiteral value: String) { self.init(value) }
}

extension Record.FieldTag: CustomStringConvertible, ExpressibleByStringLiteral {
    public var description: String { return rawValue }

    public init(stringLiteral value: String) { self.init(value) }
}

extension Record.FieldIndicator: CustomStringConvertible, ExpressibleByStringLiteral {
    public var description: String { return rawValue }

    public init(stringLiteral value: String) { self.init(value) }
}

extension Record.SubfieldCode: CustomStringConvertible, ExpressibleByStringLiteral {
    public var description: String { return rawValue }

    public init(stringLiteral value: String) { self.init(value) }
}

extension Record.CharacterCodingScheme: CustomStringConvertible {
    public var description: String { return __BibRecordCharacterCodingSchemeDescription(self) }
}

extension EditionKind: CustomStringConvertible {
    public var description: String { return __BibEditionKindDescription(self) }
}
