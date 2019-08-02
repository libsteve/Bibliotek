//
//  BibMARCInputStream.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/2/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension MARCInputStream {
    /// Read a `Record` from the MARC 21 data in the input stream.

    /// - returns: A `Record` read from the input stream.
    /// - precondition: The input stream must be opened.
    /// - postcondition: If an error is thrown when the input stream is opened, `streamStatus` and `streamError` will
    ///                  be set `NSStreamStatusError` and the thrown error respectively.
    /// - note: An error is thrown if the input stream has not yet been opened, but `streamStatus` and `streamError`
    ///         will not be set to reflect that failure. Attempting to read from the input stream after it is opened
    ///         will attempt to read data as though it did not previously encounter an error.
    public func readRecord() throws -> Record {
        return try self.__readRecord() as Record
    }
}
