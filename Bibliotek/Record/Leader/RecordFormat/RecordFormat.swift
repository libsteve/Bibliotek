//
//  RecordFormat.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/21/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

import Foundation

extension RecordFormat: CustomStringConvertible,
                        CustomDebugStringConvertible,
                        CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibRecordFormatDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
