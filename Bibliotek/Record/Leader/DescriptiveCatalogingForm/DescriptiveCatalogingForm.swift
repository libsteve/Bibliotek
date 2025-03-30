//
//  BibliographicLevel.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/20/24.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

import Foundation

extension DescriptiveCatalogingForm: CustomStringConvertible,
                                     CustomDebugStringConvertible,
                                     ExpressibleByUnicodeScalarLiteral,
                                     CustomPlaygroundDisplayConvertible {
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        precondition(value.isASCII)
        guard let form = Self(rawValue: CChar(truncatingIfNeeded: value.value)) else {
            preconditionFailure()
        }
        self = form
    }

    public var description: String {
        __BibDescriptiveCatalogingFormDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: '\(Unicode.Scalar(UInt8(self.rawValue)))'): \(self)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
