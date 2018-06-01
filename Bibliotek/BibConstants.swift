//
//  BibConstants.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/1/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension FetchRequest.Scope: CustomStringConvertible {
    public var description: String {
        return __BibFetchRequestScopeDescription(self)
    }
}

extension FetchRequest.Structure: CustomStringConvertible {
    public var description: String {
        return __BibFetchRequestStructureDescription(self)
    }
}

extension FetchRequest.SearchStrategy: CustomStringConvertible {
    public var description: String {
        return __BibFetchRequestSearchStrategyDescription(self)
    }
}
