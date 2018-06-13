//
//  BibRecord.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/12/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return fields.map { $0.description }
    }
}
