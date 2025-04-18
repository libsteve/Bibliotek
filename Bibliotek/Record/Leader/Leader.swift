//
//  Leader.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/31/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

import Foundation

extension LeaderValue: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        precondition(value.isASCII && 0x20 as UInt32 ..< 0x7F ~= value.value,
                     "Leader value must be an ASCII printable character.")
        self.init(CChar(truncatingIfNeeded: value.value))
    }
}

extension LeaderValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CChar) {
        precondition(0x20 as CChar ..< 0x7F ~= value,
                     "Leader value must be an ASCII printable character.")
        self.init(value)
    }
}

extension LeaderValue: Strideable {
    public typealias Stride = Int

    public func distance(to other: LeaderValue) -> Int {
        self.rawValue.distance(to: other.rawValue)
    }

    public func advanced(by n: Int) -> LeaderValue {
        LeaderValue(self.rawValue.advanced(by: n))
    }
}

/// A collection of metadata preceding a the encoded data for a record.
///
/// The record leader provides information about the layout of data within a record, and the semantics to use
/// when interpreting record data. Such information includes the total size in memory of the record, the layout
/// of fields' tags and indicators, and other miscellaneous metadata.
///
/// The bytes located at index `07`, `08`, `17`, `18`, and `19` within the record leader are reserved for
/// implementation-defined semantics. Use the leader's `recordKind` to determine how to interpret these values.
///
/// More information about the MARC 21 leader can be found in
/// [the Library of Congress's documentation on MARC 21 Record Structure][record-structure].
///
/// [record-structure]: (https://www.loc.gov/marc/specifications/specrecstruc.html#leader)
public struct Leader: @unchecked Sendable {
    private var _storage: BibLeader!
    private var _mutableStorage: BibMutableLeader!
    private var storage: BibLeader! { return self._storage ?? self._mutableStorage }

    /// The 24-byte encoded representation of the leader's data.
    ///
    /// All 24 bytes within the record leader are visible ASCII characters.
    public var rawValue: Data {
        get { self.storage.rawValue }
        set { self.mutate(keyPath: \.rawValue, with: newValue) }
    }

    /// A MARC record leader is always exactly 24 bytes of visible ASCII characters.
    public static var rawValueLength: Int {
        BibLeader.rawValueLength
    }

    public subscript(location: LeaderLocation) -> LeaderValue {
        get { self.leaderValue(at: location) }
        set { self.setLeaderValue(newValue, at: location) }
    }

    public func leaderValue(at location: LeaderLocation) -> LeaderValue {
        self.storage.leaderValue(at: location)
    }

    public mutating func setLeaderValue(_ value: LeaderValue, at location: LeaderLocation) {
        if self._mutableStorage == nil {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableLeader
            self._storage = nil
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableLeader
        }
        self._mutableStorage.setLeaderValue(value, at: location)
    }

    /// The type of data represented by the record.
    ///
    /// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
    /// different schemas to present their information.
    public var recordKind: RecordKind! {
        get { RecordKind.init(rawValue: self[.recordKind].rawValue) }
        set { self[.recordKind] = LeaderValue(newValue.rawValue) }
    }

    /// The record's current status in the database it was fetched from.
    public var recordStatus: RecordStatus! {
        get { RecordStatus(rawValue: self[.recordStatus].rawValue) }
        set { self[.recordStatus] = LeaderValue(newValue.rawValue) }
    }

    /// The character encoding used to represent textual information within the record.
    public var recordEncoding: Encoding {
        self.storage.recordEncoding
    }

    /// The range of bytes that contain the record's fields.
    public var recordRange: Range<Int> {
        Range(self.storage.recordRange)!
    }

    /// The specificity used to identify the item represented by a bibliographic record.
    public var bibliographicLevel: BibliographicLevel? {
        get {
            guard self.recordKind.isBibliographic else { return nil }
            return self.storage.__bibliographicLevel
        }
        set {
            guard let newValue = newValue,  self.recordKind.isBibliographic else {
                return
            }
            self.mutate(keyPath: \.__bibliographicLevel, with: newValue)
        }
    }

    /// The ruleset used to determine the information about the item that's included in the record.
    public var bibliographicControlType: BibliographicControlType? {
        get {
            guard self.recordKind.isBibliographic else { return nil }
            return self.storage.__bibliographicControlType
        }
        set {
            guard let newValue = newValue,  self.recordKind.isBibliographic else {
                return
            }
            self.mutate(keyPath: \.__bibliographicControlType, with: newValue)
        }
    }

    public var lengthOfLengthOfField: Int {
        Int(self.storage.lengthOfLengthOfField)
    }

    public var lengthOfFieldLocation: Int {
        Int(self.storage.lengthOfFieldLocation)
    }

    public var numberOfIndicators: Int {
        Int(self.storage.numberOfIndicators)
    }

    public var lengthOfSubfieldCode: Int {
        Int(self.storage.lengthOfSubfieldCode)
    }

    private init(storage: BibLeader) {
        self._storage = storage.copy() as? BibLeader
    }

    /// Create an empty leader for a MARC 21 record.
    public init() {
        self._storage = BibLeader()
    }

    /// Create the leader for a MARC 21 record.
    ///
    /// - parameter data: A buffer of 24 bytes in which leader data is encoded.
    ///
    /// More information about the MARC 21 leader can be found in
    /// [the Library of Congress's documentation on MARC 21 Record Structure][record-structure].
    ///
    /// [record-structure]: (https://www.loc.gov/marc/specifications/specrecstruc.html#leader)
    public init?(data: Data) {
        guard let storage = BibLeader(data: data) else {
            return nil
        }
        self._storage = storage
    }

    /// Create the leader for a MARC 21 record.
    ///
    /// - parameter string: The raw string representation of the leader data.
    /// - returns Returns a new record leader backed by the given string value.
    public init?(string: String) {
        guard let storage = BibLeader(string: string) else {
            return nil
        }
        self._storage = storage
    }

    private mutating func mutate<T>(keyPath: WritableKeyPath<BibMutableLeader, T>, with newValue: T) {
        if self._mutableStorage == nil {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableLeader
            self._storage = nil
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableLeader
        }
        self._mutableStorage[keyPath: keyPath] = newValue
    }
}

extension Leader: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: Leader, rhs: Leader) -> Bool {
        return lhs.storage.isEqual(rhs.storage)
    }
}

extension Leader: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let storage = BibLeader(string: value) else {
            fatalError("Invalid MARC 21 Leader: \(value)")
        }
        self._storage = storage
    }
}

extension Leader: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var debugDescription: String { return self.storage.debugDescription }

    public var playgroundDescription: Any {
        self.description
    }
}

extension Leader: ReferenceConvertible {
    public typealias ReferenceType = BibLeader
}

extension Leader: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibLeader

    public func _bridgeToObjectiveC() -> BibLeader {
        return self.storage.copy() as! BibLeader
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibLeader, result: inout Leader?) {
        result = Leader(storage: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibLeader, result: inout Leader?) -> Bool {
        result = Leader(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibLeader?) -> Leader {
        return Leader(storage: source!)
    }
}

extension BibLeader {
    /// A MARC record leader is always exactly 24 bytes of visible ASCII characters.
    public static let rawValueLength: Int = Int(__BibLeaderRawDataLength)
}

extension BibLeader: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as Leader).playgroundDescription }
}
