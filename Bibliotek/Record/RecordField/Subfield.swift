//
//  Subfield.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A portion of data in a content field semantically identified by its ``Subfield/code``.
///
/// Content fields hold data within labeled subfields. Each subfield's identifier marks the semantic meaning of its
/// content, which is determined by the record field's tag as defined in the appropriate MARC 21 format specification.
public struct Subfield: Sendable, Hashable {
    /// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
    ///
    /// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
    public var code: SubfieldCode

    /// A string representation of the information stored in the subfield.
    public var content: String

    /// Create a subfield of data for use within a record's data field.
    /// - parameter code: An alphanumeric identifier for semantic purpose of the subfield's content.
    /// - parameter content: A string representation of the data stored within the subfield.
    public init(code: SubfieldCode, content: String) {
        self.code = code
        self.content = content
    }
}

// MARK: -

extension Subfield: Codable {
    private enum CodingKeys: String, CodingKey {
        case code
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(SubfieldCode.RawValue.self, forKey: .code)
        let content = try container.decode(String.self, forKey: .content)
        self.init(code: SubfieldCode(rawValue: code), content: content)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.code.rawValue, forKey: .code)
        try container.encode(self.content, forKey: .content)
    }
}

extension Subfield: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return "‡\(self.code.rawValue)\(self.content)" }

    public var debugDescription: String { return self.description }

    public var playgroundDescription: Any { return ["code": self.code.rawValue, "content": self.content] }
}

// MARK: - Bridging

extension Subfield: ReferenceConvertible {
    public typealias ReferenceType = BibSubfield
    public typealias _ObjectiveCType = BibSubfield

    public func _bridgeToObjectiveC() -> BibSubfield {
        return BibSubfield(code: self.code, content: self.content)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibSubfield, result: inout Subfield?) -> Bool {
        result = Subfield(code: source.subfieldCode, content: source.content)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibSubfield?) -> Subfield {
        guard let source = source else {
            fatalError("Cannot unconditionally bridge a nil \(BibSubfield.self) to \(Subfield.self)")
        }
        return Subfield(code: source.subfieldCode, content: source.content)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibSubfield, result: inout Subfield?) {
        result = Subfield(code: source.subfieldCode, content: source.content)
    }
}

extension BibSubfield: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as Subfield).playgroundDescription }
}

// MARK: - Subfield Code

extension SubfieldCode: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        precondition(value.isASCII)
        self.init(rawValue: "\(value)")
    }
}

extension SubfieldCode: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String {
        self.rawValue
    }

    public var debugDescription: String {
        "SubfieldCode(rawValue: \"\(self.rawValue)\")"
    }

    public var playgroundDescription: Any {
        "‡\(self.rawValue)"
    }
}
