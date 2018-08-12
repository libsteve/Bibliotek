//
//  BibClassificationSystem.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension ClassificationSystem {
    public static func == (lhs: ClassificationSystem, rhs: ClassificationSystem) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}

extension ClassificationSystem: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}
