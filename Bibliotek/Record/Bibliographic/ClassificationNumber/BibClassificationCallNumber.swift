//
//  BibClassificationCallNumber.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension LCClassificationCallNumber: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension DDClassificationCallNumber: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}
