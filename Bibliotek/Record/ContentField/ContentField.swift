//
//  ContentField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A set of information and metadata about the item represented by a MARC record.
///
/// The semantic meaning of a content field is indicated by its `tag` value, and its `indicators` are used as flags
/// that determine how the data in its subfields should be interpreted or displayed.
///
/// Content fields are composed of `subfields`, which are portions of data semantically identified by their `code`.
/// The interpretation of data within a content field is often determined by the formatting of its subfields' contents.
/// For example, a bibliographic record's title statement, identified with the tag `245`, formats its content using
/// ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
///
/// You can read more about ISBD on its Wikipedia page:
/// [https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description][isbd-wikipedia]
///
/// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
/// [https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf][isbd-spec]
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: [https://www.loc.gov/marc/specifications/spechome.html][spec-home]
///
/// More information about bibliographic records' content fields can be found in the Library of Congress's documentation
/// on bibliographic records: [http://www.loc.gov/marc/bibliographic/][bib-docs]
///
/// More information about classification records' content fields can be found in the Library of Congress's
/// documentation on classification records: [https://www.loc.gov/marc/classification/][class-docs]
///
/// [bib-docs]: http://www.loc.gov/marc/bibliographic/
/// [class-docs]: https://www.loc.gov/marc/classification/
/// [spec-home]: https://www.loc.gov/marc/specifications/spechome.html
/// [isbd-wikipedia]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
/// [isbd-spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
public struct ContentField {
    private var _storage: BibContentField!
    private var _mutableStorage: BibMutableContentField!
    private var storage: BibContentField! { return self._storage ?? self._mutableStorage }

    /// A value indicating the semantic purpose of the control field.
    public var tag: FieldTag {
        get { return self.storage.tag as FieldTag }
        set { self.mutate(keyPath: \.tag, with: newValue as BibFieldTag) }
    }

    /// A collection of byte flags which can indicate how the content field should be interpreted or displayed.
    public var indicators: ContentIndicatorList {
        get { return self.storage.indicators as ContentIndicatorList }
        set { self.mutate(keyPath: \.indicators, with: newValue as BibContentIndicatorList) }
    }

    /// An ordered list of subfields containing portions of data semantically identified by their `code`.
    /// The interpretation of data within a content field is often determined by the formatting of its subfields'
    /// contents. For example, a bibliographic record's title statement, identified with the tag `245`, formats its
    /// content using ISBD principles and uses subfield codes to semantically tag each piece of the full statement.
    ///
    /// You can read more about ISBD on its Wikipedia page:
    /// [https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description][isbd-wikipedia]
    ///
    /// The ISBD punctuation standard can be found in section A3 in this consolidated technical specification:
    /// [https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf][isbd-spec]
    ///
    /// [isbd-wikipedia]: https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description
    /// [isbd-spec]: https://www.ifla.org/files/assets/cataloguing/isbd/isbd-cons_20110321.pdf
    public var subfields: [Subfield] {
        get { return self.storage.subfields as [Subfield] }
        set { self.mutate(keyPath: \.subfields, with: newValue as [BibSubfield]) }
    }

    private init(storage: BibContentField) {
        self._storage = storage.copy() as? BibContentField
    }

    public init(tag: FieldTag, indicators: ContentIndicatorList, subfields: [Subfield]) {
        self._storage = BibContentField(tag: tag as BibFieldTag,
                                        indicators: indicators as BibContentIndicatorList,
                                        subfields: subfields as [BibSubfield])
    }

    private mutating func mutate<T>(keyPath: WritableKeyPath<BibMutableContentField, T>, with newValue: T) {
        if self._mutableStorage == nil {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableContentField
            self._storage = nil;
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableContentField
        }
        self._mutableStorage[keyPath: keyPath] = newValue
    }
}

extension ContentField: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: ContentField, rhs: ContentField) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension ContentField: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var playgroundDescription: Any { return ["tag": self.tag.rawValue,
                                                    "indicators": self.indicators,
                                                    "subfields": self.subfields] }
}

extension ContentField {
    public func indexesOfSubfields(with code: SubfieldCode) -> IndexSet {
        return self.storage.indexesOfSubfields(withCode: code)
    }

    public func firstSubfield(with code: SubfieldCode) -> Subfield? {
        return self.storage.firstSubfield(withCode: code) as Subfield?
    }

    public func subfields(with code: SubfieldCode) -> LazyFilterSequence<[Subfield]> {
        return self.subfields.lazy.filter { $0.code == code }
    }

    public func subfield(at index: Int) -> Subfield {
        return self.storage.subfield(at: UInt(index)) as Subfield
    }
}

// MARK: - Bridging

extension ContentField: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibContentField

    public func _bridgeToObjectiveC() -> BibContentField {
        return self.storage.copy() as! BibContentField
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibContentField, result: inout ContentField?) -> Bool {
        result = ContentField(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibContentField?) -> ContentField {
        return ContentField(storage: source!)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibContentField, result: inout ContentField?) {
        result = ContentField(storage: source)
    }
}

extension BibContentField: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as ContentField).playgroundDescription }
}
