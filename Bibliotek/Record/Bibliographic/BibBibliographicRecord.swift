//
//  BibBibliographicRecord.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/17/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibliographicTitleStatement: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension BibliographicPersonalName: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let contents = [name, numeration, title].compactMap { $0 }
            + relationTerms + attributionQualifiers + [affiliation].compactMap { $0 }
        return contents.joined(separator: "\n")
    }
}

extension BibliographicSummary: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let segments = [content, detail, source].compactMap { $0 } + urls.map { $0.description }
        return segments.joined(separator: "\n")
    }
}

extension BibliographicContents: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return (note as NSString).components(separatedBy: " -- ")
    }
}

extension BibliographicEditionStatement: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension BibliographicPublication: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension BibliographicISBN: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}
