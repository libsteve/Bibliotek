//
//  ContentField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A content field contains information and metadata contained within the record.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
public struct ContentField {
    private var _storage: BibContentField!
    private var _mutableStorage: BibMutableContentField!
    private var storage: BibContentField! { return self._storage ?? self._mutableStorage }

    /// A value indicating the semantic purpose of the control field.
    public var tag: FieldTag {
        get { return self.storage.tag as FieldTag }
        set { self.mutate(keyPath: \.tag, with: newValue as BibFieldTag) }
    }

    public var indicators: ContentIndicators {
        get { return self.storage.indicators as ContentIndicators }
        set { self.mutate(keyPath: \.indicators, with: newValue as BibContentIndicators) }
    }

    public var subfields: [Subfield] {
        get { return self.storage.subfields as [Subfield] }
        set { self.mutate(keyPath: \.subfields, with: newValue as [BibSubfield]) }
    }

    private init(storage: BibContentField) {
        self._storage = storage.copy() as? BibContentField
    }

    public init(tag: FieldTag, indicators: ContentIndicators, subfields: [Subfield]) {
        self._storage = BibContentField(tag: tag as BibFieldTag,
                                        indicators: indicators as BibContentIndicators,
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
