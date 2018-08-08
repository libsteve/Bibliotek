//
//  BibConnectionEndpoint.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Connection.Endpoint: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}
