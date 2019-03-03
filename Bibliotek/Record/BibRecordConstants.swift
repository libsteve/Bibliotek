//
//  BibRecordConstants.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.Kind: CustomStringConvertible {
    public var isClassification: Bool { return __BibRecordKindIsClassification(self) }
    public var isBibliographic: Bool { return __BibRecordKindIsBibliographic(self) }

    public var description: String { return __BibRecordKindDescription(self) }
}

extension Record.CharacterCodingScheme: CustomStringConvertible {
    public var description: String { return __BibRecordCharacterCodingSchemeDescription(self) }
}

extension EditionKind: CustomStringConvertible {
    public var description: String { return __BibEditionKindDescription(self) }
}
