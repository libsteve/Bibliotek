//
//  BibMARCSerialization.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/26/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

extension MARCSerialization {
    /// Create serialized data from a record encoded as MARC 21 data.
    /// - parameter record: The record to encode as MARC 21 data.
    /// - returns: Data containing the serialized representation of the given record.
    /// - throws: Throws an when the record cannot be serialized successfully.
    public class func data(with record: Record) throws -> Data {
        return try self.__data(with: record as BibRecord)
    }

    /// Create serialized data from an array of records encoded as MARC 21 data.
    /// - parameter records: The records to encode as MARC 21 data.
    /// - returns: Data containing the serialized representation of the given records.
    /// - throws: Throws an when the records cannot be serialized successfully.
    public class func data(with records: [Record]) throws -> Data {
        return try self.__dataWithRecords(in: records as [BibRecord])
    }

    /// Create an array of records from MARC 21 encoded data.
    /// - parameter data: The MARC 21 encoded data to decode.
    /// - returns: An array of `Record`s represented by the given data.
    /// - throws: Throws an when the records cannot be deserialized successfully.
    public class func records(from data: Data) throws -> [Record] {
        return try self.__records(from: data) as [Record]
    }

    /// Write a record to the given output stream as MARC 21 data.
    /// - parameter record: The record to encode as MARC 21 data.
    /// - parameter outputStream: The output stream to write the MARC 21 data to.
    /// - throws: Throws an error when the records cannot be serialized and written to the stream successfully.
    /// - precondition: The output stream must be open.
    public class func write(record: Record, to outputStream: OutputStream) throws {
        try self.__write(record as BibRecord, to: outputStream)
    }

    /// Read a record from the given output stream containing MARC 21 encoded data.
    /// - parameter inputStream: The input stream to read MARC 21 data from.
    /// - returns: The record represented by MARC 21 data from the given input stream.
    /// - throws: Throws an error when a record cannot be deserialized and read from the stream successfully.
    /// - precondition: The input stream must be open.
    public class func record(from inputStream: InputStream) throws -> Record {
        return try self.__record(from: inputStream) as Record
    }
}
