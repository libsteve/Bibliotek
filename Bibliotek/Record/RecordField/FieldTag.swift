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
/// - note: MARC 21 tags are always 3 ASCII numeric characters from `001` to `999`.
///   Tag `000` is considered valid, but it's treated as neither a control-field tag nor a data-field tag.
public struct FieldTag: Hashable, Sendable, RawRepresentable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        guard rawValue.count == 3,
              rawValue.allSatisfy(\.isASCII),
              rawValue.allSatisfy(\.isNumber) else {
            return nil
        }
        self.rawValue = rawValue
        let isZeroTag = rawValue == "000"
        self.isControlTag = rawValue.hasPrefix("00") && !isZeroTag;
        self.isDataTag = !isControlTag && !isZeroTag;
    }

    /// Does the tag identify a control field?
    ///
    /// MARC 21 control-field tags always begin with two zeros.
    /// For example, a record's control number control-field has the tag `001`.
    ///
    /// - note: The tag `000` is neither a control-field tag nor a data-field tag.
    public let isControlTag: Bool

    /// Does the tag identify a data field?
    ///
    /// MARC 21 data-field tags never begin with two zeros.
    /// For example, a bibliographic record's Library of Congress call number data-field has the tag `050`.
    public let isDataTag: Bool

    public init(stringLiteral value: String) {
        guard let tag = FieldTag(rawValue: value) else {
            preconditionFailure("MARC 21 tags are exactly 3 ASCII numeric characters.")
        }
        self = tag
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

    private init(_unchecked rawValue: String, isControlTag: Bool, isDataTag: Bool) {
        self.rawValue = rawValue
        self.isControlTag = isControlTag
        self.isDataTag = isDataTag
    }

    public func _bridgeToObjectiveC() -> BibFieldTag {
        return _UncheckedTag.flyweight(for: self.rawValue, isControlTag: self.isControlTag, isDataTag: self.isDataTag)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibFieldTag, result: inout FieldTag?) -> Bool {
        result = FieldTag(_unchecked: source.stringValue, isControlTag: source.isControlTag, isDataTag: source.isDataTag)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibFieldTag?) -> FieldTag {
        guard let source = source else {
            return FieldTag(_unchecked: "000", isControlTag: false, isDataTag: false)
        }
        return FieldTag(_unchecked: source.stringValue, isControlTag: source.isControlTag, isDataTag: source.isDataTag)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFieldTag, result: inout FieldTag?) {
        result = FieldTag(_unchecked: source.stringValue, isControlTag: source.isControlTag, isDataTag: source.isDataTag)
    }
}

extension BibFieldTag: ExpressibleByStringLiteral, CustomPlaygroundDisplayConvertible {
    @objc public required convenience init(stringLiteral value: String) {
        self.init(string: value)!
    }

    public var playgroundDescription: Any { self.description }
}

private final class _UncheckedTag: BibFieldTag, @unchecked Sendable {
    private let rawValue: String
    private let _isControlTag: Bool
    private let _isDataTag: Bool

    override var stringValue: String { rawValue }
    override var isControlTag: Bool { _isControlTag }
    override var isDataTag: Bool { _isDataTag }

    private static let flyweightCash = NSCache<NSString, _UncheckedTag>()

    fileprivate static func flyweight(for rawValue: String, isControlTag: Bool, isDataTag: Bool) -> _UncheckedTag {
        if let cached = flyweightCash.object(forKey: rawValue as NSString) {
            return cached
        }
        let result = _UncheckedTag(_unchecked: rawValue, isControlTag: isControlTag, isDataTag: isDataTag)
        flyweightCash.setObject(result, forKey: rawValue as NSString)
        return result
    }

    fileprivate init(_unchecked rawValue: String, isControlTag: Bool, isDataTag: Bool) {
        self.rawValue = rawValue
        self._isControlTag = isControlTag
        self._isDataTag = isDataTag
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
