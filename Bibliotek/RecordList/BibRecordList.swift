//
//  BibRecordList.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension RecordList {
    public var count: Int { return Int(self.__count) }

    /// A list of all records in this collection.
    public var allRecords: [Record] { return self.__allRecords as [Record] }

    public var first: Record? { return self.__firstRecord as Record? }

    public var last: Record? { return self.__lastRecord as Record? }

    public subscript(index: Int) -> Record {
        return self.__record(at: UInt(index)) as Record
    }
}

extension RecordList: Sequence, Collection, BidirectionalCollection, RandomAccessCollection {
    public struct Iterator: IteratorProtocol {
        private var enumerator: NSEnumerator

        fileprivate init(_ enumerator: NSEnumerator) {
            self.enumerator = enumerator
        }

        public mutating func next() -> Record? {
            if !isKnownUniquelyReferenced(&self.enumerator) {
                self.enumerator = self.enumerator.copy() as! NSEnumerator
            }
            return self.enumerator.nextObject() as? Record
        }
    }

    public func makeIterator() -> RecordList.Iterator {
        return RecordList.Iterator(self.__recordEnumerator())
    }

    public var startIndex: Int { return 0 }

    public var endIndex: Int { return self.count }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}

extension RecordList: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return self.allRecords }
}
