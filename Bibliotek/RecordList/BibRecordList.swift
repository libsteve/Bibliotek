//
//  BibRecordList.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension RecordList: Sequence, Collection {
    public var startIndex: UInt { return 0 }
    public var endIndex: UInt { return count }
    public func index(after i: UInt) -> UInt { return i + 1 }
    public func makeIterator() -> RecordListIterator {
        return RecordListIterator(__recordEnumerator())
    }
}

extension RecordList: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return allRecords
    }
}

public class RecordListIterator: IteratorProtocol {
    private let enumerator: NSEnumerator

    fileprivate init(_ enumerator: NSEnumerator) {
        self.enumerator = enumerator
    }

    public func next() -> Record? {
        return enumerator.nextObject() as? Record
    }
}
