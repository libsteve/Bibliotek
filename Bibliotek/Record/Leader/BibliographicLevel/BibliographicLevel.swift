//
//  BibliographicLevel.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/20/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibliographicLevel: CustomStringConvertible,
                              CustomDebugStringConvertible,
                              ExpressibleByUnicodeScalarLiteral,
                              CustomPlaygroundDisplayConvertible {
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        precondition(value.isASCII)
        guard let level = Self(rawValue: CChar(truncatingIfNeeded: value.value)) else {
            preconditionFailure()
        }
        self = level
    }

    public var description: String {
        __BibBibliographicLevelDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
