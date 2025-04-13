//
//  MultipartResourceRecordLevel.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 4/13/25.
//  Copyright © 2025 Steve Brunwasser. All rights reserved.
//

extension MultipartResourceRecordLevel: CustomStringConvertible,
                                        CustomDebugStringConvertible,
                                        CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibMultipartResourceRecordLevelDescription(self)
    }

    public var debugDescription: String {
        "\(Self.self)(rawValue: \"\(rawValue)\"): \(self)"
    }

    public var playgroundDescription: Any {
        self.description
    }
}
