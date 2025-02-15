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
public struct LCCallNumber: Sendable {
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
        return lhs.storage.isEqual(to: rhs)
    }

    public static func < (lhs: LCCallNumber, rhs: LCCallNumber) -> Bool {
        return lhs.storage.compare(rhs) == ComparisonResult.orderedAscending
    }

    public static func > (lhs: LCCallNumber, rhs: LCCallNumber) -> Bool {
        return lhs.storage.compare(rhs) == ComparisonResult.orderedDescending
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
    ///
    /// ## Return Value
    ///
    /// - ``ClassificationComparisonResult/generalizing`` when the given call number's represented subject matter includes that
    ///   represented by the receiver. The given call number, being a generalization of the receiver,
    ///   is necessarily ordered linearly before the receiver.
    /// - ``ClassificationComparisonResult/descending`` when the given call number is ordered before the receiver.
    /// - ``ClassificationComparisonResult/same`` when the given call number is equivalent to the receiver.
    /// - ``ClassificationComparisonResult/ascending`` when the given call number is ordered after the receiver.
    /// - ``ClassificationComparisonResult/specifying`` when the given call number's represented subject matter is included
    ///   in that represented by the receiver. The given call number, being a specialization of the receiver,
    ///   is necessarily ordered linearly after the receiver.
    ///
    /// ## Example
    ///
    /// The classification `HQ76` is ordered before `QA76`.
    ///
    /// ```swift
    /// LCCallNumber("HQ76")!.compare(with: LCCallNumber("QA76")!) == .ascending
    /// ```
    ///
    /// The classification `QA76.76` is ordered before `QA76.9`.
    ///
    /// ```swift
    /// LCCallNumber("QA76.76").compare(with: LCCallNumber("QA76.9"))! == .ascending
    /// ```
    ///
    /// The classification `P35` is ordered before `P112`.
    ///
    /// ```swift
    /// LCCallNumber("P35").compare(with: LCCallNumber("P112")!) == .ascending
    /// ```
    ///
    /// The classification `P327` is ordered before `PC5615`.
    ///
    /// ```swift
    /// LCCallNumber("P327").compare(with: LCCallNumber("PC5615")!) == .ascending
    /// ```
    ///
    /// The classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`.
    ///
    /// ```swift
    /// LCCallNumber("QA76").compare(with: LCCallNumber("QA76.76)")! == .specifying
    /// LCCallNumber("QA76").compare(with: LCCallNumber("QA76.75)")! == .specifying
    /// ```
    ///
    /// The classification `QA76` does not include the classification `QA70`, nor its parent classification `QA`.
    ///
    /// ```swift
    /// LCCallNumber("QA76").compare(with: LCCallNumber("QA70")!) == .descending
    /// LCCallNumber("QA76").compare(with: LCCallNumber("QA")!) == .generalizing
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``<<>>(_:_:)``
    /// - ``includes(_:)``
    public func compare(with callNumber: LCCallNumber) -> ClassificationComparisonResult {
        return self.storage.compare(with: callNumber)
    }

    /// Determine the ordering relationship between the subject matters represented by two call numbers.
    ///
    /// - parameter lhs: The call number on the left side of the operator.
    /// - parameter rhs: The call number on the right side of the operator.
    ///
    /// ## Return Value
    ///
    /// - ``ClassificationComparisonResult/generalizing`` when the given call number's represented subject matter includes that
    ///   represented by the receiver. The given call number, being a generalization of the receiver,
    ///   is necessarily ordered linearly before the receiver.
    /// - ``ClassificationComparisonResult/descending`` when the given call number is ordered before the receiver.
    /// - ``ClassificationComparisonResult/same`` when the given call number is equivalent to the receiver.
    /// - ``ClassificationComparisonResult/ascending`` when the given call number is ordered after the receiver.
    /// - ``ClassificationComparisonResult/specifying`` when the given call number's represented subject matter is included
    ///   in that represented by the receiver. The given call number, being a specialization of the receiver,
    ///   is necessarily ordered linearly after the receiver.
    ///
    /// ## Example
    ///
    /// The classification `HQ76` is ordered before `QA76`.
    ///
    /// ```swift
    /// LCCallNumber("HQ76")! <<>> LCCallNumber("QA76")! == .ascending
    /// ```
    ///
    /// The classification `QA76.76` is ordered before `QA76.9`.
    ///
    /// ```swift
    /// LCCallNumber("QA76.76")! <<>> LCCallNumber("QA76.9")! == .ascending
    /// ```
    ///
    /// The classification `P35` is ordered before `P112`.
    ///
    /// ```swift
    /// LCCallNumber("P35")! <<>> LCCallNumber("P112")! == .ascending
    /// ```
    ///
    /// The classification `P327` is ordered before `PC5615`.
    ///
    /// ```swift
    /// LCCallNumber("P327")! <<>> LCCallNumber("PC5615")! == .ascending
    /// ```
    ///
    /// The classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`.
    ///
    /// ```swift
    /// LCCallNumber("QA76")! <<>> LCCallNumber("QA76.76")! == .specifying
    /// LCCallNumber("QA76")! <<>> LCCallNumber("QA76.75")! == .specifying
    /// ```
    ///
    /// The classification `QA76` does not include the classification `QA70`, nor its parent classification `QA`.
    ///
    /// ```swift
    /// LCCallNumber("QA76")! <<>> LCCallNumber("QA70")! == .descending
    /// LCCallNumber("QA76")! <<>> LCCallNumber("QA")! == .generalizing
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``compare(with:)``
    /// - ``includes(_:)``
    public static func <<>> (lhs: LCCallNumber, rhs: LCCallNumber) -> ClassificationComparisonResult {
        return lhs.storage.compare(with: rhs)
    }

    /// Does the subject matter represented by this call number include that of the given call number?
    ///
    /// - parameter callNumber: The call number whose subject matter may be a subset of the receiver's.
    /// - returns: `true` when the given call number belongs within the receiver's domain.
    ///
    /// For example, the classification `QA76` encompasses the more specific classifications `QA76.76` and `QA76.75`,
    /// but does not include the classification `QA70`, nor its parent classification `QA`.
    ///
    /// ## See Also
    ///
    /// - ``<<>>(_:_:)``
    /// - ``compare(with:)``
    public func includes(_ callNumber: LCCallNumber) -> Bool {
        return self.storage.includes(callNumber)
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

extension ClassificationComparisonResult {
    @available(*, deprecated, renamed: "orderedSpecifying")
    public static let specifying: Self = .orderedSpecifying

    @available(*, deprecated, renamed: "orderedAscending")
    public static let ascending: Self = .orderedAscending

    @available(*, deprecated, renamed: "orderedSame")
    public static let same: Self = .orderedSame

    @available(*, deprecated, renamed: "orderedDescending")
    public static let descending: Self = .orderedDescending

    @available(*, deprecated, renamed: "orderedGeneralizing")
    public static let generalizing: Self = .orderedGeneralizing
}
