//
//  RecordField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/20/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A set of information and/or metadata about the item represented by a MARC record.
///
/// The semantic meaning of a record field is indicated by its ``RecordField/tag``.
///
/// Control fields contain information and metadata about how a record's content should be processed.
///
/// Data fields are composed of ``RecordField/subfields``, which are portions of data semantically identified by
/// their ``Subfield/code``. The interpretation of data within a content field is often determined by its indicators
/// and the formatting of its subfields' contents. For example, a bibliographic record's title statement, identified
/// with the tag `245`, formats its content using ISBD principles and uses subfield codes to semantically tag each
/// piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page: [International Standard Bibliographic Description][isbd].
///
/// The ISBD punctuation standard can be found in section A3 in [the consolidated technical specification][spec].
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// [MARC 21 Record Structure][marc].
///
/// [isbd]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
/// [spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
/// [marc]: https://www.loc.gov/marc/specifications/specrecstruc.html
public struct RecordField: Sendable {
    /// A value indicating the semantic purpose of the record field.
    public let tag: FieldTag

    private(set) public var content: Content

    public enum Content: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
        case control(value: String)
        case data(indicators: (first: FieldIndicator, second: FieldIndicator), subfields: [Subfield])

        public var description: String {
            switch self {
            case let .control(value: value): return value
            case let .data(indicators: indicators, subfields: subfields):
                return "\(indicators.first)\(indicators.second)\(subfields.map(\.description).joined())"
            }
        }

        public var debugDescription: String {
            self.description
        }
    }

    public init(tag: FieldTag, content: Content? = nil) {
        self.tag = tag
        switch content {
        case .control(value: _)?:
            precondition(tag.isControlTag)
            self.content = content!
        case .data(indicators: _, subfields: _)?:
            precondition(tag.isDataTag)
            self.content = content!
        case nil where tag.isControlTag:
            self.content = .control(value: "")
        case nil where tag.isDataTag:
            self.content = .data(indicators: (.blank, .blank), subfields: [])
        case nil:
            preconditionFailure("\(tag) is neither a control field tag nor a data field tag.")
        }
    }

    public var stringValue: String {
        switch content {
        case let .control(value): return value
        case let .data(indicators: _, subfields: subfields):
            return subfields.map(\.description).joined()
        }
    }
}

extension RecordField {
    /// Is this a control field containing a control value?
    public var isControlField: Bool {
        guard case .control(value: _) = self.content else { return false }
        return true
    }

    /// Is this a data field with content indicators and subfield data?
    public var isDataField: Bool {
        guard case .data(indicators: _, subfields: _) = self.content else { return false }
        return true
    }

    /// The information contained within the control field.
    ///
    /// - note: This value is  `nil` for data fields.
    /// - note: This value is never  `nil` for control fields.
    ///         Setting it to  `nil` will change its value to the empty string.
    public var controlValue: String? {
        get {
            guard case let .control(value: value) = self.content else { return nil }
            return value
        }
        set {
            guard case .control(value: _) = self.content else { return }
            self.content = .control(value: newValue ?? "")
        }
    }

    /// The first and second metadata values in a data field, that can provide some semantic meaning to the field.
    ///
    /// - note: This value is  `nil` for control fields.
    /// - note: This value is never  `nil` for data fields.
    ///         Setting it to  `nil` will change its value to the blank indicator.
    public var indicators: (first:  FieldIndicator, second: FieldIndicator)? {
        get {
            guard case let .data(indicators: indicators, subfields: _) = self.content else { return nil }
            return indicators
        }
        set {
            guard case let .data(indicators: _, subfields: subfields) = self.content else { return }
            self.content = .data(indicators: newValue ?? (first: .blank, second: .blank), subfields: subfields)
        }
    }

    /// An ordered list of subfields containing portions of data semantically identified by their ``Subfield/code``.
    ///
    /// The interpretation of data within a data field is often determined by the formatting of its ``subfields``'
    /// contents. For example, a bibliographic record's title statement, identified with the tag `245`, formats its
    /// content using ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
    ///
    /// You can read more about ISBD on its Wikipedia page: [International Standard Bibliographic Description][isbd].
    ///
    /// The ISBD punctuation standard can be found in section A3 in [the consolidated technical specification][spec].
    ///
    /// - note: This value is `nil` for control fields.
    /// - note: This value is never `nil` for data fields.
    ///         Setting it to `nil` will change its value to an empty array.
    ///
    /// [isbd]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
    /// [spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
    public var subfields: [Subfield] {
        _read {
            if case let .data(indicators: _, subfields: subfields) = self.content {
                yield subfields
            } else {
                yield []
            }
        }
        _modify {
            if case .data(indicators: let indicators, subfields: var subfields) = self.content {
                // We need to do this song and dance to make sure we can have in-place mutations of the subfields array.
                // This should guarantee that there's only ever one reference to the array at any given time, and so the
                // modifications will always happen in-place instead of making a copy on write.
                self.content = .data(indicators: indicators, subfields: [])
                yield &subfields
                self.content = .data(indicators: indicators, subfields: subfields)
            } else {
                var subfields: [Subfield] = []
                yield &subfields
            }
        }
        set {
            guard case let .data(indicators: indicators, subfields: _) = self.content else { return }
            self.content = .data(indicators: indicators, subfields: newValue)
        }
    }

    /// Create an empty record field with the given record field tag.
    ///
    /// - parameter tag: The field tag identifying the semantic purpose for the new record field.
    public init(tag: FieldTag) {
        if tag.isDataTag {
            self.init(tag: tag, content: .data(indicators: (first: .blank, second: .blank), subfields: []))
        } else if tag.isControlTag {
            self.init(tag: tag, content: .control(value: ""))
        } else {
            self.init(tag: tag, content: nil)
        }
    }

    /// Create an empty record field with the given record field tag.
    ///
    /// - parameter tag: The field tag identifying the semantic purpose for the new record field.
    /// - parameter controlValue: The control value for the field.
    ///
    /// - precondition: The given tag must be a control field tag, i.e. one whose ``FieldTag/isControlTag`` is `true`.
    public init(tag: FieldTag, controlValue: String) {
        precondition(!tag.isDataTag, "Cannot create a control field with a data field tag.")
        self.init(tag: tag, content: .control(value: controlValue))
    }

    /// Create an empty record field with the given record field tag.
    ///
    /// - parameter tag: The field tag identifying the semantic purpose for the new record field.
    /// - parameter indicators: The first and second indicator values for a data field.
    /// - parameter subfields: A list of subfields for a data field.
    ///
    /// - precondition: The given tag must be a control field tag, i.e. one whose ``FieldTag/isDataTag`` is `true`.
    public init(tag: FieldTag, indicators: (first: FieldIndicator, second: FieldIndicator), subfields: [Subfield]) {
        precondition(!tag.isControlTag, "Cannot create a data field with a control field tag.")
        self.init(tag: tag, content: .data(indicators: indicators, subfields: subfields))
    }
}

extension RecordField: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.tag)
        switch self.content {
        case let .control(value: value):
            hasher.combine(value)
        case let .data(indicators: indicators, subfields: subfields):
            hasher.combine(indicators.first)
            hasher.combine(indicators.second)
            hasher.combine(subfields)
        }
    }

    public static func == (lhs: RecordField, rhs: RecordField) -> Bool {
        guard lhs.tag == rhs.tag else {
            return false
        }

        switch lhs.content {
        case let .control(value: lhsValue):
            guard case let .control(value: rhsValue) = rhs.content else {
                return false
            }
            return lhsValue == rhsValue

        case let .data(indicators: lhsIndicators, subfields: lhsSubfields):
            guard case let .data(indicators: rhsIndicators, subfields: rhsSubfields) = rhs.content else {
                return false
            }
            return lhsIndicators.first == rhsIndicators.first
                && lhsIndicators.second == rhsIndicators.second
                && lhsSubfields == rhsSubfields
        }
    }
}

extension RecordField: Collection, MutableCollection, RandomAccessCollection {
    public typealias Element = Subfield

    /// The total amount of subfields contained in this data field.
    ///
    /// - note: This value is always `0` for control fields.
    public var count: Int { return self.subfields.count }

    public var startIndex: Int { return self.subfields.startIndex }
    public var endIndex: Int { return self.subfields.endIndex }
    public var indices: Range<Int> { self.subfields.indices }
    public subscript(i: Int) -> Subfield {
        _read { yield self.subfields[i] }
        _modify { yield &self.subfields[i] }
        set { self.subfields[i] = newValue }
    }
    public mutating func replaceSubrange<C: Collection>(
        _ subrange: Indices, with newElements: C
    ) where C.Element == Subfield {
        self.subfields.replaceSubrange(subrange, with: newElements)
    }
}

extension IteratorProtocol where Element == Subfield {
    public mutating func next(with code: SubfieldCode) -> Subfield? {
        while let next = self.next() {
            if next.code == code {
                return next
            }
        }
        return nil
    }
}

extension RecordField {
    /// Check to see if this data field has a subfield marked with the given code.
    ///
    /// - parameter code: The subfield code used to check the presence of any relevant subfields.
    /// - returns: `true` when this data field contains a subfield marked with the given code.
    ///            `false` is returned when no such subfield is found.
    ///
    /// - note: This method always returns `false` for control fields.
    public func containsSubfield(with code: SubfieldCode) -> Bool {
        self.subfields.contains(where: { $0.code == code })
    }

    public func containsSubfield(with code: SubfieldCode, after index: Int) -> Bool {
        self.subfields[index..<self.subfields.endIndex]
            .contains(where: { $0.code == code })
    }
}

extension RecordField {
    /// Get the index of the first subfield marked with the given code.
    ///
    /// - parameter code: The subfield code that the resulting subfield should have.
    /// - returns: The index of the first subfield in this data field with the given subfield code.
    ///            `nil` is returned if there is no such matching subfield.
    ///
    /// - note: This method always returns `nil` for control fields.
    public func firstIndex(OfSubfield code: SubfieldCode) -> Int? {
        self.subfields.firstIndex(where: { $0.code == code })
    }

    public func lastIndex(ofSubfield code: SubfieldCode) -> Int? {
        self.subfields.lastIndex(where: { $0.code == code })
    }

    public func index(OfSubfield code: SubfieldCode, after index: Int) -> Int? {
        self.subfields[self.subfields.index(after: index)..<self.subfields.endIndex]
            .firstIndex(where: { $0.code == code })
    }

    /// Get this data field's subfield at the given index.
    ///
    /// - parameter index: The index of the subfield to access.
    /// - returns: This data field's subfield located at the given index.
    ///
    /// - note: This method will fatally error for control fields.
    public func subfield(at index: Int) -> Subfield {
        return self.subfields[index]
    }

    @available(macOS 15.0, iOS 18.0, macCatalyst 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func indices(ofSubfield code: SubfieldCode) -> RangeSet<Int> {
        self.subfields.indices(where: { $0.code == code })
    }

    @available(macOS 15.0, iOS 18.0, macCatalyst 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func subfields(at indices: RangeSet<Index>) -> DiscontiguousSlice<[Subfield]> {
        self.subfields[indices]
    }
}

extension RecordField {
    /// Get the first subfield marked with the given code.
    ///
    /// - parameter code: The subfield code that the resulting subfield should have.
    /// - returns: The first subfield in this data field with the given subfield code.
    ///            `nil` is returned if there is no such matching subfield.
    ///
    /// - note: This method always returns `nil` for control fields.
    public func firstSubfield(with code: SubfieldCode) -> Subfield? {
        self.subfields.first(where: { $0.code == code })
    }

    /// Get the last subfield marked with the given code.
    ///
    /// - parameter code: The subfield code that the resulting subfield should have.
    /// - returns: The first subfield in this data field with the given subfield code.
    ///            `nil` is returned if there is no such matching subfield.
    ///
    /// - note: This method always returns `nil` for control fields.
    public func lastSubfield(with code: SubfieldCode) -> Subfield? {
        self.subfields.last(where: { $0.code == code })
    }

    public func firstSubfield(with code: SubfieldCode, after index: Int) -> Subfield? {
        self.subfields[self.subfields.index(after: index)..<self.subfields.endIndex]
            .first(where: { $0.code == code })
    }

    public func subfields(with code: SubfieldCode) -> [Subfield] {
        self.subfields.filter { $0.code == code }
    }
}

extension RecordField: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode([FieldTag : RecordField.Content].self)
        let tag = value.keys.first!
        self.init(tag: tag, content: value[tag]!)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([self.tag : content])
    }
}

extension RecordField.Content: Codable {
    /// - note: This structure exists to facilitate encoding and decoding with the [MARC-in-JSON][marc-in-json] format.
    ///
    /// [marc-in-json]: https://rossfsinger.com/blog/2010/09/a-proposal-to-serialize-marc-in-json/
    private struct DataFieldContent: Codable {
        var firstIndicator: FieldIndicator
        var secondIndicator: FieldIndicator
        var subfields: [Subfield]

        enum CodingKeys: String, CodingKey {
            case firstIndicator = "ind1"
            case secondIndicator = "ind2"
            case subfields
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let controlValue = try? container.decode(String.self) {
            self = .control(value: controlValue)
        } else {
            let dataFieldContent = try container.decode(DataFieldContent.self)
            self = .data(indicators: (first: dataFieldContent.firstIndicator,
                                      second: dataFieldContent.secondIndicator),
                         subfields: dataFieldContent.subfields)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .control(value: value):
            try container.encode(value)
        case let .data(indicators: indicators, subfields: subfields):
            let dataFieldContent = DataFieldContent(firstIndicator: indicators.first,
                                                    secondIndicator: indicators.second,
                                                    subfields: subfields)
            try container.encode(dataFieldContent)
        }
    }
}

extension RecordField: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String {
        switch self.content {
        case let .control(value: value): return value
        case let .data(indicators: _, subfields: subfields): return subfields.map { "\($0)" }.joined(separator: " ")
        }
    }

    public var debugDescription: String {
        switch self.content {
            case let .control(value: value):
                return "\(self.tag) \(value)"
            case let .data(indicators: indicators, subfields: subfields):
                let content = subfields.map { "$\($0.code)\($0.content)" }.joined()
                return "\(self.tag) \(indicators.first)\(indicators.second) \(content)"
        }
    }

    public var playgroundDescription: Any {
        switch self.content {
        case let .control(value: value):
            return ["tag" : self.tag,
                    "control value" : value]
        case let .data(indicators: indicators, subfields: subfields):
            return ["tag" : self.tag,
                    "indicators" : indicators,
                    "subfields" : subfields]
        }
    }
}

// MARK: - Bridging

extension RecordField: ReferenceConvertible {
    public typealias ReferenceType = BibRecordField
}

extension RecordField: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibRecordField

    public func _bridgeToObjectiveC() -> BibRecordField {
        switch self.content {
        case let .control(value: value):
            return BibRecordField(fieldTag: self.tag, controlValue: value)
        case let .data(indicators: indicators, subfields: subfields):
            return BibRecordField(fieldTag: self.tag,
                                  firstIndicator: indicators.first,
                                  secondIndicator: indicators.second,
                                  subfields: subfields)
        }
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecordField, result: inout RecordField?) {
        if source.isControlField {
            result = RecordField(tag: source.fieldTag, controlValue: source.controlValue!)
        } else if source.isDataField {
            result = RecordField(tag: source.fieldTag,
                                 indicators: (first: source.firstIndicator!, second: source.secondIndicator!),
                                 subfields: source.subfields! as [Subfield])
        } else {
            result = .init(tag: source.fieldTag as FieldTag)
        }
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibRecordField, result: inout RecordField?) -> Bool {
        self._forceBridgeFromObjectiveC(source, result: &result)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibRecordField?) -> RecordField {
        guard let source = source else { return RecordField(tag: "000") }
        var result: RecordField!
        self._forceBridgeFromObjectiveC(source, result: &result)
        return result
    }
}

extension BibRecordField: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        if self.isDataField {
            return ["fieldTag" : self.fieldTag,
                    "firstIndicator" : self.firstIndicator!,
                    "secondIndicator" : self.secondIndicator!,
                    "subfields" : self.subfields!]
        } else if self.isControlField {
            return ["fieldTag" : self.fieldTag,
                    "controlValue" : self.controlValue!]
        } else {
            return ["fieldTag" : self.fieldTag]
        }
    }
}
