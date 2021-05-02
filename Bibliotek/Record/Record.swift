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
        get { return self.storage.kind }
        set { self.mutate(keyPath: \.kind, with: newValue) }
    }

    /// The record's current status in the database it was fetched from.
    public var status: RecordStatus {
        get { return self.storage.status }
        set { self.mutate(keyPath: \.status, with: newValue) }
    }

    /// Implementation-defined metadata from the MARC record's leader.
    ///
    /// MARC records can have arbitrary implementation-defined data embedded in their leader.
    /// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
    ///
    /// Use this field to access those bytes, which should be interpreted using the scheme identified in `kind`.
    public var leader: Leader {
        get { return self.storage.leader }
        set { self.mutate(keyPath: \.leader, with: newValue) }
    }

    /// Implementation-defined metadata from the MARC record's leader.
    ///
    /// MARC records can have arbitrary implementation-defined data embedded in their leader.
    /// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
    ///
    /// Use this field to access those bytes, which should be interpreted using the scheme identified in `kind`.
    @available(*, deprecated, message: "use leader")
    public var metadata: Metadata {
        get { return self.storage.metadata as Metadata }
        set { self.mutate(keyPath: \.metadata, with: newValue as BibMetadata) }
    }

    /// An ordered list of fields containing information and metadata about the record and its represented item.
    public var fields: [RecordField] {
        get { return self.storage.fields as [RecordField] }
        set { self.mutate(keyPath: \.fields, with: newValue as [BibRecordField]) }
    }

    private init(storage: BibRecord) {
        self._storage = storage.copy() as? BibRecord
    }

    /// Create a MARC 21 record with the given data.
    ///
    /// - parameter leader: A set of metadata describing the record, its encoding, and its state in the database.
    /// - parameter fields: An ordered list of fields describing the item represented by the record.
    /// - returns: Returns a valid MARC 21 record for some item or entity described by the given fields.
    public init(leader: Leader, fields: [RecordField]) {
        self._storage = BibRecord(leader: leader, fields: fields as [BibRecordField])
    }

    /// Create a MARC 21 record with the given data.
    ///
    /// - parameter kind: The type of record.
    /// - parameter status: The record's status in its originating database.
    /// - parameter metadata: A set of implementation-defined bytes.
    /// - parameter fields: An ordered list of fields describing the item represented by the record.
    /// - returns: Returns a valid MARC 21 record for some item or entity described by the given fields.
    @available(*, deprecated, message: "use init(leader:fields:)")
    public init(kind: RecordKind?, status: RecordStatus, metadata: Metadata, fields: [RecordField]) {
        self._storage = BibRecord(kind: kind, status: status, metadata: metadata as BibMetadata, fields: fields as [BibRecordField])
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

extension Record: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var debugDescription: String { return self.storage.debugDescription }

    public var playgroundDescription: Any { return ["kind": self.kind?.description ?? "unset",
                                                    "status": String(format: "%c", self.status.rawValue),
                                                    "leader": self.leader,
                                                    "fields": self.fields] }
}

extension Record {
    /// Test to see if the record contains a field with the given tag.
    /// - parameter tag: If this record has a field with this value, \c YES is returned.
    /// - returns: `true` if at least one record field is marked with the given tag.
    public func containsField(with tag: FieldTag) -> Bool {
        return self.indexOfField(with: tag) != nil
    }

    /// Get the index of the first record field with the given tag.
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - returns: The index of the first record with the given tag. If no such field exists, `nil` is returned.
    public func indexOfField(with tag: FieldTag) -> Int? {
        let fields = self.fields
        return fields.indices.first(where: { fields[$0].tag == tag })
    }

    /// Get the first record field with the given tag.
    /// - parameter fieldTag: The field tag marking the data field or control field to access.
    /// - returns: The first record with the given tag. If no such field exists, `nil` is returned.
    public func field(with tag: FieldTag) -> RecordField? {
        return self.indexOfField(with: tag).map(self.field(at:))
    }

    /// Get the field at the given index.
    /// - parameter index: The index of the record field to access.
    /// - returns: The data field or control field located at the given index.
    public func field(at index: Int) -> RecordField {
        return self.fields[index]
    }
}

extension Record {
    public func indexPaths(for fieldPath: FieldPath) -> [IndexPath] {
        return self.storage.indexPaths(for: fieldPath)
    }

    public func indexPaths(for tag: FieldTag) -> [IndexPath] {
        return self.storage.indexPaths(for: tag)
    }

    public func indexPaths(for tag: FieldTag, code: SubfieldCode) -> [IndexPath] {
        return self.storage.indexPaths(for: tag, code: code)
    }

    /// Get the record field referenced by the given index path.
    /// - parameter indexPath: The index path value pointing to the field or one of its subfields.
    /// - returns: The record field referenced by the index path.
    ///            If the index path points to a subfield, its field is returned.
    public func field(at indexPath: IndexPath) -> RecordField {
        return self.storage.field(at: indexPath) as RecordField
    }

    /// Get the subfield referenced by the given index path.
    /// - parameter indexPath: The index path value pointing to a specific subfield value.
    /// - returns: The subfield object referenced byt the index path.
    /// - note: This method will fatally error when given an index path that points to a field instead of its subfield,
    ///         or if the index path points into a control field instead of a data field.
    public func subfield(at indexPath: IndexPath) -> Subfield {
        return self.storage.subfield(at: indexPath) as Subfield
    }

    /// Get a string representation of the value stored at the given index path.
    /// - parameter indexPath: The index path of a control field, data field, or subfield.
    /// - returns: A string representation of the data within the referenced control field, data field, or subfield.
    public func content(at indexPath: IndexPath) -> String {
        return self.storage.content(at: indexPath)
    }

    public func content(with fieldPath: FieldPath) -> [String] {
        return self.storage.content(with: fieldPath)
    }
}

// MARK: - Bridging

extension Record: ReferenceConvertible {
    public typealias ReferenceType = BibRecord
}

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
