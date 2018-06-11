//
//  BibClassification.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Classification {
    public static func ~= (lhs: Classification, rhs: Classification) -> Bool {
        return lhs.isSimilar(to: rhs)
    }
}
