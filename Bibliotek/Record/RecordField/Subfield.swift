//
//  Subfield.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A portion of data in a content field semantically identified by its \c code.
///
/// Content fields hold data within labeled subfields. Each subfield's identifier marks the semantic meaning of its
/// content, which is determined by the record field's tag as defined in the appropriate MARC 21 format specification.
public struct Subfield {
    private var _storage: BibSubfield!
    private var _mutableStorage: BibMutableSubfield!
    private var storage: BibSubfield! { return self._storage ?? self._mutableStorage }

    /// A record subfield's identifier identifies the semantic purpose of the content within a subfield.
    ///
    /// The semantics of each identifier is determined by the record field's tag as defined in the relevant MARC 21 format.
    public var code: SubfieldCode {
        get { return self.storage.subfieldCode }
        set { self.mutate(keyPath: \.code, with: newValue) }
    }

    /// A string representation of the information stored in the subfield.
    public var content: String {
        get { return self.storage.content }
        set { self.mutate(keyPath: \.content, with: newValue) }
    }

    private init(storage: BibSubfield) {
        self._storage = storage.copy() as? BibSubfield
    }

    /// Create a subfield of data for use within a record's data field.
    /// - parameter code: An alphanumeric identifier for semantic purpose of the subfield's content.
    /// - parameter content: A string representation of the data stored within the subfield.
    /// - returns: Returns a subfield value when the given subfield identifier is well-formatted.
    public init(code: SubfieldCode, content: String) {
        self._storage = BibSubfield(code: code, content: content)
    }

    private mutating func mutate<T>(keyPath: WritableKeyPath<BibMutableSubfield, T>, with newValue: T) {
        if (self._mutableStorage == nil) {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableSubfield
            self._storage = nil
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableSubfield
        }
        self._mutableStorage[keyPath: keyPath] = newValue
    }
}

// MARK: -

extension Subfield: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: Subfield, rhs: Subfield) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

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
    public var description: String { return self.storage.description }

    public var debugDescription: String { return self.storage.debugDescription }

    public var playgroundDescription: Any { return ["code": self.code.rawValue, "content": self.content] }
}

// MARK: - Bridging

extension Subfield: ReferenceConvertible {
    public typealias ReferenceType = BibSubfield
}

extension Subfield: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibSubfield

    public func _bridgeToObjectiveC() -> BibSubfield {
        return self.storage.copy() as! BibSubfield
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibSubfield, result: inout Subfield?) -> Bool {
        self._forceBridgeFromObjectiveC(source, result: &result)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibSubfield?) -> Subfield {
        return Subfield(storage: source!)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibSubfield, result: inout Subfield?) {
        result = Subfield(storage: source)
    }
}

extension BibSubfield: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as Subfield).playgroundDescription }
}

// MARK: - Subfield Code

extension SubfieldCode: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
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
        self.description
    }
}
