//
//  Record.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A collection of information about an item or entity organized using the MARC 21 standard.
///
/// MARC 21 records are comprised of metadata about the record itself, a set of control fields storing metadata about
/// how the record should be processed, and a set of control fields that provide bibliographic, classification,
/// or other data describing the represented item or entity.
///
/// More information about MARC 21 records can be found in the Library of Congress's documentation on
/// MARC 21 Record Structure: [https://www.loc.gov/marc/specifications/spechome.html][spec-home]
///
/// [spec-home]: https://www.loc.gov/marc/specifications/spechome.html
public struct Record {
    private var _storage: BibRecord!
    private var _mutableStorage: BibMutableRecord!
    private var storage: BibRecord! { return self._storage ?? self._mutableStorage }

    /// The type of data represented by the record.
    ///
    /// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
    /// different schemas to present their information.
    ///
    /// Use this field to determine how tags and subfield codes should be used to interpret field content.
    public var kind: RecordKind? {
        get { return self.storage.kind as RecordKind? }
        set { self.mutate(keyPath: \.kind, with: newValue as BibRecordKind?) }
    }

    /// The record's current status in the database it was fetched from.
    public var status: RecordStatus {
        get { return self.storage.status }
        set { self.mutate(keyPath: \.status, with: newValue) }
    }

    /// Implementation-defined metadata from the MARC record's leader.
    ///
    /// MARC records can have arbitrary implementation-defined data embeded in their leader.
    /// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
    ///
    /// Use this field to access those bytes, which should be interpreted using the scheme identified in `kind`.
    public var metadata: Metadata {
        get { return self.storage.metadata as Metadata }
        set { self.mutate(keyPath: \.metadata, with: newValue as BibMetadata) }
    }

    /// An ordered list of fields containing information and metadata about how a record's content should be processed.
    public var controlFields: [ControlField] {
        get { return self.storage.controlFields as [ControlField] }
        set { self.mutate(keyPath: \.controlFields, with: newValue as [BibControlField]) }
    }

    /// An ordered list of fields containing information and metadata about the item represented by a record.
    public var contentFields: [ContentField] {
        get { return self.storage.contentFields as [ContentField] }
        set { self.mutate(keyPath: \.contentFields, with: newValue as [BibContentField]) }
    }

    private init(storage: BibRecord) {
        self._storage = storage.copy() as? BibRecord
    }

    /// Create a MARC 21 record with the given data.
    ///
    /// - parameter kind: The type of record.
    /// - parameter status: The record's status in its originating database.
    /// - parameter metadata: A set of implementation-defined bytes.
    /// - parameter controlFields: An ordered list of fields describing how the record should be processed.
    /// - parameter contentFields: An ordered list of fields describing the item represented by the record.
    /// - returns: Returns a valid MARC 21 record for some item or entity described by the given fields.
    public init(kind: RecordKind?, status: RecordStatus, metadata: Metadata,
                controlFields: [ControlField], contentFields: [ContentField]) {
        self._storage = BibRecord(kind: kind as BibRecordKind?,
                                  status: status,
                                  metadata: metadata as BibMetadata,
                                  controlFields: controlFields as [BibControlField],
                                  contentFields: contentFields as [BibContentField])
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

    public var playgroundDescription: Any { return ["kind": self.kind?.description ?? "unset",
                                                    "status": String(format: "%c", self.status.rawValue),
                                                    "meatdata": self.metadata,
                                                    "controlFields": self.contentFields,
                                                    "contentFields": self.contentFields] }
}

extension Record {
    public func controlFields(with tag: FieldTag) -> LazyFilterSequence<[ControlField]> {
        return self.controlFields.lazy.filter { $0.tag == tag }
    }

    public func contentFields(with tag: FieldTag) -> LazyFilterSequence<[ContentField]> {
        return self.contentFields.lazy.filter { $0.tag == tag }
    }

    public func indexPaths(for fieldPath: FieldPath) -> [IndexPath] {
        return self.storage.indexPaths(for: fieldPath as BibFieldPath)
    }

    public func controlField(at indexPath: IndexPath) -> ControlField? {
        return self.storage.controlField(at: indexPath) as ControlField?
    }

    public func contentField(at indexPath: IndexPath) -> ContentField? {
        return self.storage.contentField(at: indexPath) as ContentField?
    }

    public func subfield(at indexPath: IndexPath) -> Subfield? {
        return self.storage.subfield(at: indexPath) as Subfield?
    }

    public func content(at indexPath: IndexPath) -> String {
        return self.storage.content(at: indexPath)
    }

    public func content(with fieldPath: FieldPath) -> [String] {
        return self.storage.content(with: fieldPath as BibFieldPath)
    }
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
