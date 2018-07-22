//
//  BibMarcRecordField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension MarcRecord.Field {
    public var indicators: (first: MarcRecord.FieldIndicator, second: MarcRecord.FieldIndicator) {
        return (__firstIndicator, __secondIndicator)
    }
}

extension MarcRecord.Field: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}
