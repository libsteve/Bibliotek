//
//  BibConstants.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/1/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension ConnectionError {
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

extension Connection.Event: CustomStringConvertible, Equatable, Hashable {
    public var description: String {
        return __BibConnectionEventDescription(self)
    }
}
