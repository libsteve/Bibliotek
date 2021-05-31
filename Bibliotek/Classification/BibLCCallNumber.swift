//
//  BibLCCallNumber.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

/// More information about Library of Congress Classification can be found at
/// https://www.librarianshipstudies.com/2017/11/library-of-congress-classification.html
public struct LCCallNumber {
    private var storage: BibLCCallNumber

    /// Create a Library of Congress call number with the given string representation.
    /// - parameter string: The string value of the call number.
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

/// The classification comparison operator.
infix operator <<>> : ComparisonPrecedence

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

    /// Determine the ordering relationship between the subject matters represented by two call numbers.
    ///
    /// The classification `HQ76` is ordered before `QA76`.
    ///
    /// The classification `QA76.76` is ordered before `QA76.9`.
    ///
    /// The classification `P35` is ordered before `P112`.
    ///
    /// The classification `P327` is ordered before `PC5615`.
    ///
    /// The classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`,
    /// but does not include the classification `QA70`, nor its parent classification `QA`.
    ///
    /// - parameter callNumber: The call number being compared with the receiver.
    /// - returns:
    ///     - `.generalizing` when the given call number's represented subject matter includes that
    ///       represented by the receiver. The given call number, being a generalization of the receiver,
    ///       is necessarily ordered linearly before the receiver.
    ///     - `.descending` when the given call number is ordered before the receiver.
    ///     - `.same` when the given call number is equivalent to the receiver.
    ///     - `.ascending` when the given call number is ordered after the receiver.
    ///     - `.specifying` when the given call number's represented subject matter is included
    ///       in that represented by the receiver. The given call number, being a specialization of the receiver,
    ///       is necessarily ordered linearly after the receiver.
    @available(*, deprecated, message: "Use the <<>> operator")
    public func compare(with callNumber: LCCallNumber) -> ClassificationComparisonResult {
        return self.storage.compare(with: callNumber.storage)
    }

    /// Determine the ordering relationship between the subject matters represented by two call numbers.
    ///
    /// The classification `HQ76` is ordered before `QA76`.
    ///
    /// The classification `QA76.76` is ordered before `QA76.9`.
    ///
    /// The classification `P35` is ordered before `P112`.
    ///
    /// The classification `P327` is ordered before `PC5615`.
    ///
    /// The classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`,
    /// but does not include the classification `QA70`, nor its parent classification `QA`.
    ///
    /// - parameter callNumber: The call number being compared with the receiver.
    /// - returns:
    ///     - `.generalizing` when the given call number's represented subject matter includes that
    ///       represented by the receiver. The given call number, being a generalization of the receiver,
    ///       is necessarily ordered linearly before the receiver.
    ///     - `.descending` when the given call number is ordered before the receiver.
    ///     - `.same` when the given call number is equivalent to the receiver.
    ///     - `.ascending` when the given call number is ordered after the receiver.
    ///     - `.specifying` when the given call number's represented subject matter is included
    ///       in that represented by the receiver. The given call number, being a specialization of the receiver,
    ///       is necessarily ordered linearly after the receiver.
    public static func <<>> (lhs: LCCallNumber, rhs: LCCallNumber) -> ClassificationComparisonResult {
        return lhs.storage.compare(with: rhs.storage)
    }

    /// Does the subject matter represented by this call number include that of the given call number?
    ///
    /// For example, the classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`,
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

    /// Attributes describing the format of a string value representing a Library of Congress call number.
    public typealias FormatOptions = BibLCCallNumber.FormatOptions

    /// Create a string representation of the call number using the given style attributes.
    /// - parameter formatOptions: Attributes describing the format of the resulting string value.
    /// - returns: A string representation of the call number in a format described by the given attributes.
    public func string(formatOptions: FormatOptions) -> String {
        self.storage.string(formatOptions: formatOptions)
    }
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
