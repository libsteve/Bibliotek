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
/// More information about the tags used with MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: [https://www.loc.gov/marc/specifications/spechome.html][spec-home]
///
/// - note: MARC 21 tags are always 3 digit codes.
///
/// [spec-home]: https://www.loc.gov/marc/specifications/spechome.html
public struct FieldTag {
    private var storage: BibFieldTag

    public var rawValue: String { return self.storage.stringValue }

    /// Does the tag identify a control field?
    ///
    /// MARC 21 control field tags always begin with two zeros.
    /// For example, a record's control number field has the tag `001`.
    @available(*, deprecated, message: "Use isControlTag")
    public var isControlFieldTag: Bool { return self.storage.isControlFieldTag }

    /// Does the tag identify a control field?
    ///
    /// MARC 21 controlfield tags always begin with two zeros.
    /// For example, a record's control number controlfield has the tag `001`.
    ///
    /// - note: The tag `000` is neither a controlfield tag nor a datafield tag.
    public var isControlTag: Bool { return self.storage.isControlTag }

    /// Does the tag identify a data field?
    ///
    /// MARC 21 datafield tags never begin with two zeros.
    /// For example, a bibliographic record's Library of Congress call number datafield has the tag `050`.
    public var isDataTag: Bool { return self.storage.isDataTag }

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
        return lhs.storage.isEqual(rhs.storage)
    }
}

extension FieldTag: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self.init(rawValue: rawValue)!
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension FieldTag: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var debugDescription: String { return self.storage.debugDescription }

    public var playgroundDescription: Any { return self.description }
}

// MARK: - Bridging

extension FieldTag: ReferenceConvertible {
    public typealias ReferenceType = BibFieldTag
}

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

extension BibFieldTag: RawRepresentable, ExpressibleByStringLiteral, CustomPlaygroundDisplayConvertible {
    public var rawValue: String { return self.stringValue }

    public required convenience init?(rawValue: String) {
        self.init(string: rawValue)
    }

    public required convenience init(stringLiteral value: String) {
        self.init(string: value)!
    }

    public var playgroundDescription: Any { return (self as FieldTag).playgroundDescription }
}
