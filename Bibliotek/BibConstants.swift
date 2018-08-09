//
//  BibConstants.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/1/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Connection.Error {
    public var connection: Connection {
        return errorUserInfo[BibConnectionErrorConnectionKey] as! Connection
    }

    public var event: Connection.Event? {
        return errorUserInfo[BibConnectionErrorEventKey] as? Connection.Event
    }
}

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

extension MarcRecord.FieldTag: CustomStringConvertible, ExpressibleByStringLiteral, Equatable, Hashable {
    public var description: String {
        return __BibMarcRecordFieldTagDescription(self)
    }

    public init(stringLiteral: String) {
        self.init(stringLiteral)
    }
}

extension MarcRecord.FieldIndicator: CustomStringConvertible, ExpressibleByStringLiteral, Equatable, Hashable {
    public var description: String {
        return __BibMarcRecordFieldIndicatorDescription(self)
    }

    public init(stringLiteral: String) {
        self.init(Int8(stringLiteral.utf8.first?.byteSwapped ?? 0))
    }
}

extension MarcRecord.FieldCode: CustomStringConvertible, ExpressibleByStringLiteral, Equatable, Hashable {
    public var description: String {
        return __BibMarcRecordFieldCodeDescription(self)
    }

    public init(stringLiteral: String) {
        self.init(Int8(stringLiteral.utf8.first?.byteSwapped ?? 0))
    }
}
