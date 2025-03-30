//
//  BibliographicLevel.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/2/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

import Foundation

extension PunctuationPolicy: CustomStringConvertible,
                             CustomDebugStringConvertible,
                             ExpressibleByUnicodeScalarLiteral,
                             CustomPlaygroundDisplayConvertible {
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        precondition(value.isASCII)
        guard let policy = Self(rawValue: CChar(truncatingIfNeeded: value.value)) else {
            preconditionFailure()
        }
        self = policy
    }

    public var description: String {
        __BibPunctuationPolicyDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
