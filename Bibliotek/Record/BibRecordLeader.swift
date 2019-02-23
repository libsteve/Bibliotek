//
//  BibRecordLeader.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.Leader: RawRepresentable {
    public var rawValue: String { return stringValue }

    public required convenience init?(rawValue: String) {
        self.init(string: rawValue)
    }
}

extension Record.Leader: CustomReflectable {
    public var customMirror: Mirror {
        return Mirror(reflecting: stringValue)
    }
}
