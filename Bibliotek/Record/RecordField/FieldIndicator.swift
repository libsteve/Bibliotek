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
/// Indicators are generally considered "blank" or "empty" when backed by an ASCII space character, but that value
/// may also have some meaning depending on the semantic definition of the field.
///
/// More information about indicators can be found in the Variable Fields section of the Library of Congress's
/// documentation on [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/specrecstruc.html#varifields).
///
/// - note: Although only a lowercase ASCII characters and ASCII digits are valid indicators, the MARC8 formatted
///         2014 Library of Congress Classification schedule from [the MDSConnect Classification][mds-connect]
///         contains an indicator value of `')'` at offset `42507804` , so we should be gracefully handling this
///         case by assuming that any ASCII character could be provided as a valid indicator. If the LoC's schedule
///         has this indicator value, it must be valid, right‽ ¯\_(ツ)_/¯
///
/// [mds-connect]: https://loc.gov/cds/products/MDSConnect-classification.html
@frozen public struct FieldIndicator: RawRepresentable {
    public typealias RawValue = CChar

    /// The ASCII value of this indicator.
    public var rawValue: CChar

    /// Create an indicator with the given raw value.
    /// - parameter rawValue: An ASCII space, lowercase letter, or number.
    /// - throws: This method will throw an out-of-bounds exception for invalid indicator characters.
    public init(rawValue: CChar) {
        self.rawValue = rawValue
    }

    /// An indicator backed by an ASCII space character.
    ///
    /// "Blank" indicators generally represent the absence of an assigned value, but may also be considered meaningful
    /// depending on the semantic definition of the field.
    public static let blank: FieldIndicator = " "
}

extension FieldIndicator: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }

    public static func == (lhs: FieldIndicator, rhs: FieldIndicator) -> Bool {
        lhs.rawValue == rhs.rawValue
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
        self.init(rawValue: CChar(bitPattern: UInt8(ascii: value)))
    }
}

extension FieldIndicator: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String {
        let character = UnicodeScalar(UInt8(self.rawValue))
        return (character == " ") ? "␢" : "\(character)"
    }

    public var debugDescription: String { self.description }

    public var playgroundDescription: Any { self.description }
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
        FieldIndicator(rawValue: source!.rawValue)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFieldIndicator, result: inout FieldIndicator?) {
        result = FieldIndicator(rawValue: source.rawValue)
    }
}

extension BibFieldIndicator: RawRepresentable, ExpressibleByUnicodeScalarLiteral, CustomPlaygroundDisplayConvertible {
    public typealias UnicodeScalarLiteralType = UnicodeScalar

    public required convenience init(unicodeScalarLiteral value: UnicodeScalar) {
        self.init(rawValue: CChar(bitPattern: UInt8(ascii: value)))
    }

    public var playgroundDescription: Any { self.description }
}
