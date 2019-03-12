//
//  BibGenericRecordDataField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.DataField: CustomReflectable {
    public var customMirror: Mirror {
        let ind: [String] = indicators.map { $0.rawValue }
        let children: [Mirror.Child] = [(label: "tag", value: tag.rawValue),
                                        (label: "indicators", value: ind),
                                        (label: "subfields", value: subfields)]
        return Mirror(self, children: children, displayStyle: .dictionary, ancestorRepresentation: .suppressed)
    }
}
