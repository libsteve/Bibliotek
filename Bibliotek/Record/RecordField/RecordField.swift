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
/// The semantic meaning of a record field is indicated by its `tag` value.
/// A control field contains information and metadata about how a record's content should be processed.
///
/// The semantic meaning of a data field is indicated by its `tag` value, and its indicators are used as flags
/// that determine how the data in its subfields should be interpreted or displayed.
///
/// Data fields are composed of `subfields`, which are portions of data semantically identified by their `code`.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag `245`, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
public struct RecordField {

    /// A value indicating the semantic purpose of the record field.
    public var tag: FieldTag {
        willSet { self.resetContentIfNeeded(forFieldTag: newValue) }
    }

    private(set) public var content: Content!

    public enum Content {
        case control(value: String)
        case data(indicators: (first: FieldIndicator, second: FieldIndicator), subfields: [Subfield])
    }
    
    /// This object is a control field containing a control value.
    public var isControlField: Bool {
        guard case .control(value: _) = self.content else { return false }
        return true
    }

    /// This object is a data field with contnet indicators and subfield data.
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

    /// An ordered list of subfields containing portions of data semantically identified by their `code`.
    /// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
    /// For example, a bibliographic record's title statement, identified with the tag `245`, formats its content using
    /// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
    ///
    /// You can read more about ISBD on its Wikipedia page:
    /// https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
    ///
    /// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
    /// https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
    ///
    /// - note: This value is `nil` for control fields.
    /// - note: This value is never `nil` for data fields.
    ///         Setting it to `nil` will change its value to an empty array.
    public var subfields: [Subfield]? {
        get {
            guard case let .data(indicators: _, subfields: subfields) = self.content else { return nil }
            return subfields
        }
        set {
            guard case let .data(indicators: indicators, subfields: _) = self.content else { return }
            self.content = .data(indicators: indicators, subfields: newValue ?? [])
        }
    }

    private init(tag: FieldTag, content: Content?) {
        self.tag = tag
        self.content = content
    }

    /// Create an empty record field with the given record field tag.
    /// - parameter fieldTag: The field tag identifying the semantic purpose for the new record field.
    /// - returns: An empty record field object.
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
    /// - parameter fieldTag: The field tag identifying the semantic purpose for the new record field.
    /// - parameter controlValue: The control value for the field.
    /// - returns: An control field object.
    public init(tag: FieldTag, controlValue: String) {
        guard tag.isControlTag else { self.init(tag: tag); return }
        self.init(tag: tag, content: .control(value: controlValue))
    }

    /// Create an empty record field with the given record field tag.
    /// - parameter fieldTag: The field tag identifying the semantic purpose for the new record field.
    /// - parameter indicators: The first and second indicator values for a data field.
    /// - parameter subfields: A list of subfields for a data field.
    /// - returns: A data field object.
    public init(tag: FieldTag, indicators: (first: FieldIndicator, second: FieldIndicator), subfields: [Subfield]) {
        guard tag.isDataTag else { self.init(tag: tag); return }
        self.init(tag: tag, content: .data(indicators: indicators, subfields: subfields))
    }
}

extension RecordField {
    private mutating func resetContentIfNeeded(forFieldTag tag: FieldTag) {
        switch self.content {
        case nil:
            if tag.isDataTag {
                self.content = .data(indicators: (first: .blank, second: .blank), subfields: [])
            } else if tag.isControlTag {
                self.content = .control(value: "")
            }
        case .control(value: _):
            if tag.isDataTag {
                self.content = .data(indicators: (first: .blank, second: .blank), subfields: [])
            } else if !tag.isControlTag {
                self.content = nil
            }
        case .data(indicators: _, subfields: _):
            if tag.isControlTag {
                self.content = .control(value: "")
            } else if !tag.isDataTag {
                self.content = nil
            }
        }
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
        case nil:
            break
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

        case nil:
            return rhs.content == nil
        }
    }
}

extension RecordField {
    /// The total amount of subfields contained in this data field.
    /// - note: This value is always `0` for control fields.
    public var subfieldCount: Int { return self.subfields?.count ?? 0 }

    /// Get the first subfield marked with the given code.
    /// - parameter code: The subfield code that the resulting subfield should have.
    /// - returns: The first subfield in this data field with the given subfield code.
    ///            `nil` is returned if there is no such matching subfield.
    /// - note: This method always returns `nil` for control fields.
    public func subfield(with code: SubfieldCode) -> Subfield? {
        return self.indexOfSubfiled(with: code).map(self.subfield(at:))
    }

    /// Get the index of the first subfield marked with the given code.
    /// - parameter subfieldCode: The subfield code that the resulting subfield should have.
    /// - returns: The index of the first subfield in this data field with the given subfield code.
    ///            `nil` is returned if there is no such matching subfield.
    /// - note: This method always returns `nil` for control fields.
    public func indexOfSubfiled(with code: SubfieldCode) -> Int? {
        switch self.content {
        case nil, .control(value: _):
            return nil

        case let .data(indicators: _, subfields: subfields):
            return subfields.indices.first(where: { subfields[$0].code == code })
        }
    }

    /// Get this data field's subfield at the given index.
    /// - parameter index: The index of the subfield to access.
    /// - returns: This data field's subfiled located at the given index.
    /// - note: This method will fatally error for control fields.
    public func subfield(at index: Int) -> Subfield {
        return self.subfields![index]
    }

    /// Use indexed subscripting syntax to access a subfield from this data field.
    /// - parameter index: The index of the subfield to access.
    /// - returns: This data field's subfiled located at the given index.
    /// - note: This method will throw fatally error for control fields.
    public subscript(index: Int) -> Subfield {
        get { return self.subfield(at: index) }
        set { self.subfields![index] = newValue }
    }

    /// Check to see if this data field has a subfield marked with the given code.
    /// - parameter subfieldCode: The subfield code used to check the presence of any relevant subfields.
    /// - returns: `true` when this data field contains a subfield marked with the given code.
    ///            `false` is returned when no such subfield is found.
    /// - note: This method always returns `false` for control fields.
    public func containsSubfield(with code: SubfieldCode) -> Bool {
        return self.indexOfSubfiled(with: code) != nil
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
        guard let content = self.content else { return }
        try container.encode([self.tag : content])
    }
}

extension RecordField.Content: Codable {
    /// - note: This structure exists to facilitate encoding and decoding with the MARC-in-JSON format.
    /// https://rossfsinger.com/blog/2010/09/a-proposal-to-serialize-marc-in-json/
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
        default: return ""
        }
    }

    public var debugDescription: String {
        switch self.content {
            case let .control(value: value):
                return "\(self.tag) \(value)"
            case let .data(indicators: indicators, subfields: subfields):
                let content = subfields.map { "$\($0.code)\($0.content)" }.joined()
                return "\(self.tag) \(indicators.first)\(indicators.second) \(content)"
            default:
                return "\(self.tag)"
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
        default:
            return ["tag" : self.tag]
        }
    }
}

// MARK: - Bridging

extension RecordField: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibRecordField

    public func _bridgeToObjectiveC() -> BibRecordField {
        switch self.content {
        case nil:
            return BibRecordField(fieldTag: self.tag as BibFieldTag)
        case let .control(value: value):
            return BibRecordField(fieldTag: self.tag as BibFieldTag, controlValue: value)
        case let .data(indicators: indicators, subfields: subfields):
            return BibRecordField(fieldTag: self.tag as BibFieldTag,
                                  firstIndicator: indicators.first as BibFieldIndicator,
                                  secondIndicator: indicators.second as BibFieldIndicator,
                                  subfields: subfields as [BibSubfield])
        }
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecordField, result: inout RecordField?) {
        if source.isControlField {
            result = RecordField(tag: source.fieldTag as FieldTag, controlValue: source.controlValue!)
        } else if source.isDataField {
            result = RecordField(tag: source.fieldTag as FieldTag,
                                 indicators: (first: source.firstIndicator! as FieldIndicator,
                                              second: source.secondIndicator! as FieldIndicator),
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
