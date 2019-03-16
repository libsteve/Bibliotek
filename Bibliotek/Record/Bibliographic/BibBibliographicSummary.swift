//
//  BibBibliographicSummary.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibliographicSummary: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let segments = [content, detail, source].compactMap { $0 } + urls.map { $0.description }
        return segments.joined(separator: "\n")
    }
}
