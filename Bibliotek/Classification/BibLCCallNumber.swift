//
//  BibLCCallNumber.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

public struct LCCallNumber {
    private var storage: BibLCCallNumber

    public init?(_ string: String) {
        guard let storage = BibLCCallNumber(string: string) else { return nil }
        self.storage = storage
    }

    private init(storage: BibLCCallNumber) {
        self.storage = storage
    }
}

extension LCCallNumber: RawRepresentable {
    public typealias RawValue = String

    public var rawValue: String { return self.storage.stringValue }

    public init?(rawValue: RawValue) {
        self.init(rawValue)
    }
}

extension LCCallNumber: Hashable, Equatable, Comparable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }

    public static func == (lhs: LCCallNumber, rhs: LCCallNumber) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }

    public static func < (lhs: LCCallNumber, rhs: LCCallNumber) -> Bool {
        return lhs.storage.compare(rhs.storage) == .orderedAscending
    }

    public static func > (lhs: LCCallNumber, rhs: LCCallNumber) -> Bool {
        return lhs.storage.compare(rhs.storage) == .orderedDescending
    }
}

extension LCCallNumber: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.rawValue }

    public var playgroundDescription: Any { return self.rawValue }
}

// MARK: Bridging

extension LCCallNumber: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibLCCallNumber

    public func _bridgeToObjectiveC() -> BibLCCallNumber {
        return self.storage
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: BibLCCallNumber,
                                                          result: inout LCCallNumber?) -> Bool {
        result = LCCallNumber(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibLCCallNumber?) -> LCCallNumber {
        return LCCallNumber(storage: source!)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibLCCallNumber, result: inout LCCallNumber?) {
        result = LCCallNumber(storage: source)
    }
}

extension BibLCCallNumber: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return self.description }
}
