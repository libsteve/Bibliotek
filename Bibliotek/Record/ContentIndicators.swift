//
//  ContentIndicator.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

public struct ContentIndicators {
    private var _storage: BibContentIndicators!
    private var _mutableStorage: BibMutableContentIndicators!
    private var storage: BibContentIndicators! { return self._storage ?? self._mutableStorage }

    public var count: Int { return Int(self.storage.count) }

    public subscript(index: Int) -> ContentIndicator {
        get { return self.storage.indicator(at: UInt(index)) }
        set {
            if self._mutableStorage == nil {
                precondition(self._storage != nil)
                self._mutableStorage = self._storage.mutableCopy() as? BibMutableContentIndicators
                self._storage = nil
            } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
                self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableContentIndicators
            }
            self._mutableStorage.setIndicator(newValue, at: UInt(index))
        }
    }

    private init(storage: BibContentIndicators) {
        self._storage = storage.copy() as? BibContentIndicators
    }

    public init<S>(indicators: S) where S: Sequence, S.Element == ContentIndicator {
        self._storage = Array(indicators).withUnsafeBufferPointer { buffer in
            guard let pointer = buffer.baseAddress else { return BibMutableContentIndicators() }
            return BibContentIndicators(indicators: pointer, count: UInt(buffer.count))
        }
    }
}

// MARK: - MARC 21 Content Indicators

extension ContentIndicators {
    public var first: ContentIndicator {
        get { return self[0] }
        set { self[0] = newValue }
    }

    public var second: ContentIndicator {
        get { return self[1] }
        set { self[1] = newValue }
    }

    public init(first: ContentIndicator, second: ContentIndicator) {
        self.init(indicators: [first, second])
    }
}

// MARK: -

extension ContentIndicators: ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
    public init(arrayLiteral elements: ContentIndicator...) {
        self.init(indicators: elements)
    }

    public init(stringLiteral value: String) {
        self.init(indicators: value.cString(using: .ascii)!.map(ContentIndicator.init(_:)))
    }
}

extension ContentIndicator: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let bytes = value.cString(using: .ascii)!
        precondition(bytes.count == 1, "A content indicatior is exactly one ASCII character.")
        self.init(bytes.first!)
    }
}

extension ContentIndicators: Sequence, Collection, BidirectionalCollection, RandomAccessCollection {
    public struct Iterator: IteratorProtocol {
        public typealias Element = ContentIndicator

        private var index: Int = 0
        private var indicators: ContentIndicators

        internal init(indicators: ContentIndicators) {
            self.indicators = indicators
        }

        public mutating func next() -> ContentIndicator? {
            guard self.index < self.indicators.count else { return nil }
            defer { self.index += 1 }
            return self.indicators[self.index];
        }
    }

    public func makeIterator() -> ContentIndicators.Iterator {
        return Iterator(indicators: self)
    }

    public var startIndex: Int { return 0 }

    public var endIndex: Int { return self.count }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}

extension ContentIndicators: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: ContentIndicators, rhs: ContentIndicators) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension ContentIndicators: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var playgroundDescription: Any { return self.storage.description }
}

// MARK: - Bridging

extension ContentIndicators: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibContentIndicators

    public func _bridgeToObjectiveC() -> BibContentIndicators {
        return self.storage.copy() as! BibContentIndicators
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibContentIndicators, result: inout ContentIndicators?) {
        result = ContentIndicators(storage: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibContentIndicators, result: inout ContentIndicators?) -> Bool {
        result = ContentIndicators(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibContentIndicators?) -> ContentIndicators {
        return ContentIndicators(storage: source!)
    }
}

extension BibContentIndicators: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as ContentIndicators).playgroundDescription }
}
