//
//  FieldIndicator.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/20/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A metadata value assigning some semantic meaning to a data field.
///
/// Indicators are backed by an ASCII space character, an ASCII lowercase letter, or an ASCII number.
/// Indicators are genally considered "blank" or "empty" when backed by an ASCII space character, but that value
/// may also have some meaning depending on the semantic definition of the field.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
public struct FieldIndicator: RawRepresentable {
    public typealias RawValue = CChar

    /// The ASCII value of this indicator.
    public var rawValue: CChar

    /// Create an indicator with the given raw value.
    /// \param rawValue An ASCII space, lowercase letter, or number.
    /// \returns An indicator object with some semantic metadata meaning about a data field.
    /// \note This method will throw an out-of-bounds exception for invalid indicator characters.
    public init(rawValue: CChar) {
        guard FieldIndicator.validRawValues.contains(rawValue) else {
            fatalError("Invalid indicator character \(UnicodeScalar(UInt8(rawValue)))")
        }
        self.rawValue = rawValue
    }

    /// An indicator backed by an ASCII space character.
    ///
    /// "Blank" indicators generally represent the absence of an assigned value, but may also be considered ameaningful
    /// meaningful depending on the semantic definition of the field.
    public static let blank: FieldIndicator = " "

    private static let validRawValues: Set<CChar> =
        ([CChar(Character(" ").asciiValue!)] as Set)
            .union(CChar(Character("0").asciiValue!) ... CChar(Character("9").asciiValue!))
            .union(CChar(Character("a").asciiValue!) ... CChar(Character("z").asciiValue!))
}

extension FieldIndicator: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }

    public static func == (lhs: FieldIndicator, rhs: FieldIndicator) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension FieldIndicator: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(CChar.self)
        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension FieldIndicator: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = UnicodeScalar

    public init(unicodeScalarLiteral value: UnicodeScalar) {
        guard let asciiValue = Character(value).asciiValue else {
            fatalError("Invalid indicator character \(value)")
        }
        self.init(rawValue: CChar(asciiValue))
    }
}

extension FieldIndicator: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String {
        let character = Character(UnicodeScalar(UInt8(self.rawValue)))
        return (character == " ") ? "␢" : "\(character)"
    }

    public var debugDescription: String { return self.description }

    public var playgroundDescription: Any { return self.description }
}

// MARK: - Bridging

extension FieldIndicator: ReferenceConvertible {
    public typealias ReferenceType = BibFieldIndicator
}

extension FieldIndicator: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibFieldIndicator

    @_semantics("convertToObjectiveC")
    public func _bridgeToObjectiveC() -> BibFieldIndicator {
        return BibFieldIndicator(rawValue: self.rawValue)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibFieldIndicator, result: inout FieldIndicator?) -> Bool {
        result = FieldIndicator(rawValue: source.rawValue)
        return true
    }

    @_effects(readonly)
    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibFieldIndicator?) -> FieldIndicator {
        return FieldIndicator(rawValue: source!.rawValue)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFieldIndicator, result: inout FieldIndicator?) {
        result = FieldIndicator(rawValue: source.rawValue)
    }
}

extension BibFieldIndicator: RawRepresentable, ExpressibleByUnicodeScalarLiteral, CustomPlaygroundDisplayConvertible {
    public typealias UnicodeScalarLiteralType = UnicodeScalar

    public required convenience init(unicodeScalarLiteral value: UnicodeScalar) {
        guard let asciiValue = Character(value).asciiValue else {
            fatalError("Invalid indicator character \(value)")
        }
        self.init(rawValue: CChar(asciiValue))
    }

    public var playgroundDescription: Any {
        return self.description
    }
}
