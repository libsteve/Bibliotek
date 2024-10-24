//
//  Encoding.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 10/20/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Encoding: CustomStringConvertible,
                    CustomDebugStringConvertible,
                    CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibEncodingDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(Unicode.Scalar(UInt8(self.rawValue)))\"): \(self.description)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
