//
//  BibRecord.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A 3-character value identifying the semantic purpose of a record field.
///
/// \note MARC 21 tags are always 3 digit codes.
public struct FieldTag {
    private var storage: BibFieldTag

    public var rawValue: String { return self.storage.stringValue }

    /// Does the tag identify a control field?
    ///
    /// MARC 21 control field tags always begin with two zeros.
    /// For example, a record's control number field has the tag `001`.
    public var isControlFieldTag: Bool { return self.storage.isControlFieldTag }

    private init(storage: BibFieldTag) {
        self.storage = storage
    }
}

// MARK: -

extension FieldTag: RawRepresentable, ExpressibleByStringLiteral {
    public init?(rawValue: String) {
        guard let storage = BibFieldTag(string: rawValue) else { return nil }
        self.storage = storage
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}

extension FieldTag: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: FieldTag, rhs: FieldTag) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension FieldTag: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var playgroundDescription: Any { return self.description }
}

// MARK: - Bridging

extension FieldTag: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibFieldTag

    public func _bridgeToObjectiveC() -> BibFieldTag {
        return self.storage
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibFieldTag, result: inout FieldTag?) -> Bool {
        result = FieldTag(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibFieldTag?) -> FieldTag {
        return FieldTag(storage: source!)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFieldTag, result: inout FieldTag?) {
        result = FieldTag(storage: source)
    }
}

extension BibFieldTag: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as FieldTag).playgroundDescription }
}
