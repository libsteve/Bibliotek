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
/// More information about the tags used with MARC 21 records can be found in the Library of Congress's
/// documentation on [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/spechome.html).
///
/// - note: MARC 21 tags are always 3 digit codes.
public struct FieldTag: Hashable, Sendable, RawRepresentable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        guard rawValue.count == 3,
              rawValue.allSatisfy(\.isASCII),
              rawValue.allSatisfy(\.isNumber) else {
            return nil
        }
        self.rawValue = rawValue
    }

    /// Does the tag identify a control field?
    ///
    /// MARC 21 control-field tags always begin with two zeros.
    /// For example, a record's control number control-field has the tag `001`.
    ///
    /// - note: The tag `000` is neither a control-field tag nor a data-field tag.
    public var isControlTag: Bool { rawValue.hasPrefix("00") }

    /// Does the tag identify a data field?
    ///
    /// MARC 21 data-field tags never begin with two zeros.
    /// For example, a bibliographic record's Library of Congress call number data-field has the tag `050`.
    public var isDataTag: Bool { !isControlTag }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}

// MARK: -

extension FieldTag: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let tag = FieldTag(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid MARC 21 tag: \(rawValue)"
            )
        }
        self = tag
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension FieldTag: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { self.rawValue }

    public var debugDescription: String { self.rawValue }

    public var playgroundDescription: Any { self.rawValue }
}

// MARK: - Bridging

extension FieldTag: ReferenceConvertible {
    public typealias ReferenceType = BibFieldTag
    public typealias _ObjectiveCType = BibFieldTag

    private init(_unchecked rawValue: String) {
        self.rawValue = rawValue
    }

    public func _bridgeToObjectiveC() -> BibFieldTag {
        return _UncheckedTag(_unchecked: self.rawValue)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibFieldTag, result: inout FieldTag?) -> Bool {
        result = FieldTag(_unchecked: source.stringValue)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibFieldTag?) -> FieldTag {
        return FieldTag(_unchecked: source?.stringValue ?? "000")
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFieldTag, result: inout FieldTag?) {
        result = FieldTag(_unchecked: source.stringValue)
    }
}

extension BibFieldTag: ExpressibleByStringLiteral, CustomPlaygroundDisplayConvertible {
    @objc public required convenience init(stringLiteral value: String) {
        self.init(string: value)!
    }

    public var playgroundDescription: Any { self.description }
}

private class _UncheckedTag: BibFieldTag {
    override var stringValue: String { rawValue }
    private let rawValue: String

    public init(_unchecked rawValue: String) {
        self.rawValue = rawValue
        super.init()
    }

    override var classForCoder: AnyClass { BibFieldTag.self }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc required convenience init(stringLiteral value: String) {
        fatalError("init(stringLiteral:) has not been implemented")
    }
}
