//
//  BibRecordField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.Field {
    public var indicators: (first: Record.FieldIndicator, second: Record.FieldIndicator) {
        return (__firstIndicator, __secondIndicator)
    }
}

extension Record.Field: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}
