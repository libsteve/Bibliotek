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
        return lhs.storage.compare(rhs.storage) == ComparisonResult.orderedAscending
    }

    public static func > (lhs: LCCallNumber, rhs: LCCallNumber) -> Bool {
        return lhs.storage.compare(rhs.storage) == ComparisonResult.orderedDescending
    }

    public func compare(with callNumber: LCCallNumber) -> ClassificationComparisonResult {
        return self.storage.compare(with: callNumber as BibLCCallNumber)
    }

    /// Does the subject matter represented by this call number include that of the given call number?
    ///
    /// For example, the calssification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`,
    /// but does not include the classification `QA70`, nor its parent classification `QA`.
    ///
    /// - parameter callNumber: The call number whose subject matter may be a subset of the receiver's.
    /// - returns: `true` when the given call number belongs within the receiver's domain.
    public func includes(_ callNumber: LCCallNumber) -> Bool {
        return self.storage.includes(callNumber.storage)
    }
}

extension LCCallNumber: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.rawValue }

    public var debugDescription: String { return self.rawValue }

    public var playgroundDescription: Any { return self.rawValue }
}

// MARK: Bridging

extension LCCallNumber: ReferenceConvertible {
    public typealias ReferenceType = BibLCCallNumber
}

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
