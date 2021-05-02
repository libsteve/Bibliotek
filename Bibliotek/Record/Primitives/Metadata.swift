//
//  Metadata.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// A collection of bytes embeded within a MARC record's leader.
///
/// The significance of these metadata values are specific to the scheme used to encode the MARC record.
/// The reserved bytes are located at index `7`, `8`, `17`, `18`, and `19` within the record leader.
///
/// Use a record's `kind` to determine how to interpret these metadata values.
public struct Metadata {
    private var _storage: BibMetadata!
    private var _mutableStorage: BibMutableMetadata!
    private var storage: BibMetadata! { return self._storage ?? self._mutableStorage }

    /// Retrieve the byte stored within the reserved position in the MARC record's leader.
    ///
    /// - parameter position: The index location of the desired byte in the record's leader.
    /// - returns: The byte held at the reserved location in the record's leader.
    public subscript(position: ReservedPosition) -> Int8 {
        get { return self.storage.value(forReservedPosition: position) }
        set {
            if self._mutableStorage ==  nil {
                precondition(self._storage != nil)
                self._mutableStorage = self._storage.mutableCopy() as? BibMutableMetadata
                self._storage = nil
            } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
                self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableMetadata
            }
            self._mutableStorage.setValue(newValue, forReservedPosition: position)
        }
    }

    public var kind: RecordKind {
        get { self.storage.recordKind }
        set { self.mutate(keyPath: \.recordKind, with: newValue) }
    }

    public var status: RecordStatus {
        get { self.storage.recordStatus }
        set { self.mutate(keyPath: \.recordStatus, with: newValue) }
    }

    public var encoding: Encoding {
        self.storage.encoding
    }

    public var bibliographicLevel: BibliographicLevel? {
        get {
            guard self.kind.isBibliographic else { return nil }
            return self.storage.__bibliographicLevel
        }
        set {
            guard let newValue = newValue,  self.kind.isBibliographic else {
                return
            }
            self.mutate(keyPath: \.__bibliographicLevel, with: newValue)
        }
    }

    public var bibliographicControlType: BibliographicControlType? {
        get {
            guard self.kind.isBibliographic else { return nil }
            return self.storage.__bibliographicControlType
        }
        set {
            guard let newValue = newValue,  self.kind.isBibliographic else {
                return
            }
            self.mutate(keyPath: \.__bibliographicControlType, with: newValue)
        }
    }

    private init(storage: BibMetadata) {
        self._storage = storage.copy() as? BibMetadata
    }

    /// Create an empty set of metadata.
    public init() {
        self._storage = BibMetadata()
    }

    private mutating func mutate<T>(keyPath: WritableKeyPath<BibMutableMetadata, T>, with newValue: T) {
        if self._mutableStorage == nil {
            precondition(self._storage != nil)
            self._mutableStorage = self._storage.mutableCopy() as? BibMutableMetadata
            self._storage = nil
        } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
            self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableMetadata
        }
        self._mutableStorage[keyPath: keyPath] = newValue
    }
}

extension Metadata: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: Metadata, rhs: Metadata) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension Metadata: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var debugDescription: String { return self.storage.debugDescription }

    public var playgroundDescription: Any {
        return ReservedPosition.allCases.map { String(format: "%c", self[$0]) }
    }
}

extension Metadata: ReferenceConvertible {
    public typealias ReferenceType = BibMetadata
}

extension Metadata: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibMetadata

    public func _bridgeToObjectiveC() -> BibMetadata {
        return self.storage.copy() as! BibMetadata
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibMetadata, result: inout Metadata?) {
        result = Metadata(storage: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibMetadata, result: inout Metadata?) -> Bool {
        result = Metadata(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibMetadata?) -> Metadata {
        return Metadata(storage: source!)
    }
}

extension BibMetadata: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as Metadata).playgroundDescription }
}

extension ReservedPosition: ExpressibleByIntegerLiteral, CaseIterable {
    public static var allCases: [ReservedPosition] = [.at07, .at08, .at17, .at18, .at19]

    public init?(rawValue: UInt) {
        switch rawValue {
        case ReservedPosition.at07.rawValue: self = .at07
        case ReservedPosition.at08.rawValue: self = .at08
        case ReservedPosition.at17.rawValue: self = .at17
        case ReservedPosition.at18.rawValue: self = .at18
        case ReservedPosition.at19.rawValue: self = .at19
        default: return nil
        }
    }

    public init(integerLiteral value: UInt) {
        self.init(rawValue: value)!
    }
}

extension Encoding: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { __BibEncodingDescription(self) }

    public var debugDescription: String {
        "Encoding(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any { self.description }
}

extension RecordStatus: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { __BibRecordStatusDescription(self) }

    public var debugDescription: String {
        "RecordStatus(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any { self.description }
}

extension BibliographicLevel: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { __BibBibliographicLevelDescription(self) }

    public var debugDescription: String {
        "RecordStatus(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any { self.description }
}

extension BibliographicControlType: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { __BibBibliographicControlTypeDescription(self) }

    public var debugDescription: String {
        "RecordStatus(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any { self.description }
}
