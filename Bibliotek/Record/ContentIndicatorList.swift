//
//  ContentIndicatorList.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/26/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

public struct ContentIndicatorList {
    private var _storage: BibContentIndicatorList!
    private var _mutableStorage: BibMutableContentIndicatorList!
    private var storage: BibContentIndicatorList! { return self._storage ?? self._mutableStorage }

    public var count: Int { return Int(self.storage.count) }

    public subscript(index: Int) -> ContentIndicator {
        get { return self.storage.indicator(at: UInt(index)) }
        set {
            if self._mutableStorage == nil {
                precondition(self._storage != nil)
                self._mutableStorage = self._storage.mutableCopy() as? BibMutableContentIndicatorList
                self._storage = nil
            } else if !isKnownUniquelyReferenced(&self._mutableStorage) {
                self._mutableStorage = self._mutableStorage.mutableCopy() as? BibMutableContentIndicatorList
            }
            self._mutableStorage.setIndicator(newValue, at: UInt(index))
        }
    }

    private init(storage: BibContentIndicatorList) {
        self._storage = storage.copy() as? BibContentIndicatorList
    }

    public init<S>(indicators: S) where S: Sequence, S.Element == ContentIndicator {
        self._storage = Array(indicators).withUnsafeBufferPointer { buffer in
            guard let pointer = buffer.baseAddress else { return BibMutableContentIndicatorList() }
            return BibContentIndicatorList(indicators: pointer, count: UInt(buffer.count))
        }
    }
}

// MARK: - MARC 21 Content Indicators

extension ContentIndicatorList {
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

extension ContentIndicatorList: ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
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

extension ContentIndicatorList: Sequence, Collection, BidirectionalCollection, RandomAccessCollection {
    public struct Iterator: IteratorProtocol {
        public typealias Element = ContentIndicator

        private var index: Int = 0
        private var indicators: ContentIndicatorList

        internal init(indicators: ContentIndicatorList) {
            self.indicators = indicators
        }

        public mutating func next() -> ContentIndicator? {
            guard self.index < self.indicators.count else { return nil }
            defer { self.index += 1 }
            return self.indicators[self.index];
        }
    }

    public func makeIterator() -> ContentIndicatorList.Iterator {
        return Iterator(indicators: self)
    }

    public var startIndex: Int { return 0 }

    public var endIndex: Int { return self.count }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}

extension ContentIndicatorList: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }

    public static func == (lhs: ContentIndicatorList, rhs: ContentIndicatorList) -> Bool {
        return lhs.storage.isEqual(to: rhs.storage)
    }
}

extension ContentIndicatorList: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self.storage.description }

    public var playgroundDescription: Any { return self.storage.description }
}

// MARK: - Bridging

extension ContentIndicatorList: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibContentIndicatorList

    public func _bridgeToObjectiveC() -> BibContentIndicatorList {
        return self.storage.copy() as! BibContentIndicatorList
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibContentIndicatorList, result: inout ContentIndicatorList?) {
        result = ContentIndicatorList(storage: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibContentIndicatorList, result: inout ContentIndicatorList?) -> Bool {
        result = ContentIndicatorList(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibContentIndicatorList?) -> ContentIndicatorList {
        return ContentIndicatorList(storage: source!)
    }
}

extension BibContentIndicatorList: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as ContentIndicatorList).playgroundDescription }
}
