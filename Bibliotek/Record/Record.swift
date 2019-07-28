//
//  Record.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A collection of information pertaining to some item or entity organized using the MARC 21 standard.
///
/// MARC 21 records are comprised of a leader that contains basic metadata about the record itself, a set of
/// control fields storing semantic metadata about the record; and a set of data fields that provide the bibliographic
/// or other data describing the record's item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: https://www.loc.gov/marc/specifications/specrecstruc.html
public struct Record {
    private var _storage: BibRecord!
    private var _mutableStorage: BibMutableRecord!
    private var storage: BibRecord! { return self._storage ?? self._mutableStorage }

    /// The type of data represented by the record.
    ///
    /// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
    /// different schemas to present their information.
    public var kind: RecordKind {
        get { return self.storage.kind }
        set { self.mutate(keyPath: \.kind, with: newValue) }
    }

    /// The record's current status in the database it was fetched from.
    public var status: RecordStatus {
        get { return self.storage.status }
        set { self.mutate(keyPath: \.status, with: newValue) }
    }

    public var metadata: Metadata {
        get { return self.storage.metadata as Metadata }
        set { self.mutate(keyPath: \.metadata, with: newValue as BibMetadata) }
    }

    public var controlFields: [ControlField] {
        get { return self.storage.controlFields as [ControlField] }
        set { self.mutate(keyPath: \.controlFields, with: newValue as [BibControlField]) }
    }

    public var contentFields: [ContentField] {
        get { return self.storage.contentFields as [ContentField] }
        set { self.mutate(keyPath: \.contentFields, with: newValue as [BibContentField]) }
    }

    private init(storage: BibRecord) {
        self._storage = storage.copy() as? BibRecord
    }

    private mutating func mutate<T>(keyPath: WritableKeyPath<BibMutableRecord, T>, with newValue: T) {
        if self._mutableStorage == nil {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableRecord
            self._storage = nil
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableRecord
        }
        self._mutableStorage[keyPath: keyPath] = newValue
    }
}

// MARK: -

extension Record: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension Record: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var playgroundDescription: Any { return ["kind": self.kind.description,
                                                    "status": String(format: "%c", self.status.rawValue),
                                                    "meatdata": self.metadata,
                                                    "controlFields": self.contentFields,
                                                    "contentFields": self.contentFields] }
}

// MARK: - Bridging

extension Record: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibRecord

    public func _bridgeToObjectiveC() -> BibRecord {
        return self.storage.copy() as! BibRecord
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibRecord, result: inout Record?) -> Bool {
        result = Record(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibRecord?) -> Record {
        return Record(storage: source!)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecord, result: inout Record?) {
        result = Record(storage: source)
    }
}

extension BibRecord: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as Record).playgroundDescription }
}
