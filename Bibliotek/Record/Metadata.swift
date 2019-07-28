//
//  Metadata.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

public struct Metadata {
    private var _storage: BibMetadata!
    private var _mutableStorage: BibMutableMetadata!
    private var storage: BibMetadata! { return self._storage ?? self._mutableStorage }

    public subscript(position: ReservedPosition) -> Int8 {
        get { self.storage.value(forReservedPosition: position) }
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

    private init(storage: BibMetadata) {
        self._storage = storage.copy() as? BibMetadata
    }

    public init() {
        self._storage = BibMetadata()
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

extension Metadata: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { self.storage.description }

    public var playgroundDescription: Any {
        return ReservedPosition.allCases.map { String(format: "%c", self[$0]) }
    }
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

extension Encoding: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return __BibEncodingDescription(self) }

    public var playgroundDescription: Any { return self.description }
}

extension RecordKind: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    /// Does a record with this kind represent classification information?
    public var isClassification: Bool { return __BibRecordKindIsClassification(self) }

    /// Does a record with this kind represent bibliographic information?
    public var isBibliographic: Bool { return __BibRecordKindIsBibliographic(self) }

    public var description: String { return __BibRecordKindDescription(self) }

    public var playgroundDescription: Any { return self.description }
}
