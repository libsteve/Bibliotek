//
//  BibConstants.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/1/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension FetchRequest.Scope: CustomStringConvertible, Equatable, Hashable {
    public var description: String {
        return __BibFetchRequestScopeDescription(self)
    }
}

extension FetchRequest.Structure: CustomStringConvertible, Equatable, Hashable {
    public var description: String {
        return __BibFetchRequestStructureDescription(self)
    }
}

extension FetchRequest.SearchStrategy: CustomStringConvertible, Equatable, Hashable {
    public var description: String {
        return __BibFetchRequestSearchStrategyDescription(self)
    }
}

extension Record.FieldTag: CustomStringConvertible, ExpressibleByStringLiteral, Equatable, Hashable {
    public var description: String {
        return __BibRecordFieldTagDescription(self)
    }

    public init(stringLiteral: String) {
        self.init(stringLiteral)
    }
}

extension Record.FieldIndicator: CustomStringConvertible, ExpressibleByStringLiteral, Equatable, Hashable {
    public var description: String {
        return __BibRecordFieldIndicatorDescription(self)
    }

    public init(stringLiteral: String) {
        self.init(Int8(stringLiteral.utf8.first?.byteSwapped ?? 0))
    }
}

extension Record.FieldCode: CustomStringConvertible, ExpressibleByStringLiteral, Equatable, Hashable {
    public var description: String {
        return __BibRecordFieldCodeDescription(self)
    }

    public init(stringLiteral: String) {
        self.init(Int8(stringLiteral.utf8.first?.byteSwapped ?? 0))
    }
}

extension Classification.System: CustomStringConvertible, Equatable, Hashable {
    public var description: String {
        return __BibClassificationSystemDescription(self)
    }
}
