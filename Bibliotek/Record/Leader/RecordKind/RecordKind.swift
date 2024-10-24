//
//  RecordKind.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension RecordKind: RawRepresentable {
    public typealias RawValue = UInt8
}

extension RecordKind: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return self.description }
}
