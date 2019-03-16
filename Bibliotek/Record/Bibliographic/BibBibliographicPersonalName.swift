//
//  BibBibliographicPersonalName.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibliographicPersonalName: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let contents = [name, numeration, title].compactMap { $0 }
            + relationTerms + attributionQualifiers + [affiliation].compactMap { $0 }
        return contents.joined(separator: "\n")
    }
}
