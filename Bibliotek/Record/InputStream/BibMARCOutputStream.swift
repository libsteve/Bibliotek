//
//  BibMARCOutputStream.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/25/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

extension MARCOutputStream {
    /// Write a `Record` as MARC 21 data to the output stream.
    ///
    /// - parameter record: The record to write to the output stream.
    /// - returns: `true` when the record was successfully written to the output stream. Otherwise, `no` is returned.
    /// - precondition: The output stream must be opened.
    /// - postcondition: If an error is thrown when the output stream is opened, `streamStatus` and `streamError` will
    ///                  be set `NSStreamStatusError` and the thrown error respectively.
    /// - note: An error is thrown if the output stream has not yet been opened, but `streamStatus` and `streamError`
    ///         will not be set to reflect that failure. Attempting to write to the output stream after it is opened
    ///         will continue to write data as though it did not previously encounter an error.
    public func write(record: Record) throws -> Bool {
        return try self.__write(record as BibRecord)
    }
}
