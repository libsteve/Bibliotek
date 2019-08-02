//
//  ControlField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A control field contains information and metadata about how a record's content should be processed.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: [https://www.loc.gov/marc/specifications/spechome.html][spec-home]
///
/// Information about Bibliographic control fields can be found in the Library of Congress's documentation:
/// [http://www.loc.gov/marc/bibliographic/bd00x.html][bib-control]
///
/// Information about Classification control fields can be found in the Library of Congress's documentation:
/// [https://www.loc.gov/marc/classification/cd00x.html][cls-control]
///
/// [spec-home]: https://www.loc.gov/marc/specifications/spechome.html
/// [bib-control]: http://www.loc.gov/marc/bibliographic/bd00x.html
/// [cls-control]: https://www.loc.gov/marc/classification/cd00x.html
public struct ControlField {
    private var _storage: BibControlField!
    private var _mutableStorage: BibMutableControlField!
    private var storage: BibControlField! { return self._storage ?? self._mutableStorage }

    /// A value indicating the semantic purpose of the control field.
    public var tag: FieldTag {
        get { return self.storage.tag as FieldTag }
        set { self.mutate(keyPath: \.tag, newValue as BibFieldTag) }
    }

    /// The information contained within the control field.
    public var value: String {
        get { return self.storage.value }
        set { self.mutate(keyPath: \.value, newValue) }
    }

    private init(storage: BibControlField) {
        self._storage = storage.copy() as? BibControlField
    }

    public init(tag: FieldTag, value: String) {
        self._storage = BibControlField(tag: tag as BibFieldTag, value: value)
    }

    private mutating func mutate<T>(keyPath: WritableKeyPath<BibMutableControlField, T>, _ newValue: T) {
        if self._mutableStorage ==  nil {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableControlField
            self._storage = nil
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableControlField
        }
        self._mutableStorage[keyPath: keyPath] = newValue
    }
}

// MARK: -

extension ControlField: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: ControlField, rhs: ControlField) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension ControlField: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var playgroundDescription: Any { return ["tag": self.tag.rawValue, "value": self.value] }
}

// MARK: - Bridging

extension ControlField: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibControlField

    public func _bridgeToObjectiveC() -> BibControlField {
        return self.storage.copy() as! BibControlField
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibControlField, result: inout ControlField?) -> Bool {
        result = ControlField(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibControlField?) -> ControlField {
        return ControlField(storage: source!)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibControlField, result: inout ControlField?) {
        result = ControlField(storage: source)
    }
}

extension BibControlField: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as ControlField).playgroundDescription }
}
