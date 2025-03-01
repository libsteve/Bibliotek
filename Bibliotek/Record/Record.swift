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
/// [MARC 21 Record Structure](https://www.loc.gov/marc/specifications/spechome.html)
public struct Record: Sendable {
    /// The type of data represented by the record.
    ///
    /// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
    /// different schemas to present their information.
    ///
    /// Use this field to determine how tags and subfield codes should be used to interpret field content.
    public var kind: RecordKind {
        get { self.leader.recordKind }
        set { self.leader.recordKind = newValue }
    }

    /// The record's current status in the database it was fetched from.
    public var status: RecordStatus {
        get { self.leader.recordStatus }
        set { self.leader.recordStatus = newValue }
    }

    /// Implementation-defined metadata from the MARC record's leader.
    ///
    /// MARC records can have arbitrary implementation-defined data embedded in their leader.
    /// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
    ///
    /// Use this field to access those bytes, which should be interpreted using the scheme identified in `kind`.
    public var leader: Leader

    /// An ordered list of fields containing information and metadata about the record and its represented item.
    public var fields: [RecordField]

    /// Create a MARC 21 record with the given data.
    ///
    /// - parameter leader: A set of metadata describing the record, its encoding, and its state in the database.
    /// - parameter fields: An ordered list of fields describing the item represented by the record.
    public init(leader: Leader, fields: [RecordField]) {
        self.leader = leader
        self.fields = fields
    }
}

// MARK: -

extension Record: Hashable, Equatable {}

extension Record: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String {
        self.fields.map(\.debugDescription).joined(separator: "\n")
    }

    public var debugDescription: String {
        self.description
    }

    public var playgroundDescription: Any {
        ["kind": self.kind.description,
         "status": String(format: "%c", self.status.rawValue),
         "leader": self.leader,
         "fields": self.fields]
    }
}

extension Record: Collection, MutableCollection, RandomAccessCollection {
    public typealias Element = RecordField
    
    public var count: Int { self.fields.count }
    public var startIndex: Int { 0 }
    public var endIndex: Int { self.fields.endIndex }

    public subscript(index: Int) -> RecordField {
        _read { yield self.fields[index] }
        _modify { yield &self.fields[index] }
        set { self.fields[index] = newValue }
    }

    public mutating func replaceSubrange<C: Collection>(
        _ subrange: Indices, with newElements: C
    ) where C.Element == RecordField {
        self.fields.replaceSubrange(subrange, with: newElements)
    }
}

extension IteratorProtocol where Element == RecordField {
    public mutating func next(with tag: FieldTag) -> RecordField? {
        while let next = self.next() {
            if next.tag == tag {
                return next
            }
        }
        return nil
    }
}

extension Record {
    /// Test to see if the record contains a field with the given tag.
    ///
    /// - parameter tag: If this record has a field with this value, `true` is returned.
    /// - returns: `true` if at least one record field is marked with the given tag.
    public func containsField(with tag: FieldTag) -> Bool {
        return self.firstIndex(ofField: tag) != nil
    }

    /// Get the index of the first record field with the given tag.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - returns: The index of the first record field with the given tag. If no such field exists, `nil` is returned.
    public func firstIndex(ofField tag: FieldTag) -> Int? {
        self.fields.firstIndex(where: { $0.tag == tag })
    }

    /// Get the index of the first record field with the given tag after the given index.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - parameter range: The range of indices to search within for a field with the given tag.
    /// - returns: The index of the first record field with the given tag. If no such field exists, `nil` is returned.
    public func firstIndex(ofField tag: FieldTag, in range: Range<Int>) -> Int? {
        self.fields[range].firstIndex(where: { $0.tag == tag })
    }

    /// Get the index of the last record field with the given tag.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - returns: The index of the last record field with the given tag. If no such field exists, `nil` is returned.
    public func lastIndex(ofField tag: FieldTag) -> Int? {
        self.fields.lastIndex(where: { $0.tag == tag })
    }

    /// Get the index of the last record field with the given tag after the given index.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - parameter range: The range of indices to search within for a field with the given tag.
    /// - returns: The index of the last record field in the range with the given tag. If no such field exists, `nil` is returned.
    public func lastIndex(ofField tag: FieldTag, in range: Range<Int>) -> Int? {
        self.fields[range].lastIndex(where: { $0.tag == tag })
    }

    /// Get the field at the given index.
    /// 
    /// - parameter index: The index of the record field to access.
    /// - returns: The data field or control field located at the given index.
    public func field(at index: Int) -> RecordField {
        self.fields[index]
    }

    @available(macOS 15.0, iOS 18.0, macCatalyst 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func indices(ofField tag: FieldTag) -> RangeSet<Int> {
        self.fields.indices(where: { $0.tag == tag })
    }

    @available(macOS 15.0, iOS 18.0, macCatalyst 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func fields(at indices: RangeSet<Index>) -> DiscontiguousSlice<[RecordField]> {
        self.fields[indices]
    }
}

extension Record {
    /// Get the first record field with the given tag.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - returns: The first record field with the given tag. If no such field exists, `nil` is returned.
    public func firstField(with tag: FieldTag) -> RecordField? {
        self.firstIndex(ofField: tag).map(self.field(at:))
    }

    /// Get the first record field with the given tag.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - parameter range: The range of indices to search within for a field with the given tag.
    /// - returns: The first record field with the given tag. If no such field exists, `nil` is returned.
   public func firstField(with tag: FieldTag, in range: Range<Int>) -> RecordField? {
        self.fields[range].first(where: { $0.tag == tag })
    }

    /// Get the first record field with the given tag.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - returns: The last record field with the given tag. If no such field exists, `nil` is returned.
    public func lastField(with tag: FieldTag) -> RecordField? {
        self.lastIndex(ofField: tag).map(self.field(at:))
    }

    /// Get the first record field with the given tag.
    ///
    /// - parameter tag: The field tag marking the data field or control field to access.
    /// - parameter range: The range of indices to search within for a field with the given tag.
    /// - returns: The last record field with the given tag. If no such field exists, `nil` is returned.
    public func lastField(with tag: FieldTag, in range: Range<Int>) -> RecordField? {
        self.fields[range].last(where: { $0.tag == tag })
    }
}

extension Record {
    public func indexPaths(for fieldPath: FieldPath) -> [IndexPath] {
        if let code = fieldPath.code {
            return self.indexPaths(for: fieldPath.tag, code: code)
        } else {
            return self.indexPaths(for: fieldPath.tag)
        }
    }

    public func indexPaths(for tag: FieldTag) -> [IndexPath] {
        self.fields.enumerated().reduce(into: []) { result, element in
            guard element.element.tag == tag else { return }
            result.append(IndexPath(index: element.offset))
        }
    }

    public func indexPaths(for tag: FieldTag, code: SubfieldCode) -> [IndexPath] {
        self.fields.enumerated().reduce(into: []) { result, element in
            guard element.element.tag == tag else { return }
            element.element.subfields.enumerated().forEach { index, subfield in
                guard subfield.code == code else { return }
                result.append([element.offset, index])
            }
        }
    }

    /// Get the record field referenced by the given index path.
    /// 
    /// - parameter indexPath: The index path value pointing to the field or one of its subfields.
    /// - returns: The record field referenced by the index path.
    ///            If the index path points to a subfield, its field is returned.
    public func field(at indexPath: IndexPath) -> RecordField {
        guard indexPath.count >= 1, indexPath.count <= 2 else {
            fatalError("Invalid index path: \(indexPath). Must have 1 or 2 components.")
        }
        return self.fields[indexPath.first!]
    }

    /// Get the subfield referenced by the given index path.
    ///
    /// - parameter indexPath: The index path value pointing to a specific subfield value.
    /// - returns: The subfield object referenced by the index path.
    /// - note: This method will fatally error when given an index path that points to a field instead of its subfield,
    ///         or if the index path points into a control field instead of a data field.
    public func subfield(at indexPath: IndexPath) -> Subfield {
        precondition(indexPath.count == 2, "Invalid index path: \(indexPath). Must have exactly 2 components.")
        return self.field(at: indexPath[0]).subfield(at: indexPath[1])
    }

    /// Get a string representation of the value stored at the given index path.
    ///
    /// - parameter indexPath: The index path of a control field, data field, or subfield.
    /// - returns: A string representation of the data within the referenced control field, data field, or subfield.
    public func content(at indexPath: IndexPath) -> String {
        switch indexPath.count {
        case 1: return self.field(at: indexPath[0]).stringValue
        case 2: return self.field(at: indexPath[0]).subfield(at: indexPath[1]).content
        default: fatalError("Invalid index path: \(indexPath). Must have 1 or 2 components.")
        }
    }

    public func content(with fieldPath: FieldPath) -> [String] {
        self.indexPaths(for: fieldPath).map(self.content(at:))
    }
}

// MARK: - Bridging

extension Record: ReferenceConvertible {
    public typealias ReferenceType = BibRecord
}

extension Record: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibRecord

    public func _bridgeToObjectiveC() -> BibRecord {
        BibRecord(leader: self.leader, fields: self.fields)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibRecord, result: inout Record?) -> Bool {
        result = Record(leader: source.leader, fields: source.fields)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibRecord?) -> Record {
        guard let source else {
            return Record(leader: Leader(), fields: [])
        }
        return Record(leader: source.leader, fields: source.fields)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecord, result: inout Record?) {
        result = Record(leader: source.leader, fields: source.fields)
    }
}

extension BibRecord: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as Record).playgroundDescription }
}
