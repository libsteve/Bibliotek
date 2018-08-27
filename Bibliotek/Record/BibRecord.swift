//
//  BibRecord.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/12/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibRecord: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description.split(separator: "\n").map { $0.dropFirst().dropLast().description }
    }
}

// MARK: - Swift Native

public struct Record {
    private var record: BibMutableRecord

    internal init(record: BibRecordProtocol) {
        self.record = BibMutableRecord(recordStore: record)
    }

    public init() {
        record = BibMutableRecord()
    }

    public init(title: String) {
        record = BibMutableRecord(title: title)
    }

    public init(title: String, database: String) {
        record = BibMutableRecord(title: title, database: database)
    }
}

extension Record: RecordProtocol {
    public var database: String {
        get { return record.database }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.database = newValue
        }
    }

    public var isbn10: String? {
        get { return record.isbn10 }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.isbn10 = newValue
        }
    }

    public var isbn13: String? {
        get { return record.isbn13 }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.isbn13 = newValue
        }
    }

    public var callNumbers: [CallNumber] {
        get { return record.callNumbers }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.callNumbers = newValue
        }
    }

    public var title: String {
        get { return record.title }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.title = newValue
        }
    }

    public var subtitles: [String] {
        get { return record.subtitles }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.subtitles = newValue
        }
    }

    public var authors: [String] {
        get { return record.authors }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.authors = newValue
        }
    }

    public var contributors: [String] {
        get { return record.contributors }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.contributors = newValue
        }
    }

    public var editions: [String] {
        get { return record.editions }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.editions = newValue
        }
    }

    public var subjects: [String] {
        get { return record.subjects }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.subjects = newValue
        }
    }

    public var summaries: [String] {
        get { return record.summaries }
        set {
            if !isKnownUniquelyReferenced(&record) {
                record = record.mutableCopy() as! BibMutableRecord
            }
            record.summaries = newValue
        }
    }
}

// MARK: - Objective-C Bridging

extension Record: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> BibRecordProtocol {
        return record.copy() as! BibRecord
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecordProtocol, result: inout Record?) {
        result = Record(record: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibRecordProtocol, result: inout Record?) -> Bool {
        result = Record(record: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibRecordProtocol?) -> Record {
        return source.map(Record.init(record:)) ?? Record()
    }
}
