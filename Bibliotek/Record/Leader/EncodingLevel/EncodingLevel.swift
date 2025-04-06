//
//  EncodingLevel.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/5/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

import Foundation

extension EncodingLevel: CustomStringConvertible,
                         CustomDebugStringConvertible,
                         ExpressibleByIntegerLiteral,
                         ExpressibleByUnicodeScalarLiteral,
                         CustomPlaygroundDisplayConvertible {
    public init(integerLiteral value: CChar) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        precondition(value.isASCII, "EncodingLevel must be an ASCII space, number, or lowercase letter.")
        self.init(CChar(truncatingIfNeeded: value.value))
    }

    public init(_ value: CChar) {
        precondition(0x20 == value || 0x30...0x39 ~= value || 0x61...0x7A ~= value,
                     "EncodingLevel must be a space, number, or lowercase letter.")
        self = unsafeBitCast(value, to: EncodingLevel.self)
    }

    public init?(rawValue: CChar) {
        guard 0x20 == rawValue
                || 0x30...0x39 ~= rawValue
                || 0x61...0x7A ~= rawValue else {
            return nil
        }
        self = unsafeBitCast(rawValue, to: EncodingLevel.self)
    }

    public var description: String {
        "\(Unicode.Scalar(UInt8(self.rawValue)))"
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(self)\")"
    }

    public var playgroundDescription: Any {
        self.description
    }
}

extension EncodingLevel {
    public var bibliographic: BibliographicEncodingLevel {
        BibliographicEncodingLevel(rawValue: self)! // This always succeeds
    }

    public var authority: AuthorityEncodingLevel {
        AuthorityEncodingLevel(rawValue: self)! // This always succeeds
    }

    public var holdings: HoldingsEncodingLevel {
        HoldingsEncodingLevel(rawValue: self)! // This always succeeds
    }

    public var classification: ClassificationEncodingLevel {
        ClassificationEncodingLevel(rawValue: self)! // This always succeeds
    }
}

// MARK: - Bibliographic

extension BibliographicEncodingLevel: CustomStringConvertible,
                                      CustomDebugStringConvertible,
                                      CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibBibliographicEncodingLevelDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(rawValue)\"): \(self)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}

// MARK: - Authority

extension AuthorityEncodingLevel: CustomStringConvertible,
                                  CustomDebugStringConvertible,
                                  CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibAuthorityEncodingLevelDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(rawValue)\"): \(self)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}

// MARK: - Holdings

extension HoldingsEncodingLevel: CustomStringConvertible,
                                 CustomDebugStringConvertible,
                                 CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibHoldingsEncodingLevelDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(rawValue)\"): \(self)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}

// MARK: - Classification

extension ClassificationEncodingLevel: CustomStringConvertible,
                                       CustomDebugStringConvertible,
                                       CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibClassificationEncodingLevelDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(rawValue)\"): \(self)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
